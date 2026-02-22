import 'package:flutter/material.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF3C2F45),
      child: Column(
        children: [
          const Text(
            "SHOP",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Currency(icon: Icons.flash_on, value: "19/50"),
              _Currency(icon: Icons.diamond, value: "28"),
              _Currency(icon: Icons.monetization_on, value: "759986"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Currency extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Currency({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.yellow),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}