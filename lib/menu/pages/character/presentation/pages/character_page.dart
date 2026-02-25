import 'package:flutter/material.dart';
import '../sections/character_top_section.dart';
import '../sections/character_tab_section.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4C8),
      body: SafeArea(
        child: Column(
          children: const [
            CharacterTopSection(),
            Expanded(child: CharacterTabSection()),
          ],
        ),
      ),
    );
  }
}