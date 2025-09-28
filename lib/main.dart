// --- STEP 1: IMPORTING PACKAGES ---
// 'import' is how we bring in code libraries to use their features.

// This is the core library for Flutter's UI components (like buttons, text, layout).
// It's based on Google's Material Design.
import 'package:flutter/material.dart';

// We import the 'http' package, which we added in pubspec.yaml.
// It allows our app to make requests to the internet (API calls).
// We use 'as http' to give it a shorter name.
import 'package:http/http.dart' as http;

// This built-in library helps us work with JSON data, which is the
// standard format for most APIs.
import 'dart:convert';


// --- STEP 2: THE STARTING POINT OF THE APP ---

// The 'main' function is the entry point. Every Flutter app starts running from here.
void main() {
  // 'runApp' tells Flutter to inflate the given Widget and attach it to the screen.
  // In our case, it starts with our 'MyApp' widget.
  runApp(const MyApp());
}


// --- STEP 3: THE ROOT WIDGET OF YOUR APPLICATION ---

// 'MyApp' is a StatelessWidget because its own properties don't change over time.
// It just sets up the main theme and structure.
class MyApp extends StatelessWidget {
  // This is a constructor. 'const' means it can be created at compile-time for performance.
  const MyApp({super.key});

  // The 'build' method describes the part of the user interface represented by this widget.
  // Flutter calls this method whenever it needs to draw this widget on the screen.
  @override
  Widget build(BuildContext context) {
    // 'MaterialApp' is a convenience widget that wraps a number of widgets
    // that are commonly required for Material Design applications.
    return MaterialApp(
      title: 'Personal Tracker', // The title of the app (used by the OS).

      // --- THEME SETUP: This is where the Dark/Light mode magic happens! ---

      // 'theme' defines the colors, fonts, etc., for the standard LIGHT MODE.
      theme: ThemeData(
        brightness: Brightness.light, // Explicitly says this is a light theme.
        primarySwatch: Colors.blue,   // Sets the primary color family.
        useMaterial3: true,           // Enables the latest Material Design visuals.
      ),

      // 'darkTheme' defines the colors, fonts, etc., for the DARK MODE.
      darkTheme: ThemeData(
        brightness: Brightness.dark,  // Explicitly says this is a dark theme.
        primarySwatch: Colors.blue,   // We can use the same color family.
        useMaterial3: true,
      ),

      // This is the key! 'ThemeMode.system' tells the app to AUTOMATICALLY
      // listen to the phone's system settings and switch between 'theme' and 'darkTheme'.
      themeMode: ThemeMode.system,

      // 'home' is the first screen the user will see. We point it to our 'MyHomePage'.
      home: const MyHomePage(),

      // This removes the little "Debug" banner from the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}


// --- STEP 4: THE MAIN SCREEN THAT HOLDS OUR 3 PAGES ---

// 'MyHomePage' is a StatefulWidget because its state can change.
// Specifically, we need to remember WHICH of the three tabs is currently selected.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The State class for MyHomePage. The '_' makes it private.
class _MyHomePageState extends State<MyHomePage> {
  // This variable holds the index of the currently selected tab. 0 is the first tab.
  int _selectedIndex = 0;

  // This is a list of our three page widgets.
  // The app will display the widget from this list that corresponds to '_selectedIndex'.
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    AnalyticsPage(),
    SettingsPage(),
  ];

  // This function is called whenever a user taps on an item in the bottom navigation bar.
  void _onItemTapped(int index) {
    // 'setState' is a crucial Flutter method. It tells the framework that the state
    // has changed, and that it needs to re-run the 'build' method to update the UI.
    setState(() {
      _selectedIndex = index; // We update the selected index to the one that was tapped.
    });
  }

  @override
  Widget build(BuildContext context) {
    // 'Scaffold' is a standard layout widget. It gives us the structure for
    // a typical screen, including an app bar, body, and bottom navigation bar.
    return Scaffold(
      // The body of the scaffold shows the currently selected page.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // This is the navigation bar at the bottom of the screen.
      bottomNavigationBar: BottomNavigationBar(
        // These are the individual items (tabs) in the bar.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the currently selected item.
        onTap: _onItemTapped,         // Specifies which function to call when an item is tapped.
      ),
    );
  }
}


// --- STEP 5: DEFINING EACH OF THE THREE PAGES ---

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

// --- PAGE 2: ANALYTICS (Placeholder) ---
// This is a StatelessWidget because it's just displaying static text for now.
// It doesn't need to manage any changing data.
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: const Center(
        child: Text(
          'Graphs for your spending and habits will be here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}


// --- PAGE 3: SETTINGS (Placeholder) ---
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text(
          'App settings and theme controls will be here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}