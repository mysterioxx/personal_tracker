// Imports for making HTTP requests, handling JSON data, and Flutter widgets.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- PAGE 1: DASHBOARD ---
// This is a StatefulWidget because it needs to manage a list of tasks.
// The quote fetching is now handled by a FutureBuilder.
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
  // We initialize our future here.
  @override
  void initState() {
    super.initState();
    _quoteFuture = _getQuote();
  }

  // --- THE ASYNCHRONOUS API CALL FUNCTION ---
  // A 'Future' is an object that represents a potential value or error that will be available in the future.
  Future<Map<String, dynamic>> _getQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if (response.statusCode == 200) {
        // The API returns a list with one item, so we take the first one [0].
        return jsonDecode(response.body)[0];
      } else {
        // If the server response was not 'OK', we throw an exception.
        throw Exception('Failed to load quote with status code: ${response.statusCode}');
      }
    } catch (e) {
      // If an error happened during the 'try' block (e.g., no internet), we throw a specific error.
      throw Exception('Could not connect to the server.');
    }
  }

  // --- FUNCTION TO ADD A TASK ---
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear(); // Clear the text field after adding the task.
      });
    }
  }

  // --- FUNCTION TO REMOVE A TASK ---
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // --- FUNCTION FOR FAVORITING A QUOTE (Placeholder) ---
  void _favoriteQuote() {
    // You can add logic here to save the quote to a favorites list or database.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quote added to favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark or light mode.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      // 'SingleChildScrollView' makes the page scrollable if content overflows.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // --- QUOTE SECTION with FutureBuilder ---
            // 'FutureBuilder' handles the asynchronous loading of the quote.
            FutureBuilder<Map<String, dynamic>>(
              future: _quoteFuture,
              builder: (context, snapshot) {
                // Check the connection state of the future.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while the data is being fetched.
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there was an error, display an error message.
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    ),
                  );
                } else {
                  // If the data is successfully loaded, display the quote.
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
                              // 'IconButton' for the favorite star.
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
              onSubmitted: (_) => _addTask(), // Also adds the task when the user presses enter.
            ),
            const SizedBox(height: 20),

            // --- TASK LIST SECTION ---
            // 'ListView.builder' is efficient for displaying dynamic lists.
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling.
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
                      activeColor: Colors.blue, // You can customize the color of the checkbox.
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