import 'dart:convert';
import 'dart:typed_data';

import 'package:cricketX/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:cricketX/cricbuzz-APIs/player_stats/get_palyer_states_from_api.dart';
import 'package:cricketX/provider/api_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    final apiKeyProvider = Provider.of<ApiKeyProvider>(context, listen: false);
    if (!apiKeyProvider.isLoaded) {
      setState(() {
        isLoadingImage = false;
      });
      return;
    }
    widget.profileImage =
        await ImageService.fetchImage(playerID, apiKey: apiKeyProvider.apiKey);
    setState(() {
      isLoadingImage = false;
    });
  }

  Future<void> loadStates(String playerID) async {
    final apiKeyProvider = Provider.of<ApiKeyProvider>(context, listen: false);
    if (!apiKeyProvider.isLoaded) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    GetPalyerStatesFromApi fetchStats = GetPalyerStatesFromApi();
    String? body1 =
        await fetchStats.fetchStats(playerID, "batting", apiKeyProvider.apiKey);
    String? body2 =
        await fetchStats.fetchStats(playerID, "bowling", apiKeyProvider.apiKey);
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
        elevation: 4,
        backgroundColor: Colors.deepPurple, // Elegant color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.5),
                highlightColor: Colors.white.withOpacity(0.8),
                child: Container(
                  height: 20,
                  width: 100,
                  color: Colors.white,
                ),
              )
            : Text(
                playerBatStats["appIndex"]?['seoTitle']
                        ?.toString()
                        .split('-')
                        .first ??
                    "Player Stats",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: isLoadingImage
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : widget.profileImage != null
                    ? ClipOval(
                        child: Image.memory(
                          widget.profileImage!,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child:
                            Icon(Icons.person, size: 28, color: Colors.white),
                      ),
          ),
        ],
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
                    Text(
                      "Batting Career Summary",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StatsTable(data: playerBatStats)),
                    Text(
                      "Bowling Career Summary",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StatsTable(data: playerBallStats)),
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
