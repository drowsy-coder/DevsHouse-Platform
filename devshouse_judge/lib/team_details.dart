// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse_judge/score_screen.dart';
import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;

  const TeamDetailsScreen({super.key, required this.teamId});

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  late Future<QuerySnapshot> _teamFuture;

  @override
  void initState() {
    super.initState();
    _teamFuture = FirebaseFirestore.instance
        .collection('teams')
        .where('team_name', isEqualTo: widget.teamId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _teamFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Team not found'));
          }

          Map<String, dynamic> teamData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          return _buildTeamDetailsPage(teamData);
        },
      ),
    );
  }

  Widget _buildTeamDetailsPage(Map<String, dynamic> teamData) {
    final teamName = teamData['team_name'];
    final tableNumber = teamData['table_number'].toString();
    final idea = teamData['idea'];

    List<String> members = [];
    for (int i = 1; i <= 4; i++) {
      if (teamData.containsKey('member_$i')) {
        members.add(teamData['member_$i']);
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.table_chart,
                            color: Colors.blueAccent),
                        title: Text("Table - $tableNumber",
                            style: const TextStyle(color: Colors.black)),
                        tileColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading:
                            const Icon(Icons.group, color: Colors.greenAccent),
                        title: Text(teamName,
                            style: const TextStyle(color: Colors.black)),
                        tileColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate((members.length + 1) ~/ 2, (index) {
                int startIndex = index * 2;
                int endIndex = (startIndex + 2) > members.length
                    ? members.length
                    : startIndex + 2;
                List<String> sublist = members.sublist(startIndex, endIndex);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: sublist
                      .map((member) => Expanded(
                            child: Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person,
                                        color: _getIconColor(
                                            members.indexOf(member))),
                                    const SizedBox(width: 10),
                                    Flexible(
                                        child: Text(member,
                                            style: const TextStyle(
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.amberAccent),
                      SizedBox(width: 10),
                      Text("Idea",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    idea,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.blueAccent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScoreScreen(
                              teamName: teamName,
                            )),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.grade, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Grade Team",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _getIconColor(int index) {
  List<Color> colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent
  ];
  return colors[index % colors.length];
}
