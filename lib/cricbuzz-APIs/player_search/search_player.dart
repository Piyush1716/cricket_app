import 'dart:convert';
import 'dart:typed_data';
import 'package:cricket_app/UI%20helper/shimmers.dart';
import 'package:cricket_app/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:flutter/material.dart';
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
    print(playersList);
    try{
      for(int i=0; i<playersList!.length; i++){
        String img = playersList[i]['faceImageId'].toString();
        Uint8List? image = await ImageService.fetchImage(img.toString());
        playerImages.add(image);
      }
      setState(() {
        isLoadingImage = false;
      });
    }catch(e){
        setState(() {
          errorMessage = "Error : $e";
          isLoading = false;
          print(e);
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
          if(playersList.isNotEmpty){
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results for '${widget.player_name}'"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: _buildPlayersList(),
    );
  }

  Widget _buildPlayersList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(
              fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    } else if (playersList.isEmpty) {
      return Center(
        child: Text(
          "No players found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: playersList.length,
      itemBuilder: (context, index) {
        return _buildPlayerCard(playersList[index], isLoadingImage ? null : playerImages[index]);
      },
    );
  }

  Widget _buildPlayerCard(player, Uint8List? image) {
    return GestureDetector(
      onTap: () {
        // Handle player card tap (e.g., navigate to player details)
        print("Tapped on ${player['name']}");
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Player Image
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: isLoadingImage
                    ? FakeProfileImageShimmer()
                    : image != null
                        ? Image.memory(
                            image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.error, size: 60, color: Colors.red),
              ),
              const SizedBox(width: 12),

              // Player Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player['name'] ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Team: ${player['teamName'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      "ID: ${player['id']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      "DOB: ${player['dob'] ?? 'N/A'}", // Added DOB field
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}