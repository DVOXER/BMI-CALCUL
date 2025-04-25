My BMI Calculator App
Hey there! 👋 Welcome to my BMI Calculator project. I built this app to help people track their BMI (Body Mass Index) in a simple and intuitive way. It's my first serious Flutter project with Firebase integration, and I'm pretty excited to share it.
What's This App About?
I created this BMI calculator to solve a common problem: making health tracking accessible and straightforward. My app lets you:

Calculate your BMI with just your height and weight
See where you stand with a cool animated gauge
Track your BMI history over time
Use the app in English, Arabic, or French (I wanted to make it accessible!)

Tech I Used

Flutter for building the cross-platform UI
Firebase for authentication and storing user data
Shared Preferences for saving user settings like language preference
Custom localization system I built from scratch

Features I'm Proud Of
User-Friendly Authentication
I implemented a complete login/registration system with Firebase. The app remembers who you are so you don't need to log in every time.
Smooth BMI Calculation
Just enter your weight and height, and the app calculates your BMI instantly. I added an animated gauge to visually show where your BMI falls on the scale.
Multi-Language Support
I added support for English, Arabic and French. The app even handles right-to-left text direction for Arabic automatically!
History Tracking
Every BMI calculation is saved to your personal history, so you can track changes over time.
How to Run My Project

Clone this repo to your local machine
Run flutter pub get to install dependencies
Make sure you have Firebase configured (see Firebase setup section below)
Run the app with flutter run

Firebase Setup
You'll need to:

Create a Firebase project
Enable Authentication with Email/Password
Set up Cloud Firestore
Update the Firebase config file with your credentials

Project Structure
I organized my code like this:
lib/
├── main.dart                  # App entry point
├── auth_screens.dart          # Login and registration screens
├── bmi_calculator.dart        # The main BMI calculator functionality
├── firebase_config.dart       # Firebase setup
├── language_selection.dart    # Language picker
├── localization_service.dart  # My custom localization service
└── translations/              # Language files
    ├── en.dart
    ├── ar.dart
    └── fr.dart
Future Plans
I'm planning to add:

Weight/BMI trend graphs
Option to switch between metric and imperial units
More languages
Cloud sync across devices
Dark mode

Thanks for Checking This Out!
Feel free to use this code, modify it, or suggest improvements! If you have any questions or want to collaborate, just reach out.
Screenshots
