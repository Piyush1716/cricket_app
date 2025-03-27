import 'dart:typed_data';

import 'package:cricket_app/cricbuzz-APIs/Image_service.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  final Map<String, dynamic> story;

  NewsDetailScreen({required this.story});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

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
    return Scaffold(
      appBar: AppBar(title: Text(widget.story['hline'] ?? 'News Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image if available
            if(isLoadingImage)
              Center(child: CircularProgressIndicator(),)
            else if(imageBytes!=null)
              Image.memory(imageBytes!)
            else 
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(child: Text("Image not available")),
              ),
            SizedBox(height: 10),

            // News Headline
            Text(
              widget.story['hline'] ?? 'No headline available',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // News Description (intro)
            Text(
              widget.story['intro'] ?? 'No description available',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 15),

            // Additional Content (optional fields)
            if (widget.story['context'] != null)
              Text(
                "Context: ${widget.story['context']}",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),

            if (widget.story['source'] != null)
              Text(
                "Source: ${widget.story['source']}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

            if (widget.story['publishedDate'] != null)
              Text(
                "Published Date: ${widget.story['publishedDate']}",
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
          ],
        ),
      ),
    );
  }
}
