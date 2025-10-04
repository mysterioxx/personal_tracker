//imported the new file named dashboard1.dart 
import 'dashboard1.dart';
import 'package:flutter/material.dart';
// We import the shared_preferences package here so the FavoritesPage can use it.
import 'package:shared_preferences/shared_preferences.dart';
// We import our new settings page here.
import 'settings_page.dart';
// Import the theme provider package
import 'package:provider/provider.dart';
// Import our new theme provider file
import 'theme_provider.dart';
// Import the new analytics page file
import 'analytics_page.dart';


// --- STEP 1: THE STARTING POINT OF THE APP ---

// The 'main' function is now asynchronous to load the theme first.
Future<void> main() async {
  // Required for `SharedPreferences` before `runApp`.
  WidgetsFlutterBinding.ensureInitialized();
  // Load the initial theme.
  final themeProvider = await ThemeProvider.loadTheme();

  // Wrap the app in a ChangeNotifierProvider.
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: const MyApp(),
    ),
  );
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
    // We listen to the theme provider to get the current theme.
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeName = themeProvider.themeName;

    // MaterialApp now gets its theme from the provider.
    return MaterialApp(
      title: 'Personal Tracker', // The title of the app (used by the OS).

      // `themeMode` is set based on the theme name.
      themeMode: themeName == 'dark' ? ThemeMode.dark : (themeName == 'system' ? ThemeMode.system : ThemeMode.light),

      // `theme` is set to the current theme from the provider.
      theme: themeProvider.currentTheme,

      // `darkTheme` is used for the system dark mode, so we use a standard dark theme.
      darkTheme: ThemeData.dark(),

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

// --- PAGE 2: ANALYTICS --- (Code is in analytics_page.dart)
// The code for the analytics page is now in its own file.
// We keep this placeholder class to ensure it can be imported.
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


// --- PAGE 3: SETTINGS --- (Code is in settings_page.dart)

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

  // --- FUNCTION TO SAVE FAVORITES ---
  // A new function to save the reordered list.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  // --- THE DRAG-AND-DROP REORDER LOGIC ---
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // If the item is dragged down, it will shift one position up.
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      // We remove the item from its old position.
      final item = _favorites.removeAt(oldIndex);
      // And insert it into its new position.
      _favorites.insert(newIndex, item);
      _saveFavorites(); // Save the new order to storage.
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      // Check if the list of favorites is empty and display a message if so.
      body: _favorites.isEmpty
          ? Center(
        child: Text(
          'You have no favorite quotes yet!',
          style: TextStyle(
            fontSize: 18,
            color: textColor.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      )
      // If the list is not empty, display it using a ReorderableListView.
          : ReorderableListView.builder(
        itemCount: _favorites.length,
        // The `onReorder` callback is triggered when an item is dropped.
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          // Each item needs a unique `key`.
          final item = _favorites[index];
          return Padding(
            key: ValueKey(item),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                title: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                // Add a drag handle for better user experience.
                trailing: const Icon(Icons.drag_handle_rounded),
              ),
            ),
          );
        },
      ),
    );
  }
}