import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final String name;

  const CharacterCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 40),
          const SizedBox(height: 8),
          Text(name),
        ],
      ),
    );
  }
}