import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: ChangeNotifierProvider(
        create: (_) => RestaurantListProvider(apiService: ApiServices()),
        child: const HomePage(),
      ),
    );
  }
}
