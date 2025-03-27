import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class CricketNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try{
      final url = Uri.parse('https://cricbuzz-cricket.p.rapidapi.com/news/v1/index');
      final response = await http.get(url, headers: {
        'x-rapidapi-host': 'cricbuzz-cricket.p.rapidapi.com',
        'x-rapidapi-key': '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8', // Replace with your API key
      });
      if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            newsList = data['storyList']
                .where((item) => item.containsKey('story'))
                .map((item) => item['story'])
                .toList();
          });
        } else {
          print('Failed to load news');
        }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cricket News')),
      body: newsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NewsCard(news: news);
              },
            ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final dynamic news;
  NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          news['coverImage'] != null
              ? CachedNetworkImage(
                  imageUrl:
                      'https://cricbuzz-cricket.p.rapidapi.com/img/v1/i1/c${news['coverImage']['id']}/i.jpg',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news['hline'] ?? 'No Title',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(news['intro'] ?? 'No Description',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 5),
                Text(news['context'] ?? 'General',
                    style: TextStyle(fontSize: 12, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
