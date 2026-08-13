import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme;
  String _themeName;
  String _fontFamily;

  bool _showCompletedCount = false;
  String _analyticsView = '7day';
  bool _animationsEnabled = true;

  ThemeProvider(
    this._currentTheme,
    this._themeName,
    this._fontFamily,
    this._showCompletedCount,
    this._analyticsView,
    this._animationsEnabled,
  );

  ThemeData get currentTheme => _currentTheme;
  String get themeName => _themeName;
  String get fontFamily => _fontFamily;
  bool get showCompletedCount => _showCompletedCount;
  bool get animationsEnabled => _animationsEnabled;
  String get analyticsView => _analyticsView;

  // --- FONT LIST ---
  static const Map<String, String?> fontMap = {
    'System Default': null, // null defaults to device system font
    'Roboto (Basic)': 'Roboto',
    'Open Sans': 'Open Sans',
    'Lato': 'Lato',
  };

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
    primaryColor: const Color(0xFFB9E1D2),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB9E1D2),
      onPrimary: Color(0xFF1B5E20),
      secondary: Color(0xFFD4EADF),
      onSecondary: Colors.black,
      surface: Color(0xFFC8E6C9),
      onSurface: Colors.black,
    ),
    useMaterial3: true,
  );

  // Custom theme 2: Pineapple (Light yellow/gold palette)
  static final ThemeData pineappleTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFF07E),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFF07E),
      onPrimary: Colors.black,
      secondary: Color(0xFFFFF7C4),
      onSecondary: Colors.black,
      surface: Color(0xFFFFF9B4),
      onSurface: Colors.black,
    ),
    useMaterial3: true,
  );

  // Custom theme 3: Greyscale (Calm, minimal palette)
  static final ThemeData greyscaleTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    colorScheme: ColorScheme.light(
      primary: Colors.grey.shade600,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade300,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
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
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    useMaterial3: true,
  );

  // Custom theme 5: Peach (Pastel peach palette)
  static final ThemeData peachTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFB347),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFB347),
      onPrimary: Colors.black,
      secondary: Color(0xFFFFDAB9),
      surface: Color(0xFFFFE0B2),
      onSurface: Colors.black,
    ),
    useMaterial3: true,
  );

  // --- CUSTOM RGB KEYS ---
  static const String customThemeKey = 'custom_rgb';
  static const String customRKey = 'custom_r';
  static const String customGKey = 'custom_g';
  static const String customBKey = 'custom_b';
  static const String fontKey = 'font_family';

  // Helper function to create custom theme with readable text contrast
  static ThemeData _createCustomTheme(int r, int g, int b) {
    final Color primary = Color.fromRGBO(r, g, b, 1);
    final Color secondary = Color.fromRGBO((r + 40).clamp(0, 255), (g + 40).clamp(0, 255), (b + 40).clamp(0, 255), 1);
    final Color background = Color.fromRGBO((r + 20).clamp(0, 255), (g + 20).clamp(0, 255), (b + 20).clamp(0, 255), 1);
    
    final bool isLight = primary.computeLuminance() > 0.5;
    final Color textColor = isLight ? Colors.black : Colors.white;

    return ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: isLight ? Brightness.light : Brightness.dark,
        primary: primary,
        onPrimary: textColor,
        secondary: secondary,
        onSecondary: textColor,
        error: Colors.red,
        onError: Colors.white,
        surface: secondary,
        onSurface: textColor,
      ),
      useMaterial3: true,
    );
  }

  // Load saved theme and preferences
  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_preference') ?? 'system';
    final savedFont = prefs.getString(fontKey) ?? 'System Default';
    final showCompletedCount = prefs.getBool('show_completed_count') ?? false;
    final analyticsView = prefs.getString('analytics_view') ?? '7day';
    final animationsEnabled = prefs.getBool('animations_enabled') ?? true;

    ThemeData baseTheme;
    String themeName = savedTheme;

    if (savedTheme == 'light') {
      baseTheme = lightTheme;
    } else if (savedTheme == 'dark') {
      baseTheme = darkTheme;
    } else if (savedTheme == 'guava') {
      baseTheme = guavaTheme;
    } else if (savedTheme == 'pineapple') {
      baseTheme = pineappleTheme;
    } else if (savedTheme == 'greyscale') {
      baseTheme = greyscaleTheme;
    } else if (savedTheme == 'grape') {
      baseTheme = grapeTheme;
    } else if (savedTheme == 'peach') {
      baseTheme = peachTheme;
    } else if (savedTheme == customThemeKey) {
      final r = prefs.getInt(customRKey) ?? 0;
      final g = prefs.getInt(customGKey) ?? 0;
      final b = prefs.getInt(customBKey) ?? 0;
      baseTheme = _createCustomTheme(r, g, b);
      themeName = customThemeKey;
    } else {
      baseTheme = lightTheme;
      themeName = 'system';
    }

    final finalTheme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: fontMap[savedFont],
      ),
    );

    return ThemeProvider(finalTheme, themeName, savedFont, showCompletedCount, analyticsView, animationsEnabled);
  }

  // Set new theme
  void setTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_preference', themeName);
    _themeName = themeName;

    ThemeData baseTheme;
    if (themeName == 'light') {
      baseTheme = lightTheme;
    } else if (themeName == 'dark') {
      baseTheme = darkTheme;
    } else if (themeName == 'guava') {
      baseTheme = guavaTheme;
    } else if (themeName == 'pineapple') {
      baseTheme = pineappleTheme;
    } else if (themeName == 'greyscale') {
      baseTheme = greyscaleTheme;
    } else if (themeName == 'grape') {
      baseTheme = grapeTheme;
    } else if (themeName == 'peach') {
      baseTheme = peachTheme;
    } else if (themeName == customThemeKey) {
      final r = prefs.getInt(customRKey) ?? 0;
      final g = prefs.getInt(customGKey) ?? 0;
      final b = prefs.getInt(customBKey) ?? 0;
      baseTheme = _createCustomTheme(r, g, b);
    } else {
      baseTheme = lightTheme;
    }

    _currentTheme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: fontMap[_fontFamily]),
    );

    notifyListeners();
  }

  // Set Font Family
  void setFontFamily(String familyName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(fontKey, familyName);
    _fontFamily = familyName;

    setTheme(_themeName);
  }

  // Set Custom Theme with RGB
  void setCustomTheme(int r, int g, int b) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_preference', customThemeKey);
    await prefs.setInt(customRKey, r);
    await prefs.setInt(customGKey, g);
    await prefs.setInt(customBKey, b);
    _themeName = customThemeKey;

    final customBase = _createCustomTheme(r, g, b);
    _currentTheme = customBase.copyWith(
      textTheme: customBase.textTheme.apply(fontFamily: fontMap[_fontFamily]),
    );
    notifyListeners();
  }

  // Set Preferences
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