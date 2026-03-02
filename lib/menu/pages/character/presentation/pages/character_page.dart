// lib/menu/pages/character/presentation/pages/character_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        body: SafeArea(
          child: Column(
            children: [
              // 1. 상단 신전 기둥 배치 영역
              _buildTemplePillars(pdm),
              
              // 2. 탭바
              const TabBar(
                tabs: [Tab(text: '전체'), Tab(text: '영웅'), Tab(text: '천사'), Tab(text: '악마')],
                labelColor: Colors.cyanAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.cyanAccent,
                dividerColor: Colors.transparent,
              ),
              
              // 3. 탭별 캐릭터 그리드
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCharacterGrid(pdm, null),
                    _buildCharacterGrid(pdm, CharacterTier.hero),
                    _buildCharacterGrid(pdm, CharacterTier.celestial), // 천사
                    _buildCharacterGrid(pdm, CharacterTier.mortal),    // 악마 컨셉
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplePillars(PlayerDataManager pdm) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(pdm.characterSlots, (index) => Container(
              width: 50, height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                border: Border.all(color: Colors.white10),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(pdm.characterSlots, (index) {
              final charId = index < pdm.equippedCharacterIds.length ? pdm.equippedCharacterIds[index] : null;
              final char = charId != null ? pdm.masterCharacterList.firstWhere((c) => c.id == charId) : null;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (char != null) ...[
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent.withOpacity(0.1), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 10)]),
                      child: Icon(char.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(char.name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ] else const Icon(Icons.add_circle_outline, color: Colors.white10, size: 36),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid(PlayerDataManager pdm, CharacterTier? filterTier) {
    final filtered = filterTier == null 
        ? pdm.masterCharacterList 
        : pdm.masterCharacterList.where((c) => c.tier == filterTier).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final char = filtered[index];
        final isEquipped = pdm.equippedCharacterIds.contains(char.id);
        return GestureDetector(
          onTap: () => pdm.toggleCharacterSelection(char.id),
          child: Container(
            decoration: BoxDecoration(
              color: isEquipped ? Colors.cyanAccent.withOpacity(0.1) : Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isEquipped ? Colors.cyanAccent : Colors.white12, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(char.icon, color: isEquipped ? Colors.white : Colors.grey, size: 28),
                const SizedBox(height: 6),
                Text(char.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                if (isEquipped) const Text('출전 중', style: TextStyle(fontSize: 9, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
