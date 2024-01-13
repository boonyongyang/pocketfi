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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBisbG8J1UiBRffh0JRBZt4B2Th22iRylk',
    appId: '1:308866983425:android:ab88a6dc6909ab8dc60200',
    messagingSenderId: '308866983425',
    projectId: 'pocketfi-jellyy',
    storageBucket: 'pocketfi-jellyy.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLkd-83zPno_YuGgUiCfCUqrF1U19mpOc',
    appId: '1:308866983425:ios:6ceba8c1a798114fc60200',
    messagingSenderId: '308866983425',
    projectId: 'pocketfi-jellyy',
    storageBucket: 'pocketfi-jellyy.appspot.com',
    androidClientId: '308866983425-ftf0brdlsr0tt2osvklcnjocmld1v9sd.apps.googleusercontent.com',
    iosClientId: '308866983425-aq8b8ug1k8bfovlmorltrfe1a5rhg8o9.apps.googleusercontent.com',
    iosBundleId: 'jellyy.pocketfi',
  );
}
