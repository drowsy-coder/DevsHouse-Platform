import 'package:devshouse_volunteers/qr_scanner_breakfast1.dart';
import 'package:devshouse_volunteers/qr_scanner_breakfast2.dart';
import 'package:devshouse_volunteers/qr_scanner_dinner1.dart';
import 'package:devshouse_volunteers/qr_scanner_dinner2.dart';
import 'package:devshouse_volunteers/qr_scanner_lunch.dart';
import 'package:devshouse_volunteers/qr_scanner_snacks1.dart';
import 'package:devshouse_volunteers/qr_scanner_snacks2.dart';
import 'package:devshouse_volunteers/qr_scanner_snacks3.dart';
import 'package:flutter/material.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey Volunteer!'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MealCard(
                    mealName: 'Snacks',
                    date: '15th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerSnacks1()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: MealCard(
                    mealName: 'Dinner',
                    date: '15th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerDinner1()),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MealCard(
                    mealName: 'Breakfast',
                    date: '16th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerBreakfast1()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: MealCard(
                    mealName: 'Lunch',
                    date: '16th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerLunch()),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MealCard(
                    mealName: 'Dinner',
                    date: '16th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerDinner2()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: MealCard(
                    mealName: 'Snacks',
                    date: '16th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerSnacks2()),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MealCard(
                    mealName: 'Breakfast',
                    date: '17th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerBreakfast2()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: MealCard(
                    mealName: 'Snacks',
                    date: '17th March',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerSnacks3()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealName;
  final String date;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.mealName,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 4.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 1.0],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.restaurant,
                color: Colors.redAccent,
                size: 32.0,
              ),
              const SizedBox(height: 12.0),
              Text(
                mealName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
