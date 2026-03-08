import 'package:flutter/material.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';
import '../widgets/shop_option_card.dart';

class GemPopup extends StatelessWidget {
  const GemPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5D7A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "보석 구매",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ShopOptionCard(
                        amount: "500개",
                        icon: Icons.diamond,
                        iconColor: Colors.cyanAccent,
                        priceText: "₩3,000",
                        bgColor: const Color(0xFF3A4D6A),
                        onTap: () {
                          pdm.purchaseGems(500);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopOptionCard(
                        amount: "3,000개",
                        icon: Icons.diamond,
                        iconColor: Colors.cyanAccent,
                        priceText: "₩10,000",
                        bgColor: const Color(0xFF3A4D6A),
                        onTap: () {
                          pdm.purchaseGems(3000);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "구독하고 매일 보석을 받으세요!",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // 닫기 버튼
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
