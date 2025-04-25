import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'localization_service.dart';
import 'package:flag/flag_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text('select_language'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            // Check if user is logged in
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                const Icon(
                  Icons.health_and_safety,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),

                // App Title
                Text(
                  'app_name'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // App Subtitle
                Text(
                  'select_language'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 48),

                // Language Selection Buttons
                _buildLanguageButton(
                  context,
                  'English',
                  'en',
                  FlagsCode.US,
                ),
                const SizedBox(height: 16),
                _buildLanguageButton(
                  context,
                  'العربية',
                  'ar',
                  FlagsCode.SA,  // Saudi Arabia as an example for Arabic
                ),
                const SizedBox(height: 16),
                _buildLanguageButton(
                  context,
                  'Français',
                  'fr',
                  FlagsCode.FR,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
      BuildContext context,
      String language,
      String languageCode,
      FlagsCode flagCode,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Change the language
            LocalizationService.changeLocale(languageCode);

            // Check if user is logged in
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Flag.fromCode(
                  flagCode,
                  height: 24,
                  width: 24,
                  borderRadius: 4,
                ),
                const SizedBox(width: 12),
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}