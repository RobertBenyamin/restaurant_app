import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/widgets/custom_dialog.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
        automaticallyImplyLeading: false,
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
              child: Row(children: [
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ID: ${user?.uid}',
                        style:
                            const TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              color: const Color(0xFF37465D),
              child: Consumer<PreferencesProvider>(
                  builder: (context, provider, child) {
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
                      value: provider.isDailyRestaurantActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.scheduledRecommendation(value);
                          provider.enableDailyRestaurant(value);
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
                  padding: const EdgeInsets.only(
                      left: 16, right: 32, top: 16, bottom: 16),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
