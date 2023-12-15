import 'package:flutter/material.dart';
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
      ),
      home: const RestaurantListPage(),
    );
  }
}
