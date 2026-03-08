import 'package:flutter/material.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:game_defence/menu/pages/character/presentation/widgets/character_detail_popup.dart';

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
              // 1. 상단 영역 (신전 배경 + 기둥) - 전체의 3/7 차지
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // 신전 배경 이미지
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                        child: Image.asset(
                          pdm.activeTemple.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        // 슬롯 확장 버튼
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // TODO: 슬롯 확장 팝업 안내 구현
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_circle_outline, color: Colors.amberAccent, size: 14),
                                    SizedBox(width: 4),
                                    Text('슬롯 확장', style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 기둥 배치 영역
                        Expanded(child: _buildTemplePillars(pdm, l10n)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 2. 하단 영역 (탭바 + 그리드) - 전체의 4/7 차지
              Expanded(
                flex: 4,
                child: Column(
                  children: [
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplePillars(PlayerDataManager pdm, AppLocalizations l10n) {
    final activeTemple = pdm.activeTemple;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(pdm.characterSlots, (index) {
          final charId = index < pdm.equippedCharacterIds.length ? pdm.equippedCharacterIds[index] : null;
          final char = charId != null ? pdm.masterCharacterList.firstWhere((c) => c.id == charId, orElse: () => pdm.masterCharacterList.first) : null;
          
          final hasBonus = char != null && char.faction == activeTemple.supportedFaction;

          return GestureDetector(
            onTap: char != null ? () {
              final index = pdm.masterCharacterList.indexOf(char);
              _showCharacterDetail(context, pdm.masterCharacterList, index);
            } : null,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / (pdm.characterSlots + 0.5),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (char != null) ...[
                        Expanded(
                          child: FractionallySizedBox(
                            widthFactor: 0.7, // 0.7배 크기 조정
                            heightFactor: 0.7,
                            child: Image.asset(
                              'assets/images/${char.idleFrontAssetPath}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/fallback.png', fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ] else 
                        const Center(
                          child: Icon(Icons.add_circle_outline, color: Colors.white54, size: 40),
                        ),
                    ],
                  ),
                  if (hasBonus)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _buildBonusTag(),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCharacterGrid(PlayerDataManager pdm, Faction? filterFaction, AppLocalizations l10n) {
    final activeTemple = pdm.activeTemple;
    final filtered = filterFaction == null 
        ? pdm.masterCharacterList.toList() 
        : pdm.masterCharacterList.where((c) => c.faction == filterFaction).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final char = filtered[index];
        final isEquipped = pdm.equippedCharacterIds.contains(char.id);
        final rank = char.startingRank;
        final hasBonus = char.faction == activeTemple.supportedFaction;
        
        return GestureDetector(
          onTap: () => _showCharacterDetail(context, filtered, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _getRankColor(rank),
                width: _getRankBorderWidth(rank),
              ),
              boxShadow: [
                // 랭크별 글로우 효과 (선택 시 더 강하게)
                BoxShadow(
                  color: _getRankColor(rank).withOpacity(isEquipped ? 0.6 : 0.3), 
                  blurRadius: isEquipped ? 15 : 6, 
                  spreadRadius: isEquipped ? 3 : 0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/characters/bg.png',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
                  ),
                ),
                Positioned.fill(
                  bottom: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/${char.idleFrontAssetPath}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                if (isEquipped)
                  Positioned.fill(
                    bottom: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.white.withOpacity(0.8),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.translate(char.nameLocaleKey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white,
                            fontFamily: 'NanumGothic',
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 랭크 뱃지 (좌측 상단)
                Positioned(
                  top: 2,
                  left: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4)],
                    ),
                    child: Image.asset(
                      (pdm.ownedCharacters[char.id] ?? PlayerCharacter(characterId: char.id, rank: char.startingRank)).rankBadgePath,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
                // 속성 뱃지 (우측 상단)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4)],
                    ),
                    child: Image.asset(
                      char.elementBadgePath,
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
                if (hasBonus)
                  Positioned(
                    top: 38,
                    right: 2,
                    child: _buildBonusTag(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBonusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.amberAccent.withOpacity(0.5), blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: const Text(
        'BONUS',
        style: TextStyle(
          color: Colors.black,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRankColor(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return const Color(0xFFE0E0E0); // Brighter Silver
      case CharacterRank.gold: return const Color(0xFFFFD700); // Vivid Gold
      case CharacterRank.platinum: return const Color(0xFF00FF7F); // Spring Green (Vivid Emerald)
      case CharacterRank.diamond: return Colors.white; // Pure White
    }
  }

  double _getRankBorderWidth(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return 3.0; // 1.5 -> 3.0
      case CharacterRank.gold: return 4.0;   // 2.0 -> 4.0
      case CharacterRank.platinum: return 5.0; // 2.5 -> 5.0
      case CharacterRank.diamond: return 6.0;  // 3.0 -> 6.0
    }
  }

  void _showCharacterDetail(BuildContext context, List<CharacterDefinition> characters, int initialIndex) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Character Detail',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return CharacterDetailPopup(characters: characters, initialIndex: initialIndex);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }
}
