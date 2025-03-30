import 'package:flutter/material.dart';
import 'package:cricket_app/cricbuzz-APIs/player_search/search_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class SearchPlayerHomepage extends StatefulWidget {
  @override
  _SearchPlayerHomepageState createState() => _SearchPlayerHomepageState();
}

class _SearchPlayerHomepageState extends State<SearchPlayerHomepage> {
  final TextEditingController _playerName = TextEditingController();
  List<String> recentSearches = [];
  List<dynamic> trendingPlayers = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingPlayers();
    loadRecentSearches();
  }

  Future<void> fetchTrendingPlayers() async {
    final url = Uri.parse('https://cricbuzz-cricket.p.rapidapi.com/stats/v1/player/trending');
    try {
      final response = await http.get(url, headers: {
        'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
        'x-rapidapi-key': dotenv.env['API_KEY'] ?? 'default_key',
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          trendingPlayers = jsonResponse['player'] ?? [];
        });
      }
    } catch (e) {
      print("Error fetching trending players: $e");
    }
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> saveSearch(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(playerName)) {
      recentSearches.insert(0, playerName);
      if (recentSearches.length > 5) recentSearches.removeLast();
      await prefs.setStringList('recentSearches', recentSearches);
    }
  }

  void searchPlayer(BuildContext context, String playerName) {
    if (playerName.isNotEmpty) {
      saveSearch(playerName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPlayer(playerName: playerName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Player", style: theme.textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Lottie.asset('assets/animations/cricket.json', height: 150),
              const SizedBox(height: 20),
              TextField(
                controller: _playerName,
                decoration: InputDecoration(
                  hintText: "Enter Player Name",
                  prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0, duration: 600.ms),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => searchPlayer(context, _playerName.text),
                child: Text("Search", style: theme.textTheme.labelLarge),
              ),
              const SizedBox(height: 20),
              if (recentSearches.isNotEmpty) ...[
                Text("Recent Searches", style: theme.textTheme.titleLarge),
                Wrap(
                  spacing: 10,
                  children: recentSearches.map((player) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(
                      label: Text(player),
                      backgroundColor: theme.primaryColor.withOpacity(0.8),
                      onDeleted: () {
                        setState(() => recentSearches.remove(player));
                        saveSearch(player);
                      },
                    ),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
              if (trendingPlayers.isNotEmpty) ...[
                Text("Trending Players", style: theme.textTheme.titleLarge),
                Wrap(
                  spacing: 10,
                  children: trendingPlayers.map((player) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor.withOpacity(0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => searchPlayer(context, player['name']),
                      child: Text(player['name'], style: theme.textTheme.bodyLarge),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
