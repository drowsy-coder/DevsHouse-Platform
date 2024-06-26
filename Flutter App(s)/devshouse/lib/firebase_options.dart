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
    apiKey: 'AIzaSyBCK4f_i1Ovsd4QAXwUnE5bWDipKKSLvTk',
    appId: '1:314172025846:android:0368efcd36adaf3c3ef5d7',
    messagingSenderId: '314172025846',
    projectId: 'devshouse-dscvitc',
    storageBucket: 'devshouse-dscvitc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDO4dSxruMAM8_jbxbjjwmsP5kMK-Eywfo',
    appId: '1:314172025846:ios:806c4480fe4c6feb3ef5d7',
    messagingSenderId: '314172025846',
    projectId: 'devshouse-dscvitc',
    storageBucket: 'devshouse-dscvitc.appspot.com',
    androidClientId: '314172025846-0rft6bpd4vndgo0g1br1kgsj4funeqcm.apps.googleusercontent.com',
    iosClientId: '314172025846-2uuqdikv6o002ahlr3h4mn128p1j0t5o.apps.googleusercontent.com',
    iosBundleId: 'com.dscvitc.devshouse',
  );
}
