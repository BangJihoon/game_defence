import 'package:flutter/material.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';
import '../widgets/shop_option_card.dart';

class CoinPopup extends StatelessWidget {
  const CoinPopup({super.key});

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
              color: const Color(0xFF7A6D4A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "코인 구매",
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
                        amount: "10만개",
                        icon: Icons.monetization_on,
                        iconColor: Colors.amber,
                        priceText: "₩3,000",
                        bgColor: const Color(0xFF6A5D3A),
                        onTap: () {
                          pdm.purchaseCoins(100000, 0); // 3300원 결제 가상 처리
                          pdm.gold += 100000;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopOptionCard(
                        amount: "50만개",
                        icon: Icons.monetization_on,
                        iconColor: Colors.amber,
                        priceText: "₩10,000",
                        bgColor: const Color(0xFF6A5D3A),
                        onTap: () {
                          pdm.gold += 500000;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 보석으로 코인 구매 옵션 추가 (편의성)
                GestureDetector(
                  onTap: () {
                    if (pdm.purchaseCoins(100000, 500)) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.monetization_on, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "10만 코인 교환",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Spacer(),
                        Icon(Icons.diamond, color: Colors.cyanAccent, size: 18),
                        SizedBox(width: 4),
                        Text("500", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
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
