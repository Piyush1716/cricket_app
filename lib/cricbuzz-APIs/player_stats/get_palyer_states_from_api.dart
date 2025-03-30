import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class GetPalyerStatesFromApi {
  static String apiKey = dotenv.env['API_KEY'] ?? 'default_key';
  static String apiHost = 'cricbuzz-cricket.p.rapidapi.com';

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
