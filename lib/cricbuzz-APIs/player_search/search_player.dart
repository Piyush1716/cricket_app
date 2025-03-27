import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPlayer extends StatefulWidget {
  final String player_name;
  const SearchPlayer({super.key, required this.player_name});

  @override
  State<SearchPlayer> createState() => _SearchPlayerState();
}

class _SearchPlayerState extends State<SearchPlayer> {
  List<dynamic> playersList= [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState(){
    super.initState();
    searchPlayer(widget.player_name);
  }

  Future<void> searchPlayer(String player_name) async {
    print(player_name);
    final url = 
      Uri.parse('https://cricbuzz-cricket.p.rapidapi.com/stats/v1/player/search?plrN=${player_name}');
      try{
        final response = await http.get(
          url, 
          headers: {
            'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
            'x-rapidapi-key': '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8',
          }
        );
        if(response.statusCode == 200){
          var jsonResponse = json.decode(response.body);
          setState(() {
            playersList = jsonResponse['player'];
            isLoading = false;
          });
        }
        else{
          setState(() {
            errorMessage = 'API call Failed : ${response.statusCode}';
            isLoading = false;
          });
        }
      }catch(e){
        setState(() {
          errorMessage = "Error : $e";
          isLoading = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Serach for ${widget.player_name}"),),
      body: Players()
    );
  }
  Widget Players(){
    return isLoading
          ? Center(child: CircularProgressIndicator(),)
          : errorMessage.isNotEmpty
              ? Center(
                child: Text(errorMessage),
              )
              : ListView.builder(
                itemCount: playersList.length,
                itemBuilder: (context, index){
                  return PlayerDetail(playersList[index]);
                });
  }
  Widget PlayerDetail(player){
    return ListTile(
      leading: Icon(Icons.sports_cricket_outlined),
      title: Text(player['name']),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("ID : ${player['id']}"),
          Text("Team : ${player['teamName']}"),
          Text("DOB : ${player['dob']}"),
        ],
      ),

    );
  }
}