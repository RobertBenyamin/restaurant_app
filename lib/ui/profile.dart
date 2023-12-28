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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF37465D),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.email}',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ID: ${user?.uid}',
                          style: const TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: const Color(0xFF37465D),
              child: FutureBuilder<bool>(
                  future: _getScheduled(),
                  builder: (context, snapshot) {
                    return ListTile(
                      title: const Text(
                        'Scheduling Recommendations',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                color: const Color(0xFF37465D),
                padding: const EdgeInsets.only(left: 16, right: 32, top: 16, bottom: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
