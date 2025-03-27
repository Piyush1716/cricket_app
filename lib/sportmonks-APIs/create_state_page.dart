import 'package:flutter/material.dart';

class CareerStatsPage extends StatelessWidget {
  final List<dynamic> careerData;

  CareerStatsPage({required this.careerData});

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> groupedData = {};
    
    for (var career in careerData) {
      String type = career['type'];
      if (!groupedData.containsKey(type)) {
        groupedData[type] = [];
      }
      groupedData[type]!.add(career);
    }

    return DefaultTabController(
      length: groupedData.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Career Stats"),
          bottom: TabBar(
            isScrollable: true,
            tabs: groupedData.keys.map((format) => Tab(text: format)).toList(),
          ),
        ),
        body: TabBarView(
          children: groupedData.keys.map((format) {
            List<dynamic> stats = groupedData[format]!;
            return ListView(
              padding: EdgeInsets.all(16),
              children: stats.map((stat) => _buildStatCard(stat)).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(dynamic stat) {
    bool isBatsman = stat['batting'] != null;
    bool isBowler = stat['bowling'] != null;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Season: ${stat['season_id']}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (isBatsman)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Matches: ${stat['batting']['matches']}"),
                  Text("Runs: ${stat['batting']['runs_scored']}"),
                  Text("Average: ${stat['batting']['average']}"),
                  Text("Strike Rate: ${stat['batting']['strike_rate']}"),
                  Text("50s: ${stat['batting']['fifties']} | 100s: ${stat['batting']['hundreds']}"),
                ],
              ),
            if (isBowler)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Overs: ${stat['bowling']['overs']}"),
                  Text("Wickets: ${stat['bowling']['wickets']}"),
                  Text("Economy: ${stat['bowling']['econ_rate']}"),
                  Text("Average: ${stat['bowling']['average']}"),
                  Text("4W: ${stat['bowling']['four_wickets']} | 5W: ${stat['bowling']['five_wickets']}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
