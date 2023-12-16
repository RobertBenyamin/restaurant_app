import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/ui/restaurant_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF37465D)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F2ED),
        fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
      ),
      home: const RestaurantListPage(),
    );
  }
}
