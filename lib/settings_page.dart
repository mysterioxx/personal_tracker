import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

// --- PAGE 3: SETTINGS (Includes Attribution with Emojis) ---
// This is a StatelessWidget because its content doesn't change based on user interaction.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Theme', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // RadioListTile for each theme option
                RadioListTile<String>(
                  title: const Text('System Default'),
                  value: 'system',
                  groupValue: themeProvider.themeName,
                  onChanged: (value) => themeProvider.setTheme(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Light'),
                  value: 'light',
                  groupValue: themeProvider.themeName,
                  onChanged: (value) => themeProvider.setTheme(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Dark'),
                  value: 'dark',
                  groupValue: themeProvider.themeName,
                  onChanged: (value) => themeProvider.setTheme(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Peach Theme 🍑'),
                  value: 'peach',
                  groupValue: themeProvider.themeName,
                  onChanged: (value) => themeProvider.setTheme(value!),
                ),
                RadioListTile<String>(
                  title: const Text('Grape Theme 🍇'),
                  value: 'grape',
                  groupValue: themeProvider.themeName,
                  onChanged: (value) => themeProvider.setTheme(value!),
                ),
              ],
            ),
          ),
          // --- Custom Footer (Attribution) ---
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
            child: Column(
              children: [
                const Text(
                  'Created by Abhishek Ruhela in India with ❤️',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('🍉🍇', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}