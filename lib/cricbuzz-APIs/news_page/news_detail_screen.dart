import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cricket_app/UI%20helper/shimmers.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> story;
  final Uint8List? imageBytes;

  NewsDetailScreen({required this.story, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story['hline'] ?? 'News Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Animation for Smooth Image Transition
            Hero(
              tag: story['hline'] ?? 'news_image',
              child: Stack(
                children: [
                  imageBytes == null
                      ? FakeLoader(height: 250, width: double.infinity)
                      : ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.memory(
                            imageBytes!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ).animate().fade(duration: 600.ms),
                        ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.bookmark_border,
                          color: Colors.white, size: 30),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Headline
                  Text(
                    story['hline'] ?? 'No headline available',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ).animate().fade(duration: 800.ms).slideX(),

                  SizedBox(height: 10),
                  Divider(color: Colors.grey[400]),
                  SizedBox(height: 10),

                  // News Description
                  Text(
                    story['intro'] ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ).animate().fade(duration: 1000.ms).slideY(),

                  SizedBox(height: 15),

                  // Additional Information with Icons
                  if (story['context'] != null)
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blueGrey, size: 20),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "${story['context']}",
                            style: TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ).animate().fade(duration: 1200.ms).slideY(),

                  if (story['source'] != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.public, color: Colors.green, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "Source: ${story['source']}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ).animate().fade(duration: 1400.ms).slideY(),
                    ),

                  if (story['publishedDate'] != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.red, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "Published Date: ${story['publishedDate']}",
                            style:
                                TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ],
                      ).animate().fade(duration: 1600.ms).slideY(),
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
