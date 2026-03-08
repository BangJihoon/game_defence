import 'package:flutter/material.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';
import 'energy_option_card.dart';

class EnergyPopup extends StatelessWidget {
  const EnergyPopup({super.key});

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
              color: const Color(0xFF6D748A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "에너지 충전",
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
                      child: EnergyOptionCard(
                        amount: 5,
                        isFree: true,
                        onTap: () {
                          pdm.claimEnergyByAd();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EnergyOptionCard(
                        amount: 25,
                        gemCost: 500,
                        onTap: () {
                          if (pdm.purchaseEnergy()) {
                            Navigator.pop(context);
                          } else {
                            // 보석 부족 등 처리
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    // 유료 결제 로직 (구현 생략)
                    pdm.energy += 50;
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "에너지 x 50",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "일일 구매 제한 (${pdm.energyPurchaseCountToday}/3)",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "₩3,300",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
