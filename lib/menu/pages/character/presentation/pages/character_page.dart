// lib/menu/pages/character/presentation/pages/character_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        body: SafeArea(
          child: Column(
            children: [
              // 1. 상단 신전 기둥 배치 영역
              _buildTemplePillars(pdm, l10n),
              
              // 2. 탭바
              TabBar(
                tabs: [
                  Tab(text: l10n.translate('tab.all')),
                  Tab(text: l10n.translate('faction.angel')),
                  Tab(text: l10n.translate('faction.demon')),
                  Tab(text: l10n.translate('faction.ancient')),
                ],
                labelColor: Colors.cyanAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.cyanAccent,
                dividerColor: Colors.transparent,
              ),
              
              // 3. 탭별 캐릭터 그리드
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCharacterGrid(pdm, null, l10n),
                    _buildCharacterGrid(pdm, Faction.angel, l10n),
                    _buildCharacterGrid(pdm, Faction.demon, l10n),
                    _buildCharacterGrid(pdm, Faction.ancient, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplePillars(PlayerDataManager pdm, AppLocalizations l10n) {
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
              final char = charId != null ? pdm.masterCharacterList.firstWhere((c) => c.id == charId, orElse: () => pdm.masterCharacterList.first) : null;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (char != null) ...[
                    SizedBox(
                      width: 80,
                      height: 120,
                      child: Image.asset(
                        'assets/images/${char.idleFrontAssetPath}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/fallback.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.translate(char.nameLocaleKey), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ] else const Icon(Icons.add_circle_outline, color: Colors.white10, size: 36),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid(PlayerDataManager pdm, Faction? filterFaction, AppLocalizations l10n) {
    final filtered = filterFaction == null 
        ? pdm.masterCharacterList 
        : pdm.masterCharacterList.where((c) => c.faction == filterFaction).toList();

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
                ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/images/${char.iconAssetPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.translate(char.nameLocaleKey), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                if (isEquipped) Text(l10n.translate('ui.equipped'), style: const TextStyle(fontSize: 9, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
