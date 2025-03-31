import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageService {
  static String apiHost = 'cricbuzz-cricket.p.rapidapi.com';

  // Fetch image bytes from API
  static Future<Uint8List?> fetchImage(String imageId, {String apiKey=""}) async {
    final url = Uri.parse(
        'https://cricbuzz-cricket.p.rapidapi.com/img/v1/i1/c$imageId/i.jpg?p=de');

    try {
      final response = await http.get(url, headers: {
        'x-rapidapi-host': apiHost,
        'x-rapidapi-key': apiKey.toString(),
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
