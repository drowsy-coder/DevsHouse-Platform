// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:devshouse/screens/leaderboard/leaderboard_view.dart';
import 'package:devshouse/widgets/drawer/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse/screens/map/main_map.dart';
import 'package:devshouse/auth/login_ui.dart';
import 'package:devshouse/auth/login_logic.dart';
import 'package:devshouse/widgets/qr_code_view.dart';

class UserProfileDrawer extends StatefulWidget {
  const UserProfileDrawer({super.key});

  @override
  _UserProfileDrawerState createState() => _UserProfileDrawerState();
}

class _UserProfileDrawerState extends State<UserProfileDrawer> {
  late Future<Map<String, dynamic>?> userDataFuture;
  int _tapCounter = 0;
  DateTime? _firstTapTime;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  void _onDscVitChennaiTapped() {
    final now = DateTime.now();
    if (_firstTapTime == null || now.difference(_firstTapTime!).inSeconds > 5) {
      _firstTapTime = now;
      _tapCounter = 1;
    } else {
      _tapCounter++;
      if (_tapCounter >= 5) {
        _showEasterEggAlert();
        _tapCounter = 0;
        _firstTapTime = null;
      }
    }
  }

  void _showEasterEggAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text(
          "drowsycoder",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/111220288-3.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Thanks for discovering this Easter Egg! Hope you enjoy using the app.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[200]),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Awesome!',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2E),
              Color(0xFF1B1B1D),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      CustomDrawerHeader(userData: userData),
                      _buildOptionTile(Icons.qr_code, 'Display QR Code', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QRCodeScreen()),
                        );
                      }),
                      _buildOptionTile(Icons.map, 'Show VIT Campus Map',
                          () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VITMap()),
                        );
                      }),
                      _buildOptionTile(Icons.leaderboard, 'Leaderboard',
                          () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderboardScreen()),
                        );
                      }),
                      _buildOptionTile(Icons.exit_to_app, 'Logout', () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPageUI(logic: LoginPageLogic())),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: _onDscVitChennaiTapped, // Add this line
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/1*vZVM7utCuRiZ6-HDsNeYUA@2x.png',
                          height: 21,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'DSC VIT Chennai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      tileColor: Colors.transparent,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
    );
  }
}

