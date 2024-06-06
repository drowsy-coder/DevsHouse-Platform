// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vibration/vibration.dart';

class RatingCategory {
  String name;
  int score;

  RatingCategory({required this.name, required this.score});
}

class ScoreScreen extends StatefulWidget {
  final String teamName;

  const ScoreScreen({super.key, required this.teamName});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<RatingCategory> categories = [
    RatingCategory(name: 'Idea', score: 5),
    RatingCategory(name: 'User Interface', score: 5),
    RatingCategory(name: 'Completion', score: 5),
    RatingCategory(name: 'Technical Robustness', score: 5),
    RatingCategory(name: 'Business Proposition', score: 5),
  ];

  Color _getSliderColor(int value) {
    if (value >= 0 && value < 4) {
      return Colors.red;
    } else if (value >= 4 && value < 8) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  Future<void> _submitScores() async {
    final collection = FirebaseFirestore.instance.collection('teams');
    final QuerySnapshot querySnapshot =
        await collection.where('team_name', isEqualTo: widget.teamName).get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Team not found')));
      return;
    }

    final DocumentSnapshot teamDoc = querySnapshot.docs.first;
    Map<String, dynamic> data = teamDoc.data() as Map<String, dynamic>;
    String suffix = "";

    if (!data.containsKey('averageMark_1')) {
      suffix = "_1";
    } else if (!data.containsKey('averageMark_2')) {
      suffix = "_2";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Project has already been graded twice')));
      return;
    }

    double averageScore =
        categories.fold(0, (prev, element) => prev + element.score).toDouble() /
            categories.length;
    averageScore = double.parse(averageScore.toStringAsFixed(2));

    Map<String, dynamic> scoresToUpdate = {'averageMark$suffix': averageScore};
    for (var category in categories) {
      scoresToUpdate['${category.name.replaceAll(' ', '')}$suffix'] =
          category.score;
    }

    await collection
        .doc(teamDoc.id)
        .set(scoresToUpdate, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scores updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ${widget.teamName}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: categories
                .map(
                  (category) => Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: SfSlider(
                        min: 0,
                        max: 10,
                        value: category.score.toDouble(),
                        interval: 1,
                        showTicks: true,
                        showLabels: true,
                        activeColor: _getSliderColor(category.score),
                        inactiveColor:
                            _getSliderColor(category.score).withOpacity(0.24),
                        onChanged: (dynamic value) {
                          Vibration.vibrate(duration: 15);
                          setState(() {
                            category.score = value.round();
                          });
                        },
                      ),
                    ),
                  ),
                )
                .toList()
              ..add(
                Card(
                  margin: const EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitScores,
                      child: const Text('Submit Scores',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}
