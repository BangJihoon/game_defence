// lib/menu/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. 프로필 헤더
            _buildProfileHeader(pdm),
            
            // 2. 친구 목록 섹션
            _buildSectionTitle('친구 목록'),
            _buildFriendsList(),
            
            // 3. 게임 설정 섹션
            _buildSectionTitle('게임 설정'),
            _buildSettingsList(pdm),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(PlayerDataManager pdm) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade900, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
            ),
            child: Image.asset(_getAccountRankBadge(pdm.accountRank)),
          ),
          const SizedBox(height: 15),
          Text(pdm.accountId, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(
            'Lv.${pdm.currentLevel} | ${_getRankName(pdm.accountRank)}',
            style: TextStyle(color: _getRankColor(pdm.accountRank), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(pdm.isVipYearly ? '연간 VIP 멤버십' : (pdm.isVipMonthly ? '월간 VIP 멤버십' : '일반 등급'), 
            style: const TextStyle(color: Colors.amberAccent, fontSize: 12)),
        ],
      ),
    );
  }

  String _getRankName(CharacterRank rank) {
    return rank.name.toUpperCase();
  }

  String _getAccountRankBadge(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return 'assets/badges/ranks/SLIVER.PNG';
      case CharacterRank.gold: return 'assets/badges/ranks/GOLD.PNG';
      case CharacterRank.platinum: return 'assets/badges/ranks/PLATIUM.PNG';
      case CharacterRank.diamond: return 'assets/badges/ranks/DIAMOND.PNG';
    }
  }

  Color _getRankColor(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return const Color(0xFFE0E0E0);
      case CharacterRank.gold: return const Color(0xFFFFD700);
      case CharacterRank.platinum: return const Color(0xFF00FF7F);
      case CharacterRank.diamond: return Colors.white;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFriendsList() {
    final friends = ['대천사 미카엘', '타락천사 루시퍼', '지혜의 가브리엘'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: friends.map((name) => ListTile(
          leading: const CircleAvatar(radius: 15, backgroundColor: Colors.white10, child: Icon(Icons.person, size: 15, color: Colors.white54)),
          title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
          trailing: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.cyanAccent),
        )).toList(),
      ),
    );
  }

  Widget _buildSettingsList(PlayerDataManager pdm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('사운드 효과', style: TextStyle(color: Colors.white, fontSize: 14)),
            value: pdm.soundEnabled,
            onChanged: (_) => pdm.toggleSound(),
            activeColor: Colors.cyanAccent,
          ),
          SwitchListTile(
            title: const Text('진동 피드백', style: TextStyle(color: Colors.white, fontSize: 14)),
            value: pdm.vibrationEnabled,
            onChanged: (_) => pdm.toggleVibration(),
            activeColor: Colors.cyanAccent,
          ),
          ListTile(
            title: const Text('계정 관리', style: TextStyle(color: Colors.white, fontSize: 14)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
