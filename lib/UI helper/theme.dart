import 'package:flutter/material.dart';

final ThemeData cricketTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 255, 2, 2), // Main red color
  scaffoldBackgroundColor: Color(0xFFFAFAFA), // Soft white background
  appBarTheme: AppBarTheme(
    color: Color.fromARGB(255, 243, 2, 2), // Red AppBar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
        color: Color.fromARGB(255, 248, 248, 248), fontWeight: FontWeight.bold, fontSize: 22),
    titleLarge: TextStyle(
        color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
    labelLarge: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold, fontSize: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFD32F2F), // Red button
      foregroundColor: Colors.white, // White text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.2),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
