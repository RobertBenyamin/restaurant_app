import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:restaurant_app/ui/home.dart';
import 'package:restaurant_app/ui/login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChangeNotifierProvider(
              create: (_) => RestaurantListProvider(apiService: ApiServices()),
              child: const HomePage(),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
