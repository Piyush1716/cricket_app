import 'dart:typed_data';
import 'package:cricket_app/cricbuzz-APIs/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/news_page/news_detail_screen.dart';
import 'package:cricket_app/cricbuzz-APIs/player_search/search_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CricketNewsScreen extends StatefulWidget {
  @override
  _CricketNewsScreenState createState() => _CricketNewsScreenState();
}

class _CricketNewsScreenState extends State<CricketNewsScreen> {
  List<dynamic> newsList = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchCricketNews();
  }

  Future<void> fetchCricketNews() async {
    final url =
        Uri.parse('https://cricbuzz-cricket.p.rapidapi.com/news/v1/index');
    try {
      final response = await http.get(url, headers: {
        'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
        'x-rapidapi-key': '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8', // Replace with your API key
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          newsList = jsonResponse['storyList'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "API Call Failed: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket News'),
        ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16)))
              : ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    var story = newsList[index]['story'];
                    if (story == null) return SizedBox.shrink();
                    return NewsCard(story: story);
                  },
                ),
    );
  }
}

class NewsCard extends StatefulWidget {
  final Map<String, dynamic> story;

  NewsCard({required this.story});

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  Uint8List? imageBytes;
  bool isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    if (widget.story['coverImage'] != null &&
        widget.story['coverImage']['id'] != null) {
      String imageId = widget.story['coverImage']['id'].toString();
      Uint8List? bytes = await ImageService.fetchImage(imageId);
      setState(() {
        imageBytes = bytes;
        isLoadingImage = false;
      });
    } else {
      setState(() {
        isLoadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(story: widget.story)));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image only if available
            if (isLoadingImage)
              Center(child: CircularProgressIndicator())
            else if (imageBytes != null)
              Image.memory(imageBytes!,
                  height: 200, width: double.infinity, fit: BoxFit.cover)
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(child: Text("Image not available")),
              ),
      
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story['hline'] ?? 'No headline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.story['intro'] ?? 'No description available',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
