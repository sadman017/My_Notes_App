// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC3p2n_fzmxIpCl4FUT_Es8gfXD9U4NGVI',
    appId: '1:544396889180:web:70815f6b368fa85dc26a99',
    messagingSenderId: '544396889180',
    projectId: 'wolfproject5',
    authDomain: 'wolfproject5.firebaseapp.com',
    storageBucket: 'wolfproject5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwAcVEkAp8tisaXTvD95Z9y8AGTKOcLFM',
    appId: '1:544396889180:android:97c9adc0e0914f21c26a99',
    messagingSenderId: '544396889180',
    projectId: 'wolfproject5',
    storageBucket: 'wolfproject5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB89hXX0PFTckmheqUNOtSZ319Qgb5L0KM',
    appId: '1:544396889180:ios:50f4813d5565ea7dc26a99',
    messagingSenderId: '544396889180',
    projectId: 'wolfproject5',
    storageBucket: 'wolfproject5.appspot.com',
    iosBundleId: 'com.example.practiceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB89hXX0PFTckmheqUNOtSZ319Qgb5L0KM',
    appId: '1:544396889180:ios:1465254756d4a672c26a99',
    messagingSenderId: '544396889180',
    projectId: 'wolfproject5',
    storageBucket: 'wolfproject5.appspot.com',
    iosBundleId: 'com.example.practiceApp.RunnerTests',
  );
}
