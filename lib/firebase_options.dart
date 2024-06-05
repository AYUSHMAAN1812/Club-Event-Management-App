// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCN9C45uosYyHyDk9NR60yQ2ESLssB2ueU',
    appId: '1:174972512312:web:37bdf2772c7de458359ecd',
    messagingSenderId: '174972512312',
    projectId: 'club-event-management-app',
    authDomain: 'club-event-management-app.firebaseapp.com',
    storageBucket: 'club-event-management-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNF300dPod0Rb2mCCo1wJ5EKM67YFlbHo',
    appId: '1:174972512312:android:0c450ed5eff2eba3359ecd',
    messagingSenderId: '174972512312',
    projectId: 'club-event-management-app',
    storageBucket: 'club-event-management-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPfEpYKw9XbQ72zlx5L0GOPA99vAWuUiE',
    appId: '1:174972512312:ios:692a2b0e1f7e52c5359ecd',
    messagingSenderId: '174972512312',
    projectId: 'club-event-management-app',
    storageBucket: 'club-event-management-app.appspot.com',
    iosBundleId: 'dev.maan.clubEventManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPfEpYKw9XbQ72zlx5L0GOPA99vAWuUiE',
    appId: '1:174972512312:ios:692a2b0e1f7e52c5359ecd',
    messagingSenderId: '174972512312',
    projectId: 'club-event-management-app',
    storageBucket: 'club-event-management-app.appspot.com',
    iosBundleId: 'dev.maan.clubEventManagement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCN9C45uosYyHyDk9NR60yQ2ESLssB2ueU',
    appId: '1:174972512312:web:55f77b89ff0bdca7359ecd',
    messagingSenderId: '174972512312',
    projectId: 'club-event-management-app',
    authDomain: 'club-event-management-app.firebaseapp.com',
    storageBucket: 'club-event-management-app.appspot.com',
  );
}
