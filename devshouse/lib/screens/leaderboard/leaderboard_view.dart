// ignore_for_file: unused_element, library_private_types_in_public_api

import 'package:devshouse/screens/leaderboard/judges_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller1;
  AnimationController? _controller2;
  AnimationController? _controller3;
  Animation<Offset>? _animation1;
  Animation<Offset>? _animation2;
  Animation<Offset>? _animation3;

  bool _animationsCompleted = false;
  bool? _showLeaderboard;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller3 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _animation1 = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(_controller1!);
    _animation2 = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(_controller2!);
    _animation3 = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(_controller3!);

    checkShowStatus();
  }

  void checkShowStatus() async {
    try {
      DocumentSnapshot showDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc('lol')
          .get();
      if (showDoc.exists) {
        final data = showDoc.data() as Map<String, dynamic>;
        final bool view = data['view'] ?? false;
        setState(() {
          _showLeaderboard = view;
          if (_showLeaderboard == true) {
            startAnimations();
          }
        });
      } else {
        setState(() {
          _showLeaderboard = false;
        });
      }
    } catch (e) {
      setState(() {
        _showLeaderboard = false;
      });
    }
  }

  void startAnimations() {
    _controller1!.forward();
    _controller2!.forward();
    _controller3!.forward();

    _controller3!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationsCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller1?.dispose();
    _controller2?.dispose();
    _controller3?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showLeaderboard == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_showLeaderboard == true) {
      return _buildLeaderboard();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.gavel),
              tooltip: 'Know Your Judges',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KnowYourJudgesScreen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black26, Colors.black],
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Card(
                elevation: 10,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icon.gif',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Please wait for the results to be declared!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLeaderboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.gavel),
            tooltip: 'Know Your Judges',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const KnowYourJudgesScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black, Colors.grey.shade900],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('teams')
              .orderBy('averageMark_1')
              .orderBy('averageMark_2')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            final List<Map<String, dynamic>> teams = [];
            for (var doc in documents) {
              final data = doc.data() as Map<String, dynamic>;
              final averageScore1 = data['averageMark_1'] ?? 0.0;
              final averageScore2 = data['averageMark_2'] ?? 0.0;
              final combinedScore = (averageScore1 + averageScore2) / 2;
              teams.add({
                'name': data['team_name'],
                'score': combinedScore,
              });
            }
            teams.sort((a, b) => b['score'].compareTo(a['score']));
            return Column(
              children: [
                if (teams.length > 2)
                  Stack(
                    children: [
                      if (_animationsCompleted)
                        Positioned.fill(
                          child: Image.asset(
                            'assets/a7128f2c657591d27a6c9eee365df80d.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                      _buildPodium(teams.sublist(0, 3)),
                    ],
                  ),
                if (_animationsCompleted)
                  Expanded(
                    child: ListView.builder(
                      itemCount: teams.length - 3,
                      itemBuilder: (context, index) {
                        final teamIndex = index + 3;
                        return ListTile(
                          tileColor: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text(teams[teamIndex]['name'],
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                              'Score: ${teams[teamIndex]['score'].toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white70)),
                          leading: CircleAvatar(
                              child: Text('${teamIndex + 1}',
                                  style: const TextStyle(color: Colors.white))),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPodium(List<Map<String, dynamic>> topThree) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _podiumPlace(
              topThree[1]['name'], topThree[1]['score'], 2, _animation2!),
          _podiumPlace(
              topThree[0]['name'], topThree[0]['score'], 1, _animation1!),
          _podiumPlace(
              topThree[2]['name'], topThree[2]['score'], 3, _animation3!),
        ],
      ),
    );
  }

  Widget _podiumPlace(
      String name, double score, int position, Animation<Offset> animation) {
    double size = position == 1 ? 140.0 : 120.0;
    Color borderColor = position == 1
        ? Colors.amberAccent
        : (position == 2 ? Colors.grey.shade300 : Colors.brown);
    double borderWidth = 5;

    List<Color> gradientColors = position == 1
        ? [Colors.amber.shade600, Colors.amber.shade200]
        : (position == 2
            ? [Colors.grey.shade500, Colors.grey.shade300]
            : [Colors.brown.shade400, Colors.brown.shade200]);

    return SlideTransition(
      position: animation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Position $position',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Score: ${score.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
