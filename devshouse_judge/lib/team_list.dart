// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse_judge/team_details.dart';
import 'package:flutter/material.dart';

class ManualTeamPage extends StatefulWidget {
  const ManualTeamPage({super.key});

  @override
  _ManualTeamPageState createState() => _ManualTeamPageState();
}

class _ManualTeamPageState extends State<ManualTeamPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Team'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Team',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = "";
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teams')
                  .orderBy('table_number')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot> teams = snapshot.data!.docs
                    .where((doc) =>
                        searchQuery.isEmpty ||
                        doc['team_name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    var team = teams[index];
                    var teamName =
                        "${team['table_number']} - ${team['team_name']}";
                    bool verified = (team.data() as Map<String, dynamic>?)
                                ?.containsKey('averageMark_1') ==
                            true &&
                        (team.data() as Map<String, dynamic>?)
                                ?.containsKey('averageMark_2') ==
                            true;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Colors.black87, Colors.black54],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              verified ? Icons.verified : Icons.group,
                              color: verified ? Colors.green : Colors.white,
                            ),
                            title: Text(
                              teamName,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: verified
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(
                                    teamId: team['team_name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
