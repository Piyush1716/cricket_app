import 'dart:convert';
import 'dart:typed_data';

import 'package:cricket_app/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/player_stats/get_palyer_states_from_api.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlayerStatsScreen extends StatefulWidget {
  final String playerID;
  final String faceImageId;
  Uint8List? profileImage;

  PlayerStatsScreen(
      {required this.playerID, required this.faceImageId, this.profileImage}) {
    print("Player ID: $playerID");
  }

  @override
  _PlayerStatsScreenState createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen> {
  Map<String, dynamic> playerBatStats = {};
  Map<String, dynamic> playerBallStats = {};
  bool isLoading = true;
  bool isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    loadStates(widget.playerID);
    if (widget.profileImage != null) {
      print("already there.");
      isLoadingImage = false;
    } else {
      loadImage(widget.faceImageId);
    }
  }

  loadImage(playerID) async {
    widget.profileImage = await ImageService.fetchImage(playerID);
    setState(() {
      isLoadingImage = false;
    });
  }

  Future<void> loadStates(String playerID) async {
    GetPalyerStatesFromApi fetchStats = GetPalyerStatesFromApi();
    String? body1 = await fetchStats.fetchStats(playerID, "batting");
    String? body2 = await fetchStats.fetchStats(playerID, "bowling");
    if (body1 != null) {
      playerBatStats = json.decode(body1);
    } else {
      playerBatStats = {"values": [], "headers": []};
    }
    if (body2 != null) {
      playerBallStats = json.decode(body2);
    } else {
      playerBallStats = {"values": [], "headers": []};
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
            : widget.profileImage != null
                ? Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ClipOval(
                      child: Image.memory(
                        widget.profileImage!,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  )
                : Icon(Icons.account_circle, size: 40, color: Colors.white),
        title: isLoading
            ? Text('Loading...')
            : playerBatStats['appIndex'] != null
                ? Text(playerBatStats["appIndex"]['seoTitle']
                    .toString()
                    .split('-')
                    .first)
                : Text('Error'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Batting Career Summary", style: Theme.of(context).textTheme.titleLarge,),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StatsTable(data: playerBatStats)
                    ),
                    Text("Bowling Career Summary", style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StatsTable(data: playerBallStats)
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class StatsTable extends StatelessWidget {
  final Map<String, dynamic> data;

  StatsTable({required this.data});

  @override
  Widget build(BuildContext context) {
    // Extract all statistics headers (M, Inn, Runs, etc.)
    List<String> statHeaders = (data["values"] as List)
        .map((entry) => entry["values"][0].toString())
        .toList();

    // Extract formats (Test, ODI, T20, IPL)
    List<String> formats = ["Test", "ODI", "T20", "IPL"];
    List<dynamic> formatIndices =
        formats.map((format) => data["headers"].indexOf(format)).toList();

    // Create header row
    List<DataColumn> columns = [
      DataColumn(
          label: Text('Format', style: TextStyle(fontWeight: FontWeight.bold))),
      ...statHeaders.map((header) => DataColumn(
            label: Text(
              header,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )),
    ];

    // Create data rows for each format
    List<DataRow> rows = [];
    for (int i = 0; i < formats.length; i++) {
      String format = formats[i];
      int formatIndex = formatIndices[i];

      List<DataCell> cells = [
        DataCell(Text(format, style: TextStyle(fontWeight: FontWeight.bold)))
      ];

      for (int j = 0; j < statHeaders.length; j++) {
        String statValue = data["values"][j]["values"][formatIndex].toString();
        cells.add(DataCell(
          Text(statValue, textAlign: TextAlign.center),
        ));
      }

      rows.add(DataRow(cells: cells));
    }

    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 16,
      columns: columns,
      rows: rows,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      dataRowHeight: 48,
      headingRowHeight: 56,
    );
  }
}
