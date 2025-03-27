import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageService {
  static const String apiKey = '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8';
  static const String apiHost = 'cricbuzz-cricket.p.rapidapi.com';

  // Fetch image bytes from API
  static Future<Uint8List?> fetchImage(String imageId) async {
    final url = Uri.parse(
        'https://cricbuzz-cricket.p.rapidapi.com/img/v1/i1/c$imageId/i.jpg');

    try {
      final response = await http.get(url, headers: {
        'x-rapidapi-host': apiHost,
        'x-rapidapi-key': apiKey,
      });

      if (response.statusCode == 200) {
        return response.bodyBytes; // Returns image data as bytes
      } else {
        print('Error loading image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}
