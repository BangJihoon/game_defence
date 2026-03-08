import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class TempleDetailPopup extends StatelessWidget {
  final Temple temple;

  const TempleDetailPopup({super.key, required this.temple});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    final isActive = pdm.activeTempleId == temple.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 배경 블러
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 500,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.amberAccent.withOpacity(0.5), width: 2),
              ),
              child: Column(
                children: [
                  // 상단 이미지 영역
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage(temple.imagePath),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [const Color(0xFF1A1A2E), Colors.transparent],
                        ),
                      ),
                    ),
                  ),

                  // 정보 영역
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(temple.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          // 진영 보너스 안내 태그
                          _buildFactionTag(temple.type),
                          const SizedBox(height: 10),
                          Text(temple.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 15),
                          
                          // 현재 레벨 및 보너스 수치
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoItem('현재 레벨', 'Lv.${temple.level}'),
                              _buildInfoItem('공격력 보너스', '+${(temple.currentBonus * 100).toStringAsFixed(1)}%'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoItem('적용 대상', _getTargetFactionName(temple.type), isNext: true),
                        ],
                      ),
                    ),
                  ),

                  // 하단 버튼들
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (pdm.gold >= temple.upgradeGoldCost && pdm.gems >= temple.upgradeGemCost)
                              ? () => pdm.upgradeTemple(temple.id)
                              : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('제단 강화', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('${temple.upgradeGoldCost} Gold 소모', style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isActive ? null : () {
                              pdm.setActiveTemple(temple.id);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade800,
                              minimumSize: const Size(0, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(isActive ? '현재 제단' : '제단 교체'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isNext = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: TextStyle(color: isNext ? Colors.amberAccent : Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFactionTag(TempleType type) {
    String factionName = _getTargetFactionName(type);
    Color factionColor = _getFactionColor(type);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: factionColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: factionColor.withOpacity(0.5)),
      ),
      child: Text(
        '$factionName 캐릭터 강화',
        style: TextStyle(color: factionColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getTargetFactionName(TempleType type) {
    switch (type) {
      case TempleType.hero: return '고대 (Ancient)';
      case TempleType.light: return '천사 (Angel)';
      case TempleType.darkness: return '악마 (Demon)';
    }
  }

  Color _getFactionColor(TempleType type) {
    switch (type) {
      case TempleType.hero: return Colors.purpleAccent;
      case TempleType.light: return Colors.cyanAccent;
      case TempleType.darkness: return Colors.redAccent;
    }
  }
}
