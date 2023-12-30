// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/data/api/api_services.dart';

class ReviewPage extends StatefulWidget {
  final String id;
  const ReviewPage({
    super.key,
    required this.id,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String _message = '';
  bool isError = false;
  bool _isAnonymous = false;
  final user = FirebaseAuth.instance.currentUser;
  late final TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        backgroundColor: const Color(0xFFF5F2ED),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Submit as Anonymous',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Switch(
                      value: _isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          _isAnonymous = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Review',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final url = Uri.parse('${ApiServices.baseUrl}review');
                      final body = json.encode({
                        'id': widget.id,
                        'name': _isAnonymous ? 'Anonymous' : user?.email,
                        'review': _reviewController.text,
                      });

                      var response = await http.post(url,
                          headers: {"Content-Type": "application/json"},
                          body: body);

                      if (response.statusCode == 201) {
                        Navigator.pop(context);
                      } else {
                        throw Exception(response.body);
                      }
                    } catch (e) {
                      if (e is SocketException) {
                        _message = 'No Internet Connection';
                      } else {
                        _message = 'Failed to post review';
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37465D),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
