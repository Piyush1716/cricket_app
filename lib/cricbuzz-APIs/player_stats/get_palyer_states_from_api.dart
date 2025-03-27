import 'package:http/http.dart' as http;
import 'dart:typed_data';
class GetPalyerStatesFromApi {
  static const String apiKey = '9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8';
  static const String apiHost = 'cricbuzz-cricket.p.rapidapi.com';

  Future<String?> fetchStats(String playerID) async{
    final url = Uri.parse(
      'https://cricbuzz-cricket.p.rapidapi.com/stats/v1/player/${playerID}/batting'
    );
    try{
      final respnce = await http.get(
        url,
        headers: {
          'x-rapidapi-host': apiHost,
          'x-rapidapi-key': apiKey,
        }
      );
      if(respnce.statusCode == 200){
        return respnce.body;
      }
      else{
        print('Error loading : ${respnce.statusCode}');
        return null;
      }

    }catch(e){
      print('Error fetching data: $e');
      return null;
    }
  }
}

      // API kes.
// 9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8
// 4c28db685amsh0a6bc2cf6d81cd0p12e0fajsn6e3ced662540
// fae91668c1msh0a972110c87d672p13554cjsn7e2bbc4e70df