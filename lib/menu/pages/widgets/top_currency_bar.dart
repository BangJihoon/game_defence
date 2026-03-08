import 'package:flutter/material.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:provider/provider.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/energy_popup.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/gem_popup.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/coin_popup.dart';

class TopCurrencyBar extends StatelessWidget {
  const TopCurrencyBar({super.key});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        children: [
          // 0. 계정 프로필 및 랭크
          _buildUserProfile(pdm),
          
          const SizedBox(width: 12),
          const VerticalDivider(color: Colors.white10, width: 1, indent: 5, endIndent: 5),
          const SizedBox(width: 12),

          // 1. 에너지 및 타이머
          if (pdm.energyTimerText.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  pdm.energyTimerText,
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'NanumGothic'),
                ),
                const SizedBox(width: 6),
              ],
            ),
          
          _buildCurrencyItem(
            context,
            Icons.bolt,
            '${pdm.energy}/${pdm.maxEnergy}',
            Colors.yellowAccent,
            () {
              showDialog(
                context: context,
                builder: (context) => const EnergyPopup(),
              );
            },
          ),
          
          const Spacer(), // 프로필과 재화 사이 간격 확보

          // 2. 보석 (Gems)
          _buildCurrencyItem(
            context,
            Icons.diamond,
            pdm.gems.toString(),
            Colors.cyanAccent,
            () {
              showDialog(
                context: context,
                builder: (context) => const GemPopup(),
              );
            },
          ),
          
          const SizedBox(width: 8),

          // 3. 코인 (Gold)
          _buildCurrencyItem(
            context,
            Icons.monetization_on,
            _formatAmount(pdm.gold),
            Colors.amber,
            () {
              showDialog(
                context: context,
                builder: (context) => const CoinPopup(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(PlayerDataManager pdm) {
    return Row(
      children: [
        // 랭크 뱃지를 프로필 사진으로 사용
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
          ),
          child: Image.asset(_getAccountRankBadge(pdm.accountRank)),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pdm.accountId,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'NanumGothic'),
            ),
            Text(
              'Lv.${pdm.currentLevel} | ${_getRankName(pdm.accountRank)}',
              style: TextStyle(color: _getRankColor(pdm.accountRank), fontSize: 9, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  String _getAccountRankBadge(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return 'assets/badges/ranks/SLIVER.PNG';
      case CharacterRank.gold: return 'assets/badges/ranks/GOLD.PNG';
      case CharacterRank.platinum: return 'assets/badges/ranks/PLATIUM.PNG';
      case CharacterRank.diamond: return 'assets/badges/ranks/DIAMOND.PNG';
    }
  }

  String _getRankName(CharacterRank rank) {
    return rank.name.toUpperCase();
  }

  Color _getRankColor(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return const Color(0xFFE0E0E0);
      case CharacterRank.gold: return const Color(0xFFFFD700);
      case CharacterRank.platinum: return const Color(0xFF00FF7F);
      case CharacterRank.diamond: return Colors.white;
    }
  }

  Widget _buildCurrencyItem(BuildContext context, IconData icon, String value, Color color, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toString();
  }
}
