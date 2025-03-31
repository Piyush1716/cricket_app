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
        minimumFetchInterval: const Duration(minutes: 30),
      ));

      await remoteConfig.fetchAndActivate();

      _apiKey = remoteConfig.getString("API_KEY");
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print("Error fetching API Key: $e");
    }
  }
}
