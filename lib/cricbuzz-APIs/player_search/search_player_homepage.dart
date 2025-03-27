import 'package:cricket_app/cricbuzz-APIs/player_search/search_player.dart';
import 'package:flutter/material.dart';

class SearchPlayerHomepage extends StatelessWidget {

  TextEditingController _playerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _playerName,
            decoration: InputDecoration(
              border: OutlineInputBorder()
            ),
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPlayer(player_name: "rohit",)));
            },
            child: Text('Search')
          ),
        ],
      ),
    );
  }
}