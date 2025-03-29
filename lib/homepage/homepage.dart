import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/icc_ranking_homepage.dart';
import 'package:cricket_app/cricbuzz-APIs/news_page/news_home_screen.dart';
import 'package:cricket_app/cricbuzz-APIs/player_search/search_player_homepage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Hub',
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildHomeTile(
              context,
              icon: Icons.newspaper,
              title: 'Cricket News',
              destination: CricketNewsScreen(),
            ),
            _buildHomeTile(
              context,
              icon: Icons.search,
              title: 'Player Search',
              destination: SearchPlayerHomepage(),
            ),
            _buildHomeTile(
              context,
              icon: Icons.emoji_events,
              title: 'ICC Rankings',
              destination: IccRankingsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTile(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget destination}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
