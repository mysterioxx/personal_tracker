import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Standalone function to launch a URL.
Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // A new method to show the contact details modal.
  void _showContactDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Details'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Abhishek Ruhela', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: abhishek@example.com'),
            Text('Phone: +91 98765 43210'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Theme Section ---
              const Text('Appearance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    _buildThemeRadioTile('System Default', 'system', themeProvider),
                    _buildThemeRadioTile('Light', 'light', themeProvider),
                    _buildThemeRadioTile('Dark', 'dark', themeProvider),
                    _buildThemeRadioTile('Guava Theme', 'guava', themeProvider),
                    _buildThemeRadioTile('Pineapple Theme 🍍', 'pineapple', themeProvider),
                    _buildThemeRadioTile('Greyscale', 'greyscale', themeProvider),
                    _buildThemeRadioTile('Grape Theme 🍇', 'grape', themeProvider),
                    _buildThemeRadioTile('Peach Theme 🍑', 'peach', themeProvider),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Preferences Section ---
              const Text('Preferences', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Analytics View'),
                      subtitle: Text(themeProvider.analyticsView == '7day' ? '7-day history' : '1-day history'),
                      trailing: Switch(
                        value: themeProvider.analyticsView == '7day',
                        onChanged: (value) {
                          themeProvider.setAnalyticsView(value ? '7day' : '1day');
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Show Completed Count'),
                      trailing: Switch(
                        value: themeProvider.showCompletedCount,
                        onChanged: (value) {
                          themeProvider.setShowCompletedCount(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Animations'),
                      trailing: Switch(
                        value: themeProvider.animationsEnabled,
                        onChanged: (value) {
                          themeProvider.setAnimationsEnabled(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Data & About Section ---
              const Text('Data', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Reset All Data'),
                      trailing: const Icon(Icons.delete_sweep, color: Colors.red),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Reset All Data?'),
                            content: const Text('This action cannot be undone. Are you sure?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          themeProvider.resetAllData();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // New About Section
              const Text('About', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text('Contact Details'),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () => _showContactDetails(context),
                ),
              ),

              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    const Text('Created by Abhishek Ruhela in India with ❤️', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text('🍉🍇', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person_pin, color: Colors.blue),
                          onPressed: () => _launchUrl('http://linkedin.com/in/abhishekruhela/'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.code, color: Colors.black),
                          onPressed: () => _launchUrl('http://github.com/mysterioxx'),
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

  Widget _buildThemeRadioTile(String title, String value, ThemeProvider themeProvider) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: themeProvider.themeName,
      onChanged: (newValue) => themeProvider.setTheme(newValue!),
    );
  }
}