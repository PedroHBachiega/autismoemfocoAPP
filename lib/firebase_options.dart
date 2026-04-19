import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBw1B0kDrCvKOZHCE9c-lpWff-aL0YXISI',
    appId: '1:241125743479:web:8a11e9ae8021b6a95b1f72',
    messagingSenderId: '241125743479',
    projectId: 'autismoemfoco-9117e',
    authDomain: 'autismoemfoco-9117e.firebaseapp.com',
    storageBucket: 'autismoemfoco-9117e.firebasestorage.app',
    measurementId: 'G-MTHJCGZ3EJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw1B0kDrCvKOZHCE9c-lpWff-aL0YXISI',
    appId: '1:241125743479:android:fe28655c68b759ed6e50e1', // Placeholder app ID
    messagingSenderId: '241125743479',
    projectId: 'autismoemfoco-9117e',
    storageBucket: 'autismoemfoco-9117e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBw1B0kDrCvKOZHCE9c-lpWff-aL0YXISI',
    appId: '1:241125743479:ios:fe28655c68b759ed6e50e1', // Placeholder app ID
    messagingSenderId: '241125743479',
    projectId: 'autismoemfoco-9117e',
    storageBucket: 'autismoemfoco-9117e.firebasestorage.app',
    iosBundleId: 'com.example.autismoEmFocoFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBw1B0kDrCvKOZHCE9c-lpWff-aL0YXISI',
    appId: '1:241125743479:ios:fe28655c68b759ed6e50e1', // Placeholder app ID
    messagingSenderId: '241125743479',
    projectId: 'autismoemfoco-9117e',
    storageBucket: 'autismoemfoco-9117e.firebasestorage.app',
    iosBundleId: 'com.example.autismoEmFocoFlutter.RunnerTests',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBw1B0kDrCvKOZHCE9c-lpWff-aL0YXISI',
    appId: '1:241125743479:web:8a11e9ae8021b6a95b1f72',
    messagingSenderId: '241125743479',
    projectId: 'autismoemfoco-9117e',
    authDomain: 'autismoemfoco-9117e.firebaseapp.com',
    storageBucket: 'autismoemfoco-9117e.firebasestorage.app',
    measurementId: 'G-MTHJCGZ3EJ',
  );
}
