import 'package:flutter/material.dart';

class GoldSection extends StatelessWidget {
  const GoldSection({super.key});

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
            3, (index) => _GoldCard(amount: (index + 1) * 10000)),
      ),
    );
  }
}

class _GoldCard extends StatelessWidget {
  final int amount;

  const _GoldCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          "$amount G",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}