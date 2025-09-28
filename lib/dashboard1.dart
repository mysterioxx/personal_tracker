//created a new file named dashboard1.dart

// impoerts for making HTTP requests and handling JSON data.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- PAGE 1: DASHBOARD --- 
// This is a StatefulWidget because it needs to fetch data from the internet (the quote)
// and update its state to display that data.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // State variables to hold the quote and its author.
  // They start with default values.
  String _quote = "Loading quote...";
  String _author = "";

  // 'initState' is a special method that is called exactly ONCE when the
  // widget is first created and inserted into the widget tree.
  // It's the perfect place to do initial setup, like fetching data.
  @override
  void initState() {
    super.initState();
    _getQuote(); // We call our function to fetch the quote as soon as the page loads.
  }

  // --- THE API CALL FUNCTION ---
  // A 'Future' is an object that represents a potential value, or error,
  // that will be available at some time in the future.
  // 'async' marks the function as asynchronous, allowing us to use 'await'.
  Future<void> _getQuote() async {
    // A 'try...catch' block is used for error handling.
    // The 'try' block contains code that might fail (e.g., no internet connection).
    try {
      // 'await' pauses the function's execution until the network request is complete.
      // We are sending a GET request to the ZenQuotes API for a random quote.
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));

      // A status code of 200 means the request was successful ("OK").
      if (response.statusCode == 200) {
        // We get the response body (which is a String) and decode it from JSON format.
        // The API returns a list with one item, so we take the first one [0].
        final data = jsonDecode(response.body)[0];
        // We call 'setState' to update our state variables and rebuild the UI.
        setState(() {
          _quote = data['q'];  // 'q' is the key for the quote text in the API response.
          _author = data['a']; // 'a' is the key for the author.
        });
      } else {
        // If the server response was not 'OK', we show an error.
        setState(() {
          _quote = "Failed to load quote.";
          _author = "";
        });
      }
    } catch (e) {
      // If an error happened during the 'try' block (e.g., no internet),
      // the 'catch' block is executed. We show a connection error message.
      setState(() {
        _quote = "Could not connect to the server.";
        _author = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bar at the top of the screen.
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      // 'Padding' adds some empty space around its child widget.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 'Column' arranges its children vertically.
        child: Column(
          // 'mainAxisAlignment' aligns the children along the vertical axis.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40), // Just an invisible box for spacing.
            const Text('Daily Motivational Quote:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // 'Card' creates a Material Design card with a slight shadow.
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // This Text widget displays the quote we fetched.
                    Text(
                      '"$_quote"',
                      style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // This Text widget displays the author we fetched.
                    Text(
                      '- $_author',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
