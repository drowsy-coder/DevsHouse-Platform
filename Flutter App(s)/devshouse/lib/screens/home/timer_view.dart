// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _duration = const Duration();
  bool _isFirstTarget = true;

  @override
  void initState() {
    super.initState();
    _isFirstTarget = DateTime.now().isBefore(DateTime(2024, 3, 15, 17, 30));
    startTimer();
  }

  void startTimer() {
    final DateTime firstTarget = DateTime(2024, 3, 15, 17, 00);
    final DateTime secondTarget = DateTime(2024, 3, 17, 5, 00);
    DateTime targetTime = _isFirstTarget ? firstTarget : secondTarget;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final difference = targetTime.difference(now);
      if (difference.isNegative) {
        if (_isFirstTarget) {
          targetTime = secondTarget;
          _isFirstTarget = false;
        } else {
          _timer?.cancel();
        }
      }
      setState(() {
        _duration = difference;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$hours:$minutes:$seconds',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _isFirstTarget
                    ? 'until hackathon starts!'
                    : 'till submission ends!',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
