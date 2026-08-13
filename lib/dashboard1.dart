import 'package:flutter/material.dart';
import 'dart:ui'; // Import this for ImageFilter
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_page.dart'; // Import for navigation

// --- A class to represent a Task with its properties ---
class Task {
  String name;
  bool isCompleted;
  DateTime createdDate;

  Task({
    required this.name,
    this.isCompleted = false,
    required this.createdDate,
  });

  // Convert a Task object to a JSON map for saving.
  Map<String, dynamic> toJson() => {
        'name': name,
        'isCompleted': isCompleted,
        'createdDate': createdDate.toIso8601String(),
      };

  // Create a Task object from a JSON map.
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        isCompleted: json['isCompleted'] ?? false,
        createdDate: DateTime.parse(json['createdDate']),
      );
}

// --- PAGE 1: DASHBOARD ---
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> _quoteFuture;
  final List<Task> _tasks = [];
  final List<Task> _tasksHistory = [];
  final List<Map<String, dynamic>> _quoteHistory = [];

  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuoteHistory();
    _quoteFuture = _getQuote(false);
    _loadTasks();
  }

  // --- Load Quote History from storage ---
  Future<void> _loadQuoteHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuotes = prefs.getStringList('quote_history') ?? [];
    if (mounted) {
      setState(() {
        _quoteHistory.clear();
        _quoteHistory.addAll(
            savedQuotes.map((e) => jsonDecode(e) as Map<String, dynamic>));
      });
    }
  }

  // --- Save Quote History to storage ---
  Future<void> _saveQuoteHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _quoteHistory.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('quote_history', historyJson);
  }

  // --- LOAD TASKS ---
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];
    final savedHistory = prefs.getStringList('tasks_history') ?? [];

    if (mounted) {
      setState(() {
        _tasks.clear();
        _tasks.addAll(savedTasks.map((e) => Task.fromJson(jsonDecode(e))));
        _tasksHistory.clear();
        _tasksHistory.addAll(savedHistory.map((e) => Task.fromJson(jsonDecode(e))));
      });
    }
  }

  // --- SAVE TASKS ---
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((e) => jsonEncode(e.toJson())).toList();
    final historyJson = _tasksHistory.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
    await prefs.setStringList('tasks_history', historyJson);
  }

  // --- ASYNCHRONOUS API CALL FUNCTION ---
  Future<Map<String, dynamic>> _getQuote(bool forceRefresh) async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuote = prefs.getString('saved_quote');
    final savedAuthor = prefs.getString('saved_author');

    if (!forceRefresh && savedQuote != null && savedAuthor != null) {
      return {'q': savedQuote, 'a': savedAuthor};
    }

    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];

        if (savedQuote != null) {
          final oldQuote = {'q': savedQuote, 'a': savedAuthor};
          _quoteHistory.insert(0, oldQuote);
          if (_quoteHistory.length > 10) {
            _quoteHistory.removeLast();
          }
          _saveQuoteHistory();
        }

        await prefs.setString('saved_quote', data['q']);
        await prefs.setString('saved_author', data['a']);
        return data;
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      if (savedQuote != null && savedAuthor != null) {
        return {'q': savedQuote, 'a': savedAuthor};
      }
      throw Exception('Could not connect to the server.');
    }
  }

  void _refreshQuote() {
    setState(() {
      _quoteFuture = _getQuote(true);
    });
  }

  // --- SHOW QUOTE HISTORY MODAL ---
  void _showQuoteHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              AppBar(
                title: const Text('Quote History'),
                automaticallyImplyLeading: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: _quoteHistory.isEmpty
                    ? const Center(child: Text('No previous quotes!'))
                    : ListView.builder(
                        itemCount: _quoteHistory.length,
                        itemBuilder: (context, index) {
                          final quoteData = _quoteHistory[index];
                          return ListTile(
                            title: Text('"${quoteData['q']}"'),
                            subtitle: Text('- ${quoteData['a']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.star_border, color: Colors.amber),
                              onPressed: () => _favoriteQuote(quoteData['q'], quoteData['a']),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- ADD A TASK ---
  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        final newTask = Task(name: text, createdDate: DateTime.now());
        _tasks.add(newTask);
        _taskController.clear();
      });
      _saveTasks();
    }
  }

  // --- COMPLETE A TASK ---
  void _completeTask(int index) {
    setState(() {
      final completedTask = _tasks.removeAt(index);
      completedTask.isCompleted = true;
      _tasksHistory.add(completedTask);
    });
    _saveTasks();
  }

  // --- RESTORE TASK FROM HISTORY ---
  void _restoreTask(int index) {
    setState(() {
      final restoredTask = _tasksHistory.removeAt(index);
      restoredTask.isCompleted = false;
      _tasks.add(restoredTask);
    });
    _saveTasks();
    Navigator.pop(context);
  }

  // --- FAVORITING A QUOTE ---
  Future<void> _favoriteQuote(String quote, String author) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    final quoteString = '"$quote" - $author';
    if (!favorites.contains(quoteString)) {
      favorites.add(quoteString);
      await prefs.setStringList('favorites', favorites);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quote added to favorites!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quote is already in your favorites.')),
        );
      }
    }
  }

  // --- SHOW TASK HISTORY MODAL ---
  void _showTaskHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              AppBar(
                title: const Text('Task History'),
                automaticallyImplyLeading: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: _tasksHistory.isEmpty
                    ? const Center(child: Text('No completed tasks yet!'))
                    : ListView.builder(
                        itemCount: _tasksHistory.length,
                        itemBuilder: (context, index) {
                          final task = _tasksHistory[index];
                          return ListTile(
                            title: Text(
                              task.name,
                              style: const TextStyle(decoration: TextDecoration.lineThrough),
                            ),
                            subtitle: Text('Completed on: ${task.createdDate.toString().split(' ')[0]}'),
                            leading: IconButton(
                              icon: const Icon(Icons.undo, color: Colors.blue),
                              tooltip: 'Restore to active list',
                              onPressed: () => _restoreTask(index),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteHistoryTask(index),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteHistoryTask(int index) {
    setState(() {
      _tasksHistory.removeAt(index);
    });
    _saveTasks();
  }

  // --- SHOW POP-OUT QUOTE MODAL ---
  Future<void> _showQuoteModal(String quote, String author) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Quote Modal',
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '"$quote"',
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '- $author',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearAllTasks() {
    setState(() {
      _tasks.clear();
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_rounded),
            tooltip: 'Completed Tasks',
            onPressed: _showTaskHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- QUOTE SECTION ---
              SizedBox(
                height: 160,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _quoteFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Error loading quote: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final quoteData = snapshot.data!;
                      final quote = quoteData['q'];
                      final author = quoteData['a'];

                      return Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () => _showQuoteModal(quote, author),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      '"$quote"',
                                      style: const TextStyle(
                                          fontSize: 16, fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '- $author',
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.star_border, color: Colors.amber),
                                      onPressed: () => _favoriteQuote(quote, author),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),

              // --- QUOTE BUTTONS SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _refreshQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Quote'),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: _showQuoteHistory,
                    icon: const Icon(Icons.history),
                    label: const Text('View History'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- ANALYTICS QUICK-ACTION SECTION ---
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AnalyticsPage()),
                  );
                },
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.blue),
                        const SizedBox(width: 10),
                        const Text(
                          'View your progress on Analytics',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- TO-DO LIST HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To-Do List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (_tasks.isNotEmpty)
                      TextButton(
                        onPressed: _clearAllTasks,
                        child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- TASK INPUT SECTION ---
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: 'Add a new task...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: _addTask,
                  ),
                ),
                onSubmitted: (_) => _addTask(),
              ),
              const SizedBox(height: 16),

              // --- VERTICAL TASK LIST ---
              SizedBox(
                height: 300,
                child: _tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No active tasks. Add one above!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  _tasks[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: _tasks[index].isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: Checkbox(
                                  value: _tasks[index].isCompleted,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      _completeTask(index);
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}