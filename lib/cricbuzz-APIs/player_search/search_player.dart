import 'dart:convert';
import 'dart:typed_data';
import 'package:cricket_app/UI%20helper/shimmers.dart';
import 'package:cricket_app/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/player_stats/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchPlayer extends StatefulWidget {
  final String player_name;
  const SearchPlayer({super.key, required this.player_name});

  @override
  State<SearchPlayer> createState() => _SearchPlayerState();
}

class _SearchPlayerState extends State<SearchPlayer> {
  List<dynamic> playersList = [];
  bool isLoading = true;
  bool isLoadingImage = true;
  String errorMessage = '';
  List<Uint8List?> playerImages = [];

  @override
  void initState() {
    super.initState();
    searchPlayer(widget.player_name);
  }

  Future<void> fetchPlayerImage(List<dynamic>? playersList) async {
    try {
      for (int i = 0; i < playersList!.length; i++) {
        String img = playersList[i]['faceImageId'].toString();
        Uint8List? image = await ImageService.fetchImage(img.toString());
        playerImages.add(image);
      }
      setState(() {
        isLoadingImage = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  Future<void> searchPlayer(String player_name) async {
    final url = Uri.parse(
        'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/player/search?plrN=$player_name');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
          'x-rapidapi-key': dotenv.env['API_KEY'] ?? 'default_key',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          playersList = jsonResponse['player'] ?? [];
          if (playersList.isNotEmpty) {
            fetchPlayerImage(playersList);
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'API call Failed : ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error : $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Results for '${widget.player_name}'",
            style: theme.textTheme.titleLarge),
      ),
      body: _buildPlayersList(),
    );
  }

  Widget _buildPlayersList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return _buildErrorMessage();
    } else if (playersList.isEmpty) {
      return _buildNoPlayersFound();
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: playersList.length,
      itemBuilder: (context, index) {
        return _buildPlayerCard(playersList[index],
                isLoadingImage ? null : playerImages[index])
            .animate()
            .fade(duration: 500.ms)
            .slideX(begin: -0.2, end: 0, duration: 500.ms);
      },
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ).animate().fade(duration: 500.ms);
  }

  Widget _buildNoPlayersFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/bat.json', height: 200),
          const SizedBox(height: 20),
          Text(
            "No players found.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ).animate().fade(duration: 500.ms),
    );
  }

  Widget _buildPlayerCard(player, Uint8List? image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerStatsScreen(
                playerID: player['id'].toString(), faceImageId: player['faceImageId'].toString()),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // Player Image with Hero Animation
              Hero(
                tag: player['id'],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: isLoadingImage
                      ? FakeProfileImageShimmer()
                      : image != null
                          ? Image.memory(
                              image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.error, size: 70, color: Colors.red),
                ),
              ),
              const SizedBox(width: 14),

              // Player Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player['name'] ?? "Unknown",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Team: ${player['teamName'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      "Role: ${player['role'] ?? 'Unknown'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      "Country: ${player['country'] ?? 'Unknown'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      "DOB: ${player['dob'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Arrow Icon
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 20)
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
