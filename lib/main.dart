import 'package:cricketX/UI%20helper/splash_screen.dart';
import 'package:cricketX/UI%20helper/theme.dart';
import 'package:cricketX/firebase_options.dart';
import 'package:cricketX/provider/api_key_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  // await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create : (_) => ApiKeyProvider()),
      ],
      child: CricketNewsApp(),
    )
  );
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