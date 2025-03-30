import 'dart:typed_data';
import 'package:cricket_app/UI%20helper/shimmers.dart';
import 'package:cricket_app/cricbuzz-APIs/Image_services/Image_service.dart';
import 'package:cricket_app/cricbuzz-APIs/news_page/news_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  bool isLoadingImage = true;
  List<Uint8List?> imageBytesList = [];
  @override
  void initState() {
    super.initState();
    fetchCricketNews();
  }
  Future<void> loadImage(List<dynamic> storyList) async {
    try{
      for(int i=0; i<storyList.length; i++){
        if (storyList[i]['story']['coverImage'] != null &&
        storyList[i]['story']['coverImage']['id'] != null){
          String imageId = storyList[i]['story']['coverImage']['id'].toString();
          try{
            Uint8List? bytes = await ImageService.fetchImage(imageId);
            imageBytesList.add(bytes);
            print("image added successfully: $i");
          }catch(e){
            imageBytesList.add(null);
          }
        }
      }
      setState(() {
        isLoadingImage = false;
        print("all images loaded successfully");
      });
    }catch(e){
      setState(() {
        isLoadingImage = false;
        print("error: $e");
        errorMessage = "Error";
      });
    }
  }
  Future<void> fetchCricketNews() async {
    final url = Uri.parse('https://cricbuzz-cricket.p.rapidapi.com/news/v1/index');
    try {
      final response = await http.get(url, headers: {
        'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
        'x-rapidapi-key': dotenv.env['API_KEY'] ?? 'default_key',
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          newsList = jsonResponse['storyList'] ?? [];
          newsList = newsList.where((story) => story['story'] != null).toList(); // Filter out stories with null 'story' because there is some ads.
          isLoading = false;
          loadImage(newsList);
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
        title: Text('Cricket News', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    var story = newsList[index]['story'];
                    if (story == null) return SizedBox.shrink();
                    return NewsCard(story: story, isLoadingImage : isLoadingImage,  imageBytes: isLoadingImage ? null : imageBytesList[index]);
                  },
                ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> story;
  final Uint8List? imageBytes;
  final bool isLoadingImage;
  NewsCard({required this.story ,required this.isLoadingImage, required this.imageBytes});

  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(story: story, imageBytes: imageBytes),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: story['hline'] ?? 'news_image',
              child: isLoadingImage
                  ? FakeLoader(height: 200, width: double.infinity,)
                  : imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.memory(imageBytes!, height: 200, width: double.infinity, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Center(child: Text("Image not available", style: TextStyle(color: Colors.black54))),
                        ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['hline'] ?? 'No headline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    story['intro'] ?? 'No description available',
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
