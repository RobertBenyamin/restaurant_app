import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/list.dart';
import 'package:restaurant_app/ui/detail.dart';
import 'package:restaurant_app/ui/profile.dart';
import 'package:restaurant_app/ui/favorite.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  final screens = [
    const RestaurantListPage(),
    const RestaurantFavoritePage(),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: const ProfilePage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

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
