import 'dart:convert';
import 'dart:typed_data';

import 'package:cricket_app/cricbuzz-APIs/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/player_stats/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 

class ICCBatsmans extends StatefulWidget {
  const ICCBatsmans({super.key});

  @override
  State<ICCBatsmans> createState() => _ICCBatsmansState();
}

class _ICCBatsmansState extends State<ICCBatsmans> {
  List<dynamic> rankingData = [];
  bool isLoading = true;
  String errorMessage = '';

  void initState(){
    super.initState();
    get_iic_renkings();
  }
  Future<void> get_iic_renkings() async {
      try{
        final formates = ['test','odi','t20'];
        for(int i=0; i<3; i++){
          final url = Uri.parse(
            'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/rankings/batsmen?formatType=${formates[i]}');
          final response = await http.get(url, headers: {
            'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
            'x-rapidapi-key':
                '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8',
          });
          if (response.statusCode == 200) {
            var jsonResponse = json.decode(response.body);
            rankingData.add(jsonResponse['rank']);
          } else {
            errorMessage = 'API call Failed : ${response.statusCode}';
            
            break;
          }
        }
        setState(() {
          isLoading = false;
        });
      }catch(e){
        setState(() {
          errorMessage = "Error : $e";
          isLoading = false;
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
          ? Center(child: CircularProgressIndicator(),)
          : errorMessage.isNotEmpty
              ? Center(
                child: Text(errorMessage),
              )
              : PlayerRankingScreen(rankingData: rankingData);
  }
}

class PlayerRankingScreen extends StatelessWidget {
  List<dynamic> rankingData = [];
  PlayerRankingScreen({required this.rankingData});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[200], // Light background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Text("Player Rankings",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background for TabBar
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.green, // Selected tab background
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(icon: Icon(Icons.sports_cricket), text: "TEST"),
                  Tab(icon: Icon(Icons.emoji_events), text: "ODI"),
                  Tab(icon: Icon(Icons.flash_on), text: "T20"),
                ],
              ),
            ),
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
  List<Uint8List?> imageBytes =[];
  
   void loadImage() async {
    try{
      for(int i=0; i<widget.rankings.length; i++){
        final url = widget.rankings[i]['faceImageId'].toString();
        Uint8List? bytes = await ImageService.fetchImage(url);
        imageBytes.add(bytes);
      }
      setState(() {
        isLoadingImage = false;
      });
    }catch(e){
      setState(() {
        isLoadingImage = false;
      });
    }
  }
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
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayerStatsScreen(playerID: player['id'], faceImageId:player['faceImageId'])));
          },
          child: Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25), // Circular shape
                child: isLoadingImage 
                      ? Icon(Icons.person)
                      : Image.memory(imageBytes[index]!),
              ),
              title: Text(player["name"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text("${player["country"]} - Rating: ${player["rating"] } - Id: ${player["id"]}",
                  style: TextStyle(fontSize: 14)),
              trailing: Icon(Icons.star, color: Colors.amber), // Rating icon
            ),
          ),
        );
      },
    );
  }
}
