# My BMI Calculator App

Hey there! 👋 Welcome to my BMI Calculator project. I built this app to help people track their BMI (Body Mass Index) in a simple and intuitive way. It's my first serious Flutter project with Firebase integration, and I'm pretty excited to share it.

## What's This App About?

I created this BMI calculator to solve a common problem: making health tracking accessible and straightforward. My app lets you:

- Calculate your BMI with just your height and weight
- See where you stand with a cool animated gauge
- Track your BMI history over time
- Use the app in English, Arabic, or French (I wanted to make it accessible!)

## Tech I Used

- **Flutter** for building the cross-platform UI
- **Firebase** for authentication and storing user data
- **Shared Preferences** for saving user settings like language preference
- Custom localization system I built from scratch

## Features I'm Proud Of

### User-Friendly Authentication
I implemented a complete login/registration system with Firebase. The app remembers who you are so you don't need to log in every time.

### Smooth BMI Calculation
Just enter your weight and height, and the app calculates your BMI instantly. I added an animated gauge to visually show where your BMI falls on the scale.

### Multi-Language Support
I added support for English, Arabic and French. The app even handles right-to-left text direction for Arabic automatically!

### History Tracking
Every BMI calculation is saved to your personal history, so you can track changes over time.

## How to Run My Project

1. Clone this repo to your local machine
2. Run `flutter pub get` to install dependencies
3. Make sure you have Firebase configured (see Firebase setup section below)
4. Run the app with `flutter run`

## Firebase Setup

You'll need to:
1. Create a Firebase project
2. Enable Authentication with Email/Password
3. Set up Cloud Firestore
4. Update the Firebase config file with your credentials

## Project Structure

I organized my code like this:
```
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
```

## Future Plans

I'm planning to add:
- Weight/BMI trend graphs
- Option to switch between metric and imperial units
- More languages
- Cloud sync across devices
- Dark mode

## Thanks for Checking This Out!

Feel free to use this code, modify it, or suggest improvements! If you have any questions or want to collaborate, just reach out.

## Screenshots

<!-- I'll add some screenshots of my app in action here -->
![Capture d'écran 2025-04-25 094814](https://github.com/user-attachments/assets/1a5292b9-4532-48df-a43c-391d971649f6)
![Capture d'écran 2025-04-25 094804](https://github.com/user-attachments/assets/34c15709-9f7b-4b15-be14-3f8aa6c31929)
![Capture d'écran 2025-04-25 094917](https://github.com/user-attachments/assets/711efaa9-1eda-4574-bc08-08e6402f34bf)
![Capture d'écran 2025-04-25 094904](https://github.com/user-attachments/assets/2f3a6832-915e-4700-8a5e-57d81166edfd)
![Capture d'écran 2025-04-25 094851](https://github.com/user-attachments/assets/a6debd0b-916c-48f4-9794-cc27e8874194)
![Capture d'écran 2025-04-25 094845](https://github.com/user-attachments/assets/5b5480b9-18b8-453f-a039-8b9fd5c200ea)
![Capture d'écran 2025-04-25 094821](https://github.com/user-attachments/assets/66329960-8b8b-4b64-aa14-14b19365a99d)
