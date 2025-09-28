//imported the new file named dashboard1.dart 
import 'dashboard1.dart'; 

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
      //update: added colors to icons and added a new icon named favourite
      bottomNavigationBar: BottomNavigationBar(
        // These are the individual items (tabs) in the bar.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,
            color: Colors.blueGrey),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart,
            color: Colors.lightBlueAccent),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.yellow),
            
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                        color: Colors.pink),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the currently selected item.
        onTap: _onItemTapped,         // Specifies which function to call when an item is tapped.
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
  unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}


// --- STEP 5: DEFINING EACH OF THE THREE PAGES --- edited:: four pages

// --- PAGE 1: DASHBOARD --- created a new file named dashboard1.dart and moved the code there
// See lib/dashboard1.dart

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