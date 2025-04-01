import 'package:cricketX/cricbuzz-APIs/ICC%20_rankings/allrounders.dart';
import 'package:cricketX/cricbuzz-APIs/ICC%20_rankings/batsmans.dart';
import 'package:cricketX/cricbuzz-APIs/ICC%20_rankings/bowlers.dart';
import 'package:cricketX/cricbuzz-APIs/ICC%20_rankings/teams.dart';
import 'package:flutter/material.dart';

class IccRankingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> rankingCategories = [
    {"title": "Batsmen", "icon": Icons.sports_cricket, "color": Colors.blue, "route": ICCBatsmans()},
    {"title": "Bowlers", "icon": Icons.sports_baseball, "color": Colors.red, "route": ICCBowlers()},
    {"title": "All-rounders", "icon": Icons.star, "color": Colors.green, "route": ICCAllRounders()},
    {"title": "Teams", "icon": Icons.people, "color": Colors.orange, "route": ICCTeams()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ICC Rankings", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: rankingCategories.length,
          itemBuilder: (context, index) {
            var category = rankingCategories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => category["route"]),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: category["color"],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category["icon"], size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              category["title"],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
