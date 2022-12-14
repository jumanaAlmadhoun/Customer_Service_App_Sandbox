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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIy-eW_6oZL3G9xNztgLO6Up3qI4sfZCw',
    appId: '1:322149189704:web:505b4b8374ea8d58cab07d',
    messagingSenderId: '322149189704',
    projectId: 'mintinenseappsandbox',
    authDomain: 'mintinenseappsandbox.firebaseapp.com',
    databaseURL: 'https://mintinenseappsandbox-default-rtdb.firebaseio.com',
    storageBucket: 'mintinenseappsandbox.appspot.com',
    measurementId: 'G-TV5LXT9HS8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgEwnwfH6IkRnLto-yuF-s-02kL4Gjz-Q',
    appId: '1:322149189704:android:c83b867f8679a198cab07d',
    messagingSenderId: '322149189704',
    projectId: 'mintinenseappsandbox',
    databaseURL: 'https://mintinenseappsandbox-default-rtdb.firebaseio.com',
    storageBucket: 'mintinenseappsandbox.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7PwKp2vBktInIZNC9z2-xPUjFU1FWjrc',
    appId: '1:322149189704:ios:b1f639eec8847d2bcab07d',
    messagingSenderId: '322149189704',
    projectId: 'mintinenseappsandbox',
    databaseURL: 'https://mintinenseappsandbox-default-rtdb.firebaseio.com',
    storageBucket: 'mintinenseappsandbox.appspot.com',
    androidClientId: '322149189704-5mv0ed76t6soh4c5j8j156fo4rg0bgch.apps.googleusercontent.com',
    iosClientId: '322149189704-4rc96hej7hc2c95v73d2rhjonhn8tkfm.apps.googleusercontent.com',
    iosBundleId: 'com.example.customerServiceApp',
  );
}
