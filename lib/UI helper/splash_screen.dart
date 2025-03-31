import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:cricket_app/homepage/homepage.dart';
import 'package:cricket_app/provider/api_key_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _apiKeyLoaded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _apiKeyLoaded) {
        _navigateToHome();
      }
    });

    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKeyProvider = Provider.of<ApiKeyProvider>(context, listen: false);
    await apiKeyProvider.fetchApiKey();
    setState(() {
      _apiKeyLoaded = true;
    });
    if (_controller.status == AnimationStatus.completed) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_animation.json',
          width: 400,
          height: 400,
          controller: _controller,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
