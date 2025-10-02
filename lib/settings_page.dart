// Imports for Flutter's UI components.
import 'package:flutter/material.dart';

// --- PAGE 3: SETTINGS (Includes Attribution with Emojis) ---
// This is a StatelessWidget because its content doesn't change based on user interaction.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            child: Center(
              child: Text(
                'App settings and theme controls will be here.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          // --- Custom Footer (Attribution) ---
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
            child: Column(
              children: [
                const Text(
                  'Created by Abhishek Ruhela in India with ❤️',
                  style: TextStyle(
                    fontSize: 14,
                    // Use opacity for a subtle, modern footer look.
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                // Using Text widget for emojis
                const Text(
                  '🍉🍇', // Watermelon and Grapes emojis
                  style: TextStyle(fontSize: 24), // Adjust size as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}