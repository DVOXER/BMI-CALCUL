import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyDn-ftRztONMvESFjyoJaW5Ce1ORT12g',
    appId: '1:623240154666:web:70c50b81a3c71d74303d53',
    messagingSenderId: '623240154666',
    projectId: 'cccbmi',
    authDomain: 'cccbmi.firebaseapp.com',
    storageBucket: 'cccbmi.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVjCFs_s1KsqAhFcZgRZ7aTA92BPrCa1M',
    appId: '1:623240154666:android:696339323747261b303d53',
    messagingSenderId: '623240154666',
    projectId: 'cccbmi',
    storageBucket: 'cccbmi.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCF3unlOr5lgVoGqHUyNiEXfNKPP47Hqtw',
    appId: '1:623240154666:ios:a5bb044441af92f5303d53',
    messagingSenderId: '623240154666',
    projectId: 'cccbmi',
    storageBucket: 'cccbmi.firebasestorage.app',
    iosBundleId: 'com.example.cbmi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCF3unlOr5lgVoGqHUyNiEXfNKPP47Hqtw',
    appId: '1:623240154666:ios:a5bb044441af92f5303d53',
    messagingSenderId: '623240154666',
    projectId: 'cccbmi',
    storageBucket: 'cccbmi.firebasestorage.app',
    iosBundleId: 'com.example.cbmi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCyDn-ftRztONMvESFjyoJaW5Ce1ORT12g',
    appId: '1:623240154666:web:0ac16a4978adf5c9303d53',
    messagingSenderId: '623240154666',
    projectId: 'cccbmi',
    authDomain: 'cccbmi.firebaseapp.com',
    storageBucket: 'cccbmi.firebasestorage.app',
  );
}

// BMI Record Model
class BMIRecord {
  final String userId;
  final double bmi;
  final double height;  // stored in centimeters
  final double weight;  // stored in kilograms
  final String category;
  final DateTime timestamp;
  String? id;  // Firestore document ID

  BMIRecord({
    required this.userId,
    required this.bmi,
    required this.height,
    required this.weight,
    required this.category,
    required this.timestamp,
    this.id,
  });

  factory BMIRecord.fromMap(Map<String, dynamic> map, String documentId) {
    return BMIRecord(
      id: documentId,
      userId: map['userId'] ?? '',
      bmi: (map['bmi'] ?? 0.0).toDouble(),
      height: (map['height'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'Unknown',
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bmi': bmi,
      'height': height,
      'weight': weight,
      'category': category,
      'timestamp': timestamp,
    };
  }
}