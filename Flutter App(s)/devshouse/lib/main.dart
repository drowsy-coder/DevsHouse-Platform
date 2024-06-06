import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse/auth/login_logic.dart';
import 'package:devshouse/auth/login_ui.dart';
import 'package:devshouse/notifications/notification_service.dart';
import 'package:devshouse/screens/home/home_screen.dart';
import 'package:devshouse/screens/home/not_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().init();

  User? user = FirebaseAuth.instance.currentUser;
  bool isUserInDatabase = user != null ? await checkUserAuth(user) : false;

  Widget homeScreen;
  if (user == null) {
    homeScreen = LoginPageUI(
      logic: LoginPageLogic(),
    );
  } else if (isUserInDatabase == true) {
    homeScreen = HomeScreen();
  } else {
    homeScreen = const NewScreen();
  }

  runApp(MyApp(homeScreen: homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({super.key, required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: homeScreen,
    );
  }
}

Future<bool> checkUserAuth(User? user) async {
  if (user != null && user.email != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
  return false;
}
