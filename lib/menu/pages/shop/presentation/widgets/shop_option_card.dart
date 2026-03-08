import 'package:flutter/material.dart';

class ShopOptionCard extends StatelessWidget {
  final String amount;
  final IconData icon;
  final Color iconColor;
  final String? priceText;
  final int? gemCost;
  final bool isFree;
  final VoidCallback onTap;
  final Color bgColor;

  const ShopOptionCard({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.priceText,
    this.gemCost,
    this.isFree = false,
    this.bgColor = const Color(0xFFB89450),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 12),
    
            if (isFree)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "무료",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              )
            else if (gemCost != null)
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priceText ?? "",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              )
          ],
        ),
      ),
    );
  }
}
