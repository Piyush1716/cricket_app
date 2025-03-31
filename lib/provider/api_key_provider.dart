import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiKeyProvider with ChangeNotifier {
  String _apiKey = "";
  bool _isLoaded = false;

  String get apiKey => _apiKey;
  bool get isLoaded => _isLoaded;

  Future<void> fetchApiKey() async {
    print("Fetching API Key from Remote Config...");
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval:
            const Duration(minutes: 10), // Avoid frequent fetches
      ));

      await remoteConfig.fetchAndActivate();

      String newApiKey = remoteConfig.getString("API_KEY");

      // **Only update and notify if API Key has changed**
      if (newApiKey.isNotEmpty && newApiKey != _apiKey) {
        print("API Key updated: $newApiKey");
        _apiKey = newApiKey;
        _isLoaded = true;
        notifyListeners();
      } else {
        print("API Key remains unchanged.");
      }
    } catch (e) {
      print("Error fetching API Key: $e");
    }
  }
}
