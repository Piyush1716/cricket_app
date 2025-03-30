import 'dart:convert';
import 'dart:typed_data';

import 'package:cricket_app/UI%20helper/customcachemanager.dart';
import 'package:cricket_app/UI%20helper/shimmers.dart';
import 'package:cricket_app/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/player_stats/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ICCBowlers extends StatefulWidget {
  const ICCBowlers({super.key});

  @override
  State<ICCBowlers> createState() => _ICCBowlersState();
}

class _ICCBowlersState extends State<ICCBowlers> {
  List<dynamic> rankingData = [];
  bool isLoading = true;
  String errorMessage = '';

  void initState() {
    super.initState();
    get_iic_renkings();
  }

  Future<void> get_iic_renkings() async {
    try {
      final formates = ['test', 'odi', 't20'];
      for (int i = 0; i < 3; i++) {
        final url = Uri.parse(
            'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/rankings/bowlers?formatType=${formates[i]}');
        final response = await http.get(url, headers: {
          'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
          'x-rapidapi-key': dotenv.env['API_KEY'] ?? 'default_key',
        });
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          rankingData.add(jsonResponse['rank']);
        } else if (response.statusCode == 429) {
          errorMessage = 'Api Limit Exceeded : ${response.statusCode}';
          break;
        } else {
          errorMessage = 'API call Failed : ${response.statusCode}';
          break;
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error : $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
          )
        : errorMessage.isNotEmpty
            ? Center(
                child: Text(errorMessage,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              )
            : PlayerRankingScreen(rankingData: rankingData);
  }
}

class PlayerRankingScreen extends StatelessWidget {
  final List<dynamic> rankingData;
  PlayerRankingScreen({required this.rankingData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Soft background
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2,
          title: Text(
            "Player Rankings",style: TextStyle(color: Colors.white,fontSize: 18,  fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: [
              Tab(icon: Icon(Icons.sports_cricket), text: "TEST"),
              Tab(icon: Icon(Icons.emoji_events), text: "ODI"),
              Tab(icon: Icon(Icons.flash_on), text: "T20"),
            ],
          ),
        ),

        body: TabBarView(
          physics: BouncingScrollPhysics(), // Smooth scrolling
          children: [
            RankingList(rankingData[0]!),
            RankingList(rankingData[1]!),
            RankingList(rankingData[2]!),
          ],
        ),
      ),
    );
  }
}

class RankingList extends StatefulWidget {
  final List<dynamic> rankings;

  RankingList(this.rankings);

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  bool isLoadingImage = true;
  List<Uint8List?> imageBytes = [];

  void loadImage() async {
    try {
      for (int i = 0; i < widget.rankings.length; i++) {
        final url = widget.rankings[i]['faceImageId'].toString();

        FileInfo? cachedFiles = await CustomCacheManager().getFileFromCache(url);
        if (cachedFiles != null) {
          // If the image is cached, read it as bytes
          Uint8List? bytes = await cachedFiles.file.readAsBytes();
          imageBytes.add(bytes);
        }
        else {
          // If the image is not cached, fetch it from the API
          Uint8List? bytes = await ImageService.fetchImage(url);
          // and cache it for future use
          if (bytes != null) {
            await CustomCacheManager().putFile(url, bytes);
          }
          imageBytes.add(bytes);
        }
      }
      setState(() {
        isLoadingImage = false;
      });
    } catch (e) {
      setState(() {
        isLoadingImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.rankings.length,
      itemBuilder: (context, index) {
        final player = widget.rankings[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerStatsScreen(
                    playerID: player['id'], faceImageId: player['faceImageId']),
              ),
            );
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.black26,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Hero(
                tag: "player-${player['id']}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), // Circular shape
                  child: isLoadingImage
                      ? FakeProfileImageShimmer()
                      : imageBytes[index] != null 
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(imageBytes[index]!,
                              fit: BoxFit.cover),
                        )
                      : Icon(Icons.error, size: 50, color: Colors.red), // Error icon
                ),
              ),
              title: Text(
                player["name"]!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              subtitle: Text(
                "${player["country"]} - Rating: ${player["rating"]}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              trailing: Icon(Icons.star, color: Colors.amber, size: 28),
            ),
          ),
        );
      },
    );
  }
}
