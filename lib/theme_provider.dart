import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme;
  String _themeName;

  ThemeProvider(this._currentTheme, this._themeName);

  ThemeData get currentTheme => _currentTheme;
  String get themeName => _themeName;

  // Define your custom themes
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    useMaterial3: true,
  );

  // Custom theme 1: Peach 🍑
  static final ThemeData peachTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF08080), // Light red/pink
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFF08080),
      secondary: Color(0xFFFFA07A), // Light salmon
    ),
    useMaterial3: true,
  );

  // Custom theme 2: Grape 🍇
  static final ThemeData grapeTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4B0082), // Indigo
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4B0082),
      secondary: Color(0xFF8A2BE2), // Blue violet
      surface: Color(0xFF2C073F), // A deep purple background
    ),
    useMaterial3: true,
  );

  // Load the saved theme from local storage
  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_preference') ?? 'system';

    ThemeData themeData;
    String themeName = savedTheme;

    if (savedTheme == 'light') {
      themeData = lightTheme;
    } else if (savedTheme == 'dark') {
      themeData = darkTheme;
    } else if (savedTheme == 'peach') {
      themeData = peachTheme;
    } else if (savedTheme == 'grape') {
      themeData = grapeTheme;
    } else {
      themeData = lightTheme; // Default to light if system is selected
      themeName = 'system';
    }

    return ThemeProvider(themeData, themeName);
  }

  // Set a new theme and save it
  void setTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_preference', themeName);
    _themeName = themeName;

    if (themeName == 'light') {
      _currentTheme = lightTheme;
    } else if (themeName == 'dark') {
      _currentTheme = darkTheme;
    } else if (themeName == 'peach') {
      _currentTheme = peachTheme;
    } else if (themeName == 'grape') {
      _currentTheme = grapeTheme;
    }

    notifyListeners(); // Notify all listening widgets to rebuild
  }
}