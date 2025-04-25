# BMI-CALCUL

BMI Calculator App
<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
</div>
A modern, user-friendly Body Mass Index (BMI) calculator application built with Flutter and Firebase. The app provides a comprehensive solution for tracking and managing BMI records with multi-language support.
Features

User Authentication: Secure login and registration system using Firebase Authentication
BMI Calculation: Calculate BMI based on weight and height inputs
Visual Representation: Animated gauge to visualize BMI categories
History Tracking: Save and view BMI history with timestamps
Multi-language Support: Available in English, Arabic, and French with automatic RTL support
Responsive Design: Works across different device sizes and orientations

Screenshots
<!-- Add screenshots of your app here -->
Tech Stack

Frontend: Flutter SDK
Backend: Firebase (Authentication, Firestore)
State Management: Flutter's built-in StatefulWidget
Localization: Custom localization service with shared preferences
UI Components: Material Design

Project Structure
lib/
├── main.dart                   # Entry point for the application
├── auth_screens.dart           # Login and registration screens
├── bmi_calculator.dart         # BMI calculation and visualization
├── firebase_config.dart        # Firebase configuration and BMI model
├── language_selection.dart     # Language selection screen
├── localization_service.dart   # Localization management
└── translations/               # Translation files
    ├── en.dart                 # English translations
    ├── ar.dart                 # Arabic translations
    └── fr.dart                 # French translations
Getting Started
Prerequisites

Flutter SDK (3.1.0 or higher)
Dart SDK
Firebase account
Android Studio / VS Code

Installation

Clone the repository:
bashgit clone https://github.com/your-username/bmi-calculator.git
cd bmi-calculator

Install dependencies:
bashflutter pub get

Connect to Firebase:

Create a new Firebase project
Configure Firebase for Flutter as shown in the official documentation
Enable Authentication and Firestore services


Run the app:
bashflutter run


Firebase Configuration
The app uses Firebase for authentication and storing BMI records. You'll need to set up:

Authentication: Enable Email/Password sign-in method
Firestore Database: Create a database with the following collections:

users: User profiles
bmi_records: BMI calculation history



Localization
The app supports multiple languages:

English
Arabic (with RTL support)
French

To add more languages:

Create a new translation file in the translations folder
Update the LocalizationService to include the new language
Add the language option in the LanguageSelectionScreen

Features In Detail
BMI Calculation
The app calculates BMI using the formula: BMI = weight(kg) / height²(m)
The BMI categories are:

Below 16: Severely Underweight
16-18.5: Underweight
18.5-25: Optimal
25-30: Overweight
30-35: Obese
Above 35: Severely Obese

Authentication Flow

First-time users are directed to language selection
Users can register with email, password, and name
Returning users can sign in with email and password
Firebase handles authentication state persistence

BMI History
The app stores each BMI calculation with:

User ID
Weight
Height
Calculated BMI
BMI Category
Timestamp

Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

Fork the repository
Create your feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request
