import 'package:cricket_app/sportmonks-APIs/create_state_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerDetailPage extends StatefulWidget {
  final String playerId;
  PlayerDetailPage({required this.playerId});

  @override
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  Map<String, dynamic>? playerData;
  bool isLoading = true;

  Future<void> fetchPlayerData() async {
    String apiToken = "6Gk0W3kZr8hz5YUGa4SksP3kOu7UDMIfVy00zT3CaTYA8LwLIu3WBYChKN1y";
    String url ="https://cors-anywhere.herokuapp.com/https://cricket.sportmonks.com/api/v2.0/players/${widget.playerId}?api_token=$apiToken&include=career";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          playerData = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPlayerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player Details")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : playerData != null
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(playerData!['image_path']),
                      ),
                      SizedBox(height: 10),
                      Text(
                        playerData!['fullname'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text("Batting: ${playerData!['battingstyle']}"),
                      Text("Bowling: ${playerData!['bowlingstyle']}"),
                      Text("Position: ${playerData!['position']['name']}"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CareerStatsPage(
                                  careerData: playerData!['career']),
                            ),
                          );
                        },
                        child: Text("View Career Stats"),
                      ),
                    ],
                  ),
                )
              : Center(child: Text("Player not found")),
    );
  }
}
