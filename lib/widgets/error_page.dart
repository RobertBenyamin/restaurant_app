import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.message
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFFC726F),
            ),
          ),
        ),
      ),
    );
  }
}
