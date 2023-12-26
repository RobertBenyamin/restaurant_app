import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/list.dart';
import 'package:restaurant_app/ui/favorite.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final screens = [
    const RestaurantListPage(),
    const RestaurantFavoritePage(),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF37465D),
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
