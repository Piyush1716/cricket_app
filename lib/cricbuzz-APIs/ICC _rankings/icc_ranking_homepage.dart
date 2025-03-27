import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/allrounders.dart';
import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/batsmans.dart';
import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/bowlers.dart';
import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/teams.dart';
import 'package:flutter/material.dart';


class IccRankingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> rankingCategories = [
    {"title": "Batsmen", "icon": Icons.sports_cricket, "color": Colors.blue, "routes" : ICCBatsmans()},
    {"title": "Bowlers", "icon": Icons.sports_baseball, "color": Colors.red, "routes" : ICCBowlers()},
    {"title": "All-rounders", "icon": Icons.star, "color": Colors.green, "routes" : ICCAllRounders()},
    {"title": "Teams", "icon": Icons.people, "color": Colors.orange, "routes" : ICCTeams()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ICC Rankings"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: rankingCategories.length,
          itemBuilder: (context, index) {
            var category = rankingCategories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => category["routes"],),);
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: category["color"],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category["icon"], size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      category["title"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}