import 'package:flutter/material.dart';

class EnergyOptionCard extends StatelessWidget {
  final int amount;
  final bool isFree;
  final int? gemCost;
  final VoidCallback onTap;

  const EnergyOptionCard({
    super.key,
    required this.amount,
    required this.onTap,
    this.isFree = false,
    this.gemCost,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFB89450),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              amount.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Icon(Icons.flash_on, size: 40, color: Colors.yellow),
            const SizedBox(height: 12),
    
            if (isFree)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "광고",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.diamond, size: 14, color: Colors.cyanAccent),
                    const SizedBox(width: 4),
                    Text(
                      gemCost.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
