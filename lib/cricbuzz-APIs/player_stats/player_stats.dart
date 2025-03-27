import 'dart:convert';
import 'dart:typed_data';

import 'package:cricket_app/cricbuzz-APIs/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/player_stats/get_palyer_states_from_api.dart';
import 'package:flutter/material.dart';


class PlayerStatsScreen extends StatefulWidget {

  String playerID;
  String faceImageId;
  PlayerStatsScreen({required this.playerID, required this.faceImageId});

  @override
  _PlayerStatsScreenState createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, dynamic> playerStats = {};
  bool isLoading = true;
  bool isLoadingImage = true;
  Uint8List? profileImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadStates(widget.playerID);
    loadImage(widget.faceImageId);
  }

  loadImage(playerID)async{
    profileImage = await ImageService.fetchImage(playerID);
    setState(() {
      isLoadingImage = false;
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadStates(String playerID) async {
    GetPalyerStatesFromApi fetchStats = GetPalyerStatesFromApi();
    String? body = await fetchStats.fetchStats(playerID);
    if (body != null) {
      playerStats = json.decode(body!);
    } else {
      playerStats = {"values": [], "headers": []};
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isLoadingImage
      ? Center(
          child: SizedBox(
            width: 24, 
            height: 24, 
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
      : profileImage != null
          ? Padding(
              padding: EdgeInsets.all(2.0),
              child: ClipOval(
                child: Image.memory(
                  profileImage!,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
              ),
            )
          : Icon(Icons.account_circle, size: 40, color: Colors.white),
        title: isLoading 
              ? Text('Loading...') 
              : playerStats['appIndex'] != null 
              ? Text(playerStats["appIndex"]['seoTitle'].toString().split('-').first) 
              : Text('Error'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: Colors.green),
            insets: EdgeInsets.symmetric(horizontal: 20.0),
          ),
          isScrollable: true, // Allows smooth scrolling on small screens
          tabs: [
            Tab(text: 'Test'),
            Tab(text: 'ODI'),
            Tab(text: 'T20'),
            Tab(text: 'IPL'),
          ],
        ),

      ),
      body: isLoading 
      ?  Center(child: CircularProgressIndicator())
      : TabBarView(
        controller: _tabController,
        children: [
          StatsTable(data: playerStats, matchType: "Test"),
          StatsTable(data: playerStats, matchType: "ODI"),
          StatsTable(data: playerStats, matchType: "T20"),
          StatsTable(data: playerStats, matchType: "IPL"),
        ],
      ),
    );
  }
}

class StatsTable extends StatelessWidget {
  final Map<String, dynamic> data;
  final String matchType;

  StatsTable({required this.data, required this.matchType});

  @override
  Widget build(BuildContext context) {
    List<List<String>> tableData = (data["values"] as List)
        .map((entry) => (entry["values"] as List).cast<String>())
        .toList();

    int columnIndex = data["headers"].indexOf(matchType);

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tableData.length,
      itemBuilder: (context, index) {
        final row = tableData[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.sports_cricket, color: Colors.green),
            title: Text(
              row[0], // Row Header (e.g., Matches, Runs, etc.)
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              row[columnIndex], // Corresponding stat
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
          ),
        );
      },
    );
  }
}
