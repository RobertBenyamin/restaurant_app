import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  late bool isScheduled;
  String prefsKey = '';

  @override
  void initState() {
    super.initState();
    prefsKey = '${user?.email}_scheduled';
  }

  Future<bool> _getScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefsKey) ?? false;
  }

  void _updateScheduled(value) async {
    final prefs = await SharedPreferences.getInstance();
    isScheduled = await _getScheduled();
    setState(() {
      isScheduled = value;
    });
    prefs.setBool(prefsKey, isScheduled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email: ${user?.email}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            FutureBuilder<bool>(
                future: _getScheduled(),
                builder: (context, snapshot) {
                  return ListTile(
                    title: const Text('Scheduling Recommendations'),
                    trailing: Consumer<SchedulingProvider>(
                        builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        value: snapshot.data ?? false,
                        onChanged: (value) async {
                          _updateScheduled(value);
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledRecommendation(value);
                          }
                        },
                      );
                    }),
                  );
                }),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFFFC726F),
                minimumSize: const Size(150, 50),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFF37465D),
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
