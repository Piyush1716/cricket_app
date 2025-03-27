import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String responseText = "Press the button to fetch data";

  Future<void> fetchPlayerData() async {
    String apiToken = "6Gk0W3kZr8hz5YUGa4SksP3kOu7UDMIfVy00zT3CaTYA8LwLIu3WBYChKN1y";
    // String proxyUrl = "http://127.0.0.1:5000/proxy?url=";
    // String apiUrl =
    //     "https://cricket.sportmonks.com/api/v2.0/players/2?api_token=$apiToken&include=career";
    String url =
        "https://cors-anywhere.herokuapp.com/https://cricket.sportmonks.com/api/v2.0/players/278?api_token=$apiToken&include=career";

    try {
      
      final response = await http.get(Uri.parse(url));

      setState(() {
        responseText =
            "Status Code: ${response.statusCode}\n\nResponse: ${response.body}";
      });
    } catch (e) {
      setState(() {
        print(e);
        responseText = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Test Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: fetchPlayerData,
              child: Text("Fetch Data"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(responseText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
