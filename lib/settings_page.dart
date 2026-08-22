import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'netpulse/network_speed_service.dart';

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $uri');
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _red = 0;
  double _green = 0;
  double _blue = 0;

  bool _netPulseEnabled = false;

  final _netService = NetworkSpeedService();

  @override
  void initState() {
    super.initState();
    _loadCustomColors();
    _loadNetPulseState();
  }

  Future<void> _loadCustomColors() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _red = (prefs.getInt(ThemeProvider.customRKey) ?? 0).toDouble();
        _green = (prefs.getInt(ThemeProvider.customGKey) ?? 0).toDouble();
        _blue = (prefs.getInt(ThemeProvider.customBKey) ?? 0).toDouble();
      });
    }
  }

  Future<void> _loadNetPulseState() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _netPulseEnabled =
            prefs.getBool('netpulse_enabled') ?? false;
      });
    }
  }

  void _showContactDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Abhishek Ruhela',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Email: abhishekruhela@duck.com',
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => _launchUrl(
                'https://linkedin.com/in/abhishekruhela',
              ),
              child: const Text(
                'LinkedIn: linkedin.com/in/abhishekruhela',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => _launchUrl(
                'https://github.com/bwnbits',
              ),
              child: const Text(
                'GitHub: github.com/bwnbits',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ============================================================
              // APPEARANCE
              // ============================================================

              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        'Theme Mode',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      DropdownButton<String>(
                        value: themeProvider.themeName,
                        underline: const SizedBox(),

                        items: const [

                          DropdownMenuItem(
                            value: 'system',
                            child: Text('System Default'),
                          ),

                          DropdownMenuItem(
                            value: 'light',
                            child: Text('Light'),
                          ),

                          DropdownMenuItem(
                            value: 'dark',
                            child: Text('Dark'),
                          ),

                          DropdownMenuItem(
                            value: 'guava',
                            child: Text('Guava Theme'),
                          ),

                          DropdownMenuItem(
                            value: 'pineapple',
                            child: Text('Pineapple Theme'),
                          ),

                          DropdownMenuItem(
                            value: 'greyscale',
                            child: Text('Greyscale'),
                          ),

                          DropdownMenuItem(
                            value: 'grape',
                            child: Text('Grape Theme'),
                          ),

                          DropdownMenuItem(
                            value: 'peach',
                            child: Text('Peach Theme'),
                          ),

                          // NEW THEME
                          DropdownMenuItem(
                            value: 'bwnbits_cream',
                            child: Text('Bwnbits Cream'),
                          ),
                        ],

                        onChanged: (newValue) {
                          if (newValue != null) {
                            themeProvider.setTheme(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // FONT
              // ============================================================

              const Text(
                'Font',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: ThemeProvider.fontMap.keys.map(
                    (fontName) {
                      return RadioListTile<String>(
                        title: Text(
                          fontName,
                          style: TextStyle(
                            fontFamily:
                                ThemeProvider.fontMap[fontName],
                          ),
                        ),
                        value: fontName,
                        groupValue:
                            themeProvider.fontFamily,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            themeProvider.setFontFamily(
                              newValue,
                            );
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // CUSTOM THEME
              // ============================================================

              const Text(
                'Custom Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      _buildColorSlider(
                        'Red',
                        Colors.red,
                        _red,
                        (value) {
                          setState(() {
                            _red = value;
                          });
                        },
                      ),

                      _buildColorSlider(
                        'Green',
                        Colors.green,
                        _green,
                        (value) {
                          setState(() {
                            _green = value;
                          });
                        },
                      ),

                      _buildColorSlider(
                        'Blue',
                        Colors.blue,
                        _blue,
                        (value) {
                          setState(() {
                            _blue = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [

                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                _red.toInt(),
                                _green.toInt(),
                                _blue.toInt(),
                                1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                themeProvider.setCustomTheme(
                                  _red.toInt(),
                                  _green.toInt(),
                                  _blue.toInt(),
                                );
                              },
                              child: const Text(
                                'Apply Custom Theme',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // PREFERENCES
              // ============================================================

              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: [

                    ListTile(
                      title: const Text(
                        'Analytics View',
                      ),

                      subtitle: Text(
                        themeProvider.analyticsView == '7day'
                            ? '7-day history'
                            : '1-day history',
                      ),

                      trailing: Switch(
                        value:
                            themeProvider.analyticsView ==
                                '7day',

                        onChanged: (value) {
                          themeProvider.setAnalyticsView(
                            value ? '7day' : '1day',
                          );
                        },
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      title: const Text(
                        'Show Completed Count',
                      ),

                      trailing: Switch(
                        value:
                            themeProvider.showCompletedCount,

                        onChanged: (value) {
                          themeProvider
                              .setShowCompletedCount(value);
                        },
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      title: const Text(
                        'Animations',
                      ),

                      trailing: Switch(
                        value:
                            themeProvider.animationsEnabled,

                        onChanged: (value) {
                          themeProvider
                              .setAnimationsEnabled(value);
                        },
                      ),
                    ),

                    const Divider(height: 1),

                    SwitchListTile(
                      title: const Text(
                        'NetPulse (Internet Speed)',
                      ),

                      subtitle: const Text(
                        'Show real-time speed in notification',
                      ),

                      value: _netPulseEnabled,

                      onChanged: (value) async {
                        setState(() {
                          _netPulseEnabled = value;
                        });

                        final prefs =
                            await SharedPreferences
                                .getInstance();

                        await prefs.setBool(
                          'netpulse_enabled',
                          value,
                        );

                        if (value) {
                          await _netService.start();
                        } else {
                          await _netService.stop();
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // DATA MANAGEMENT
              // ============================================================

              const Text(
                'Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  title: const Text(
                    'Reset All Data',
                  ),

                  trailing: const Icon(
                    Icons.delete_sweep,
                    color: Colors.red,
                  ),

                  onTap: () async {
                    final confirmed =
                        await showDialog<bool>(
                      context: context,

                      builder: (context) =>
                          AlertDialog(
                        title: const Text(
                          'Reset All Data?',
                        ),

                        content: const Text(
                          'This action cannot be undone.',
                        ),

                        actions: [

                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                              context,
                              false,
                            ),

                            child: const Text(
                              'Cancel',
                            ),
                          ),

                          TextButton(
                            onPressed: () =>
                                Navigator.pop(
                              context,
                              true,
                            ),

                            child: const Text(
                              'Reset',
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      themeProvider.resetAllData();
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // ABOUT & UPDATES
              // ============================================================

              const Text(
                'About & Updates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Column(
                  children: [

                    ListTile(
                      leading: const Icon(
                        Icons.system_update_alt,
                        color: Colors.blue,
                      ),

                      title: const Text(
                        'Check for Updates',
                      ),

                      subtitle: const Text(
                        'View latest APK releases on GitHub',
                      ),

                      trailing: const Icon(
                        Icons.open_in_new,
                        size: 18,
                      ),

                      onTap: () => _launchUrl(
                        'https://github.com/bwnbits/personal_tracker/releases/latest',
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                      ),

                      title: const Text(
                        'Contact Details',
                      ),

                      trailing: const Icon(
                        Icons.chevron_right,
                      ),

                      onTap: () =>
                          _showContactDetails(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================================================
              // FOOTER
              // ============================================================

              Center(
                child: Column(
                  children: [

                    const Text(
                      'Personal Tracker v2.3.2',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Created by Abhishek Ruhela in India',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        IconButton(
                          icon: const Icon(
                            Icons.person_pin,
                            color: Colors.blue,
                          ),

                          onPressed: () => _launchUrl(
                            'https://linkedin.com/in/abhishekruhela',
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.code,
                            color: Colors.black,
                          ),

                          onPressed: () => _launchUrl(
                            'https://github.com/bwnbits',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COLOR SLIDER
  // ============================================================

  Widget _buildColorSlider(
    String label,
    Color color,
    double value,
    Function(double) onChanged,
  ) {
    return Row(
      children: [

        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: 255,
            divisions: 255,
            activeColor: color,
            inactiveColor:
                color.withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ),

        SizedBox(
          width: 35,
          child: Text(
            value.toInt().toString(),
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}