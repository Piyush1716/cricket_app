import 'package:cricket_app/UI%20helper/splash_screen.dart';
import 'package:cricket_app/UI%20helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// https://rapidapi.com/cricketapilive/api/cricbuzz-cricket/playground/apiendpoint_1c2ebd9c-e2a7-45fd-8002-10181f6771f4
Future<void> main() async {
  await dotenv.load();
  runApp(CricketNewsApp());
}

class CricketNewsApp extends StatelessWidget {
  const CricketNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: cricketTheme,
      home: SplashScreen(),
    );
  }
}


      // API kes.
// 9a2ebd60e4msh1c91eedcc28797fp1a197bjsne5ea8f72b7e8
// 4c28db685amsh0a6bc2cf6d81cd0p12e0fajsn6e3ced662540
// fae91668c1msh0a972110c87d672p13554cjsn7e2bbc4e70df