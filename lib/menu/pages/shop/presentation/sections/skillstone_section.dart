import 'package:flutter/material.dart';

class SkillStoneSection extends StatelessWidget {
  const SkillStoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _GridSection(title: "스킬석");
  }
}

class _GridSection extends StatelessWidget {
  final String title;

  const _GridSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(
            3, (index) => _ItemCard(title: "$title ${index + 1}")),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  const _ItemCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}