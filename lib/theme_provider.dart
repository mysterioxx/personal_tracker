import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // ---------------------------------------------------------------------------
  // FONT LIST
  // ---------------------------------------------------------------------------

  static const Map<String, String?> fontMap = {
    'System Default': null,
    'Roboto (Basic)': 'Roboto',
    'Open Sans': 'Open Sans',
    'Lato': 'Lato',
  };

  // ---------------------------------------------------------------------------
  // STANDARD THEMES
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // GUAVA
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // PINEAPPLE
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // GREYSCALE
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // GRAPE
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // PEACH
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // BWNBits CREAM
  //
  // RGB: 225, 215, 206
  // HEX: #E1D7CE
  // ---------------------------------------------------------------------------

  static final ThemeData bwnbitsCreamTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE1D7CE),
    scaffoldBackgroundColor: const Color(0xFFF8F5F2),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE1D7CE),
      onPrimary: Color(0xFF2C2926),
      secondary: Color(0xFFD6C8BC),
      onSecondary: Color(0xFF2C2926),
      surface: Color(0xFFFFFDFC),
      onSurface: Color(0xFF2C2926),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      outline: Color(0xFFDED6CF),
      surfaceContainerHighest: Color(0xFFF8F5F2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE1D7CE),
      foregroundColor: Color(0xFF2C2926),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFFFFDFC),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDED6CF), width: 0.5),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFDED6CF),
      thickness: 1,
    ),
    useMaterial3: true,
  );

  // ---------------------------------------------------------------------------
  // CUSTOM RGB KEYS
  // ---------------------------------------------------------------------------

  static const String customThemeKey = 'custom_rgb';
  static const String customRKey = 'custom_r';
  static const String customGKey = 'custom_g';
  static const String customBKey = 'custom_b';
  static const String fontKey = 'font_family';

  // ---------------------------------------------------------------------------
  // CUSTOM RGB THEME
  // ---------------------------------------------------------------------------

  static ThemeData _createCustomTheme(int r, int g, int b) {
    final Color primary = Color.fromRGBO(r, g, b, 1);

    final Color secondary = Color.fromRGBO(
      (r + 40).clamp(0, 255),
      (g + 40).clamp(0, 255),
      (b + 40).clamp(0, 255),
      1,
    );

    final Color background = Color.fromRGBO(
      (r + 20).clamp(0, 255),
      (g + 20).clamp(0, 255),
      (b + 20).clamp(0, 255),
      1,
    );

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

  // ---------------------------------------------------------------------------
  // LOAD SAVED THEME
  // ---------------------------------------------------------------------------

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
    } else if (savedTheme == 'creme' || savedTheme == 'bwnbits_cream') {
      baseTheme = bwnbitsCreamTheme;
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
      textTheme: _applyGoogleFont(baseTheme.textTheme, savedFont),
    );

    return ThemeProvider(
      finalTheme,
      themeName,
      savedFont,
      showCompletedCount,
      analyticsView,
      animationsEnabled,
    );
  }

  static TextTheme _applyGoogleFont(TextTheme baseTextTheme, String fontName) {
    switch (fontName) {
      case 'Roboto (Basic)':
        return GoogleFonts.robotoTextTheme(baseTextTheme);
      case 'Open Sans':
        return GoogleFonts.openSansTextTheme(baseTextTheme);
      case 'Lato':
        return GoogleFonts.latoTextTheme(baseTextTheme);
      default:
        return baseTextTheme;
    }
  }

  // ---------------------------------------------------------------------------
  // SET THEME
  // ---------------------------------------------------------------------------

  void setTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'theme_preference',
      themeName,
    );

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
    } else if (themeName == 'creme' || themeName == 'bwnbits_cream') {
      baseTheme = bwnbitsCreamTheme;
    } else if (themeName == customThemeKey) {
      final r = prefs.getInt(customRKey) ?? 0;
      final g = prefs.getInt(customGKey) ?? 0;
      final b = prefs.getInt(customBKey) ?? 0;

      baseTheme = _createCustomTheme(r, g, b);
    } else {
      baseTheme = lightTheme;
    }

    _currentTheme = baseTheme.copyWith(
      textTheme: _applyGoogleFont(baseTheme.textTheme, _fontFamily),
    );

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // FONT FAMILY
  // ---------------------------------------------------------------------------

  void setFontFamily(String familyName) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      fontKey,
      familyName,
    );

    _fontFamily = familyName;

    setTheme(_themeName);
  }

  // ---------------------------------------------------------------------------
  // CUSTOM THEME
  // ---------------------------------------------------------------------------

  void setCustomTheme(int r, int g, int b) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'theme_preference',
      customThemeKey,
    );

    await prefs.setInt(customRKey, r);
    await prefs.setInt(customGKey, g);
    await prefs.setInt(customBKey, b);

    _themeName = customThemeKey;

    final customBase = _createCustomTheme(
      r,
      g,
      b,
    );

    _currentTheme = customBase.copyWith(
      textTheme: _applyGoogleFont(customBase.textTheme, _fontFamily),
    );

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // PREFERENCES
  // ---------------------------------------------------------------------------

  void setShowCompletedCount(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'show_completed_count',
      value,
    );

    _showCompletedCount = value;

    notifyListeners();
  }

  void setAnalyticsView(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'analytics_view',
      value,
    );

    _analyticsView = value;

    notifyListeners();
  }

  void setAnimationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'animations_enabled',
      value,
    );

    _animationsEnabled = value;

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // RESET ALL DATA
  // ---------------------------------------------------------------------------

  void resetAllData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    _showCompletedCount = false;
    _analyticsView = '7day';
    _animationsEnabled = true;
    _themeName = 'system';
    _fontFamily = 'System Default';
    _currentTheme = lightTheme;

    notifyListeners();
  }
}
