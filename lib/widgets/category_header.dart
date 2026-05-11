import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  final String category;
  const CategoryHeader({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00ACC1), // Teal
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}