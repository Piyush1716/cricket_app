import 'package:cricket_app/cricbuzz-APIs/ICC%20_rankings/icc_cricket_rankings.dart';
import 'package:cricket_app/cricbuzz-APIs/player_search/search_player_homepage.dart';
import 'package:flutter/material.dart';
// https://rapidapi.com/cricketapilive/api/cricbuzz-cricket/playground/apiendpoint_1c2ebd9c-e2a7-45fd-8002-10181f6771f4
void main() {
  runApp(CricketNewsApp());
}

class CricketNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IccCricketRankings(),
    );
  }
}
