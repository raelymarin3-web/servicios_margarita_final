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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCiyEAxp0BqOxx0ciH0nD36CIbJV_cJA0',
    appId: '1:911066662980:android:9570691d49791f1db29411',
    messagingSenderId: '911066662980',
    projectId: 'servicios-margarita',
    storageBucket: 'servicios-margarita.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCiyEAxp0BqOxx0ciH0nD36CIbJV_cJA0',
    appId: '1:911066662980:ios:9570691d49791f1db29411',
    messagingSenderId: '911066662980',
    projectId: 'servicios-margarita',
    storageBucket: 'servicios-margarita.firebasestorage.app',
    iosBundleId: 'Com.raely.Serviciosmargarita',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCCiyEAxp0BqOxx0ciH0nD36CIbJV_cJA0',
    appId: '1:911066662980:web:9570691d49791f1db29411',
    messagingSenderId: '911066662980',
    projectId: 'servicios-margarita',
    storageBucket: 'servicios-margarita.firebasestorage.app',
    authDomain: 'servicios-margarita.firebaseapp.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCiyEAxp0BqOxx0ciH0nD36CIbJV_cJA0',
    appId: '1:911066662980:ios:9570691d49791f1db29411',
    messagingSenderId: '911066662980',
    projectId: 'servicios-margarita',
    storageBucket: 'servicios-margarita.firebasestorage.app',
    iosBundleId: 'Com.raely.Serviciosmargarita',
  );
}