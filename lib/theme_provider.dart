import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme;
  String _themeName;

  bool _showCompletedCount = false;
  String _analyticsView = '7day';
  bool _animationsEnabled = true;

  ThemeProvider(this._currentTheme, this._themeName, this._showCompletedCount, this._analyticsView, this._animationsEnabled);

  ThemeData get currentTheme => _currentTheme;
  String get themeName => _themeName;
  bool get showCompletedCount => _showCompletedCount;
  String get analyticsView => _analyticsView;
  bool get animationsEnabled => _animationsEnabled;

  // --- STANDARD THEMES ---
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

  // Custom theme 1: Guava (Light mint green palette)
  static final ThemeData guavaTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFB9E1D2), // Soft Green
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB9E1D2),
      secondary: Color(0xFFD4EADF),
      background: Color(0xFFE8F5E9),
    ),
    useMaterial3: true,
  );

  // Custom theme 2: Pineapple (Light yellow/gold palette)
  static final ThemeData pineappleTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFF07E), // Pastel Yellow
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFF07E),
      secondary: Color(0xFFFFF7C4),
      background: Color(0xFFFFFDE1),
    ),
    useMaterial3: true,
  );

  // Custom theme 3: Greyscale (Calm, minimal palette)
  static final ThemeData greyscaleTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    colorScheme: ColorScheme.light(
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade300,
      background: Colors.grey.shade100,
      surface: Colors.white,
    ),
    useMaterial3: true,
  );

  // Custom theme 4: Grape (Dark, calm purple)
  static final ThemeData grapeTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF7B68EE),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7B68EE),
      secondary: Color(0xFF9370DB),
      surface: Color(0xFF1D1B20),
    ),
    useMaterial3: true,
  );

  // Custom theme 5: Peach (Pastel peach palette)
  static final ThemeData peachTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFB347), // Pastel Orange
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFB347),
      secondary: Color(0xFFFFDAB9), // Peach Puff
      background: Color(0xFFFFF2D9),
    ),
    useMaterial3: true,
  );

  // Load the saved theme and preferences from local storage
  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_preference') ?? 'system';
    final showCompletedCount = prefs.getBool('show_completed_count') ?? false;
    final analyticsView = prefs.getString('analytics_view') ?? '7day';
    final animationsEnabled = prefs.getBool('animations_enabled') ?? true;

    ThemeData themeData;
    String themeName = savedTheme;

    if (savedTheme == 'light') {
      themeData = lightTheme;
    } else if (savedTheme == 'dark') {
      themeData = darkTheme;
    } else if (savedTheme == 'guava') {
      themeData = guavaTheme;
    } else if (savedTheme == 'pineapple') {
      themeData = pineappleTheme;
    } else if (savedTheme == 'greyscale') {
      themeData = greyscaleTheme;
    } else if (savedTheme == 'grape') {
      themeData = grapeTheme;
    } else if (savedTheme == 'peach') {
      themeData = peachTheme;
    } else {
      themeData = lightTheme;
      themeName = 'system';
    }

    return ThemeProvider(themeData, themeName, showCompletedCount, analyticsView, animationsEnabled);
  }

  // Set new theme
  void setTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_preference', themeName);
    _themeName = themeName;
    if (themeName == 'light') _currentTheme = lightTheme;
    else if (themeName == 'dark') _currentTheme = darkTheme;
    else if (themeName == 'guava') _currentTheme = guavaTheme;
    else if (themeName == 'pineapple') _currentTheme = pineappleTheme;
    else if (themeName == 'greyscale') _currentTheme = greyscaleTheme;
    else if (themeName == 'grape') _currentTheme = grapeTheme;
    else if (themeName == 'peach') _currentTheme = peachTheme;
    notifyListeners();
  }

  // Set other preferences
  void setShowCompletedCount(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_completed_count', value);
    _showCompletedCount = value;
    notifyListeners();
  }

  void setAnalyticsView(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('analytics_view', value);
    _analyticsView = value;
    notifyListeners();
  }

  void setAnimationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animations_enabled', value);
    _animationsEnabled = value;
    notifyListeners();
  }

  // Reset all data
  void resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Re-initialize to default values
    _showCompletedCount = false;
    _analyticsView = '7day';
    _animationsEnabled = true;
    _themeName = 'system';
    _currentTheme = lightTheme;
    notifyListeners();
  }
}