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

  // --- STANDARD & CUSTOM THEMES ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6200EE),
      secondary: Color(0xFF03DAC6),
      background: Colors.white,
      surface: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFF6200EE), // Matches primary color
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC),
      secondary: Color(0xFF03DAC6),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: const Color(0xFFBB86FC),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
    ),
    useMaterial3: true,
  );

  static final ThemeData guavaTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE8F5E9),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB9E1D2),
      onPrimary: Color(0xFF1B5E20),
      secondary: Color(0xFFD4EADF),
      onSecondary: Colors.black,
      background: Color(0xFFE8F5E9),
      onBackground: Colors.black,
      surface: Color(0xFFC8E6C9),
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB9E1D2),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFC8E6C9),
      indicatorColor: const Color(0xFF1B5E20),
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  static final ThemeData pineappleTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFDE1),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFF07E),
      onPrimary: Colors.black,
      secondary: Color(0xFFFFF7C4),
      onSecondary: Colors.black,
      background: Color(0xFFFFFDE1),
      onBackground: Colors.black,
      surface: Color(0xFFFFF9B4),
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFF07E),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFFF7C4),
      indicatorColor: Colors.black,
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  static final ThemeData greyscaleTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade200,
    colorScheme: ColorScheme.light(
      primary: Colors.grey.shade600,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade300,
      onSecondary: Colors.black,
      background: Colors.grey.shade200,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade600,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.grey.shade800,
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  static final ThemeData grapeTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE8FCE8),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF98FB98),
      onPrimary: Colors.black,
      secondary: Color(0xFFBFFFBF),
      onSecondary: Colors.black,
      background: Color(0xFFE8FCE8),
      onBackground: Colors.black,
      surface: Color(0xFFC7F9C7),
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF98FB98),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFC7F9C7),
      indicatorColor: Colors.black,
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  static final ThemeData peachTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF2D9),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFB347),
      onPrimary: Colors.black,
      secondary: Color(0xFFFFDAB9),
      onSecondary: Colors.black,
      background: Color(0xFFFFF2D9),
      onBackground: Colors.black,
      surface: Color(0xFFFFE0B2),
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFB347),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFFE0B2),
      indicatorColor: Colors.black,
      labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
    ),
    useMaterial3: true,
  );

  // --- NEW CUSTOM THEME LOGIC ---
  static const String customThemeKey = 'custom_rgb';
  static const String customRKey = 'custom_r';
  static const String customGKey = 'custom_g';
  static const String customBKey = 'custom_b';

  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_preference') ?? 'system';
    final showCompletedCount = prefs.getBool('show_completed_count') ?? false;
    final analyticsView = prefs.getString('analytics_view') ?? '7day';
    final animationsEnabled = prefs.getBool('animations_enabled') ?? true;

    ThemeData themeData;
    String themeName = savedTheme;

    if (savedTheme == 'light') themeData = lightTheme;
    else if (savedTheme == 'dark') themeData = darkTheme;
    else if (savedTheme == 'guava') themeData = guavaTheme;
    else if (savedTheme == 'pineapple') themeData = pineappleTheme;
    else if (savedTheme == 'greyscale') themeData = greyscaleTheme;
    else if (savedTheme == 'grape') themeData = grapeTheme;
    else if (savedTheme == 'peach') themeData = peachTheme;
    else if (savedTheme == customThemeKey) {
      final r = prefs.getInt(customRKey) ?? 0;
      final g = prefs.getInt(customGKey) ?? 0;
      final b = prefs.getInt(customBKey) ?? 0;
      themeData = _createCustomTheme(r, g, b);
      themeName = customThemeKey;
    }
    else {
      themeData = lightTheme;
      themeName = 'system';
    }

    return ThemeProvider(themeData, themeName, showCompletedCount, analyticsView, animationsEnabled);
  }

  static ThemeData _createCustomTheme(int r, int g, int b) {
    Color primary = Color.fromRGBO(r, g, b, 1);
    Color secondary = Color.fromRGBO((r + 50).clamp(0, 255), (g + 50).clamp(0, 255), (b + 50).clamp(0, 255), 1);
    Color background = Color.fromRGBO((r + 20).clamp(0, 255), (g + 20).clamp(0, 255), (b + 20).clamp(0, 255), 1);
    Color onPrimary = primary.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: Colors.black,
        background: background,
        onBackground: Colors.black,
        surface: secondary,
        onSurface: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: secondary,
        indicatorColor: primary,
        labelTextStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black)),
      ),
      useMaterial3: true,
    );
  }

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

  void setCustomTheme(int r, int g, int b) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_preference', customThemeKey);
    await prefs.setInt(customRKey, r);
    await prefs.setInt(customGKey, g);
    await prefs.setInt(customBKey, b);
    _themeName = customThemeKey;
    _currentTheme = _createCustomTheme(r, g, b);
    notifyListeners();
  }

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

  void resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _showCompletedCount = false;
    _analyticsView = '7day';
    _animationsEnabled = true;
    _themeName = 'system';
    _currentTheme = lightTheme;
    notifyListeners();
  }
}