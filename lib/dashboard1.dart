// Imports for making HTTP requests, handling JSON data, and Flutter widgets.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// --- PAGE 1: DASHBOARD ---
// This StatefulWidget manages a list of tasks and fetches a quote.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // A Future to hold the result of our API call.
  late Future<Map<String, dynamic>> _quoteFuture;

  // A list to store the user's tasks.
  final List<String> _tasks = [];

  // A controller for the text input field.
  final TextEditingController _taskController = TextEditingController();

  // 'initState' is called once when the widget is created.
  @override
  void initState() {
    super.initState();
    _quoteFuture = _getQuote(); // Start fetching the quote.
    _loadTasks(); // Load tasks from storage when the app opens.
  }

  // --- FUNCTION TO LOAD TASKS ---
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        _tasks.addAll(savedTasks);
      });
    }
  }

  // --- FUNCTION TO SAVE TASKS ---
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
  }

  // --- THE ASYNCHRONOUS API CALL FUNCTION ---
  // This function now checks local storage first before making an API call.
  Future<Map<String, dynamic>> _getQuote() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check if a quote is already saved in storage from this session.
    final savedQuote = prefs.getString('saved_quote');
    final savedAuthor = prefs.getString('saved_author');

    if (savedQuote != null && savedAuthor != null) {
      // If a quote exists, return it immediately without a new API call.
      return {'q': savedQuote, 'a': savedAuthor};
    }

    // 2. If no quote is found, make a new API call.
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];

        // 3. Save the new quote to local storage for this session.
        await prefs.setString('saved_quote', data['q']);
        await prefs.setString('saved_author', data['a']);

        return data;
      } else {
        throw Exception('Failed to load quote with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Could not connect to the server.');
    }
  }

  // --- FUNCTION TO ADD A TASK ---
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
      _saveTasks(); // Save after modifying the list.
    }
  }

  // --- FUNCTION TO REMOVE A TASK ---
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks(); // Save after modifying the list.
  }

  // --- UPDATED FUNCTION FOR FAVORITING A QUOTE ---
  Future<void> _favoriteQuote() async {
    // Get the currently displayed quote from the future's data.
    final quoteData = await _quoteFuture;
    final quote = quoteData['q'];
    final author = quoteData['a'];

    // Load existing favorites.
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Check if the quote is already favorited to avoid duplicates.
    final quoteString = '"$quote" - $author';
    if (!favorites.contains(quoteString)) {
      favorites.add(quoteString);
      await prefs.setStringList('favorites', favorites);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote added to favorites!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This quote is already in your favorites.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // --- QUOTE SECTION with FutureBuilder ---
            FutureBuilder<Map<String, dynamic>>(
              future: _quoteFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    ),
                  );
                } else {
                  final quoteData = snapshot.data!;
                  final quote = quoteData['q'];
                  final author = quoteData['a'];

                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '"$quote"',
                                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.star_border, color: iconColor),
                                onPressed: _favoriteQuote,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '- $author',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 30),

            // --- TASK INPUT SECTION ---
            Text('To-Do List', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 20),
            TextField(
              controller: _taskController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Add a new task...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: iconColor),
                  onPressed: _addTask,
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 20),

            // --- TASK LIST SECTION ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (bool? value) {
                        _removeTask(index);
                      },
                      activeColor: Colors.blue,
                    ),
                    title: Text(
                      _tasks[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}