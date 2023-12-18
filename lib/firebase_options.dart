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
    apiKey: 'AIzaSyCGscNQrAYbh67qvx8AKe2XI_Lkkh64C1c',
    appId: '1:798630235321:web:7d28add1770bf3361a1f68',
    messagingSenderId: '798630235321',
    projectId: 'studygetherflutter',
    authDomain: 'studygetherflutter.firebaseapp.com',
    storageBucket: 'studygetherflutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTel0TtXh0JBpYbVToIKpxVyhWtxHp7BM',
    appId: '1:798630235321:android:9fccb7b4003092961a1f68',
    messagingSenderId: '798630235321',
    projectId: 'studygetherflutter',
    storageBucket: 'studygetherflutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDi5GIpsw9uugEWEXU3S4RlHtdP14bRpCE',
    appId: '1:798630235321:ios:02b70c9f53ab01521a1f68',
    messagingSenderId: '798630235321',
    projectId: 'studygetherflutter',
    storageBucket: 'studygetherflutter.appspot.com',
    iosBundleId: 'com.example.studygether',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDi5GIpsw9uugEWEXU3S4RlHtdP14bRpCE',
    appId: '1:798630235321:ios:cdc333b4039db30e1a1f68',
    messagingSenderId: '798630235321',
    projectId: 'studygetherflutter',
    storageBucket: 'studygetherflutter.appspot.com',
    iosBundleId: 'com.example.studygether.RunnerTests',
  );
}