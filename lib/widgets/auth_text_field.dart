// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  AuthTextField({
    Key? key,
    required this.textController,
    required this.obscureText,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController textController;
  bool? obscureText;
  final String hintText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}


class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF37465D).withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF37465D)),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        fillColor: const Color(0xFFF5F2ED),
        filled: true,
        suffixIcon: widget.obscureText != null ? IconButton(
          onPressed: () {
            setState(() {
              widget.obscureText = !widget.obscureText!;
            });
          },
          icon: Icon(
            widget.obscureText! ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF37465D),
          ),
        ) : null,
      ),
    );
  }
}
