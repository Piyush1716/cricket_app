import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cricket_app/homepage/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize Lottie animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Slow down animation
    )..forward(); // Play animation once

    // Navigate to HomePage when animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 800), // Smooth fade effect
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
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
