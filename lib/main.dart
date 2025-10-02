//imported the new file named dashboard1.dart 
import 'dashboard1.dart';
import 'package:flutter/material.dart';
// We import the shared_preferences package here so the FavoritesPage can use it.
import 'package:shared_preferences/shared_preferences.dart';
// We import our new settings page here.
import 'settings_page.dart';

// --- STEP 1: THE STARTING POINT OF THE APP ---

// The 'main' function is the entry point. Every Flutter app starts running from here.
void main() {
  // 'runApp' tells Flutter to inflate the given Widget and attach it to the screen.
  // In our case, it starts with our 'MyApp' widget.
  runApp(const MyApp());
}

// --- STEP 2: THE ROOT WIDGET OF YOUR APPLICATION ---

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

// --- STEP 3: THE MAIN SCREEN THAT HOLDS OUR 4 PAGES ---

// 'MyHomePage' is a StatefulWidget because its state can change.
// Specifically, we need to remember WHICH of the four tabs is currently selected.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The State class for MyHomePage. The '_' makes it private.
class _MyHomePageState extends State<MyHomePage> {
  // This variable holds the index of the currently selected tab. 0 is the first tab.
  int _selectedIndex = 0;

  // This is a list of our four page widgets.
  // The app will display the widget from this list that corresponds to '_selectedIndex'.
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    AnalyticsPage(),
    SettingsPage(),
    FavoritesPage(),
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
    // 'Scaffold' is a standard layout widget.
    return Scaffold(
      // The body of the scaffold shows the currently selected page.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // --- MODERN NAVIGATION BAR (Material 3 NavigationBar) ---
      // This is the modern replacement for BottomNavigationBar.
      bottomNavigationBar: NavigationBar(
        // This is the index of the currently selected item.
        selectedIndex: _selectedIndex,
        // Specifies which function to call when an item is tapped.
        onDestinationSelected: _onItemTapped,
        // Removes the default shadow for a flat, modern look.
        elevation: 0,

        // These are the individual items (destinations) in the bar.
        destinations: const <NavigationDestination>[
          NavigationDestination(
            // `_outlined` is used for unselected, `_filled` for selected (by default).
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

// --- STEP 4: DEFINING EACH OF THE FOUR PAGES ---

// --- PAGE 1: DASHBOARD --- (Code is in dashboard1.dart)

// --- PAGE 2: ANALYTICS (Placeholder) ---
// This is a StatelessWidget because it's just displaying static text for now.
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

// --- PAGE 3: SETTINGS (MOVED TO settings_page.dart) ---

// --- PAGE 4: FAVORITES (Now displays saved quotes) ---
// This is a StatefulWidget because its content (the list of favorites) can change.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

// The State class for FavoritesPage.
class _FavoritesPageState extends State<FavoritesPage> {
  // This list will hold the favorite quotes loaded from storage.
  List<String> _favorites = [];

  // This is a crucial method. It's called once when the widget is created.
  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Call our function to load the favorites.
  }

  // --- FUNCTION TO LOAD FAVORITES ---
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Use `getStringList` to retrieve the list. The `?? []` provides an empty list if none is found.
    final favorites = prefs.getStringList('favorites') ?? [];
    // We use setState to update the UI with the loaded data.
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      // Check if the list of favorites is empty and display a message if so.
      body: _favorites.isEmpty
          ? Center(
        child: Text(
          'You have no favorite quotes yet!',
          style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
      )
      // If the list is not empty, display it using a ListView.
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          // Return a Card with a ListTile for each quote.
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(
                _favorites[index],
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
          );
        },
      ),
    );
  }
}