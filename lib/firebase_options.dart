import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
    apiKey: 'AIzaSyAJ7JdJVNJmdTkcs_XCvDm1ZJqBXiPQEYA',
    appId: '1:659625801930:web:c35b476cdf2454cc975c33',
    messagingSenderId: '659625801930',
    projectId: 'shopping-list-4f2e6',
    authDomain: 'shopping-list-4f2e6.firebaseapp.com',
    storageBucket: 'shopping-list-4f2e6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChVT1KB6L9Da0mZHFHBNUzW8kf6k8lMbM',
    appId: '1:659625801930:android:b1bc94b827e97354975c33',
    messagingSenderId: '659625801930',
    projectId: 'shopping-list-4f2e6',
    storageBucket: 'shopping-list-4f2e6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDpRiXHAcr5ri8s8ZthryEpQIKWY8t4pI',
    appId: '1:659625801930:ios:2a2ad7ec3d6b9c04975c33',
    messagingSenderId: '659625801930',
    projectId: 'shopping-list-4f2e6',
    storageBucket: 'shopping-list-4f2e6.firebasestorage.app',
    iosBundleId: 'com.example.shopList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDpRiXHAcr5ri8s8ZthryEpQIKWY8t4pI',
    appId: '1:659625801930:ios:2a2ad7ec3d6b9c04975c33',
    messagingSenderId: '659625801930',
    projectId: 'shopping-list-4f2e6',
    storageBucket: 'shopping-list-4f2e6.firebasestorage.app',
    iosBundleId: 'com.example.shopList',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJ7JdJVNJmdTkcs_XCvDm1ZJqBXiPQEYA',
    appId: '1:659625801930:web:a95e396e1d9571b6975c33',
    messagingSenderId: '659625801930',
    projectId: 'shopping-list-4f2e6',
    authDomain: 'shopping-list-4f2e6.firebaseapp.com',
    storageBucket: 'shopping-list-4f2e6.firebasestorage.app',
  );

}