import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? searchQuery;

  const SearchField(
      {super.key, required this.searchController, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40.0,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search',
            labelStyle: const TextStyle(
              color: Color(0xFF37465D),
            ),
            filled: true,
            fillColor: const Color(0xFF000000).withOpacity(0.07),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          onChanged: searchQuery,
        ),
      ),
    );
  }
}