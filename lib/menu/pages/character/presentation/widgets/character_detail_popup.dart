import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:provider/provider.dart';

class CharacterDetailPopup extends StatefulWidget {
  final List<CharacterDefinition> characters;
  final int initialIndex;

  const CharacterDetailPopup({
    super.key, 
    required this.characters, 
    required this.initialIndex
  });

  @override
  State<CharacterDetailPopup> createState() => _CharacterDetailPopupState();
}

class _CharacterDetailPopupState extends State<CharacterDetailPopup> {
  late PageController _mainPageController;
  late int _currentCharIndex;

  @override
  void initState() {
    super.initState();
    _currentCharIndex = widget.initialIndex;
    _mainPageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _mainPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    final l10n = AppLocalizations.of(context)!;

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
          
          // 메인 캐릭터 슬라이더 (PageView)
          PageView.builder(
            controller: _mainPageController,
            itemCount: widget.characters.length,
            onPageChanged: (index) => setState(() => _currentCharIndex = index),
            itemBuilder: (context, index) {
              final character = widget.characters[index];
              return _buildCharacterCard(character, pdm, l10n);
            },
          ),
          
          // 좌우 화살표 가이드 (시각적 힌트)
          if (_currentCharIndex > 0)
            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: const Icon(Icons.arrow_back_ios, color: Colors.white24, size: 30),
            ),
          if (_currentCharIndex < widget.characters.length - 1)
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 30),
            ),

          // 상단 닫기 버튼
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

  Widget _buildCharacterCard(CharacterDefinition character, PlayerDataManager pdm, AppLocalizations l10n) {
    final pc = pdm.ownedCharacters[character.id] ?? PlayerCharacter(characterId: character.id, rank: character.startingRank);
    final isEquipped = pdm.equippedCharacterIds.contains(character.id);
    
    final images = [
      'assets/images/${character.idleFrontAssetPath}',
      'assets/images/${character.idleBackAssetPath}',
      'assets/images/characters/${character.id}/attack.png',
    ];

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.75,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _getFactionColor(character.faction).withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(color: _getFactionColor(character.faction).withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // 배경 이미지 추가
              Positioned.fill(
                child: Image.asset(
                  'assets/images/characters/bg.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.6),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
              Column(
                children: [
                  // 최상단 헤더 (이름 및 속성 뱃지)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(pc.rankBadgePath, width: 24, height: 24),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.translate(character.nameLocaleKey),
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'Lv.${pc.level} | ${character.role.name.toUpperCase()}',
                              style: TextStyle(color: _getFactionColor(character.faction), fontSize: 14),
                            ),
                          ],
                        ),
                        Image.asset(character.elementBadgePath, width: 45, height: 45),
                      ],
                    ),
                  ),

                  _buildImageSlider(images),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          // 스탯 영역 (레벨 반영 계산)
                          _buildStatRow(
                            Icons.local_fire_department, 
                            '공격력', 
                            (character.baseStats.attack * pow(1.08, pc.level - 1)).toInt().toString()
                          ),
                          _buildStatRow(
                            Icons.favorite, 
                            '체력', 
                            (character.baseStats.hp * (1.0 + (pc.level - 1) * 0.1)).toInt().toString()
                          ),
                          _buildStatRow(Icons.speed, '공격속도', character.baseStats.attackSpeed.toStringAsFixed(1)),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 10),
                          const Text('캐릭터 설명', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(l10n.translate(character.descriptionLocaleKey), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 15),
                          const Text('고유 스킬', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          _buildSkillInfo(character, l10n),
                          const SizedBox(height: 20),
                          const Text('랭크 승급 진행도', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          _buildRankProgressBar(pc, pdm),
                        ],
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isEquipped && pdm.equippedCharacterIds.length >= pdm.characterSlots) {
                            // 슬롯이 가득 찬 경우
                            HapticFeedback.vibrate(); // 진동
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Center(child: Text('빈 슬롯이 없습니다', style: TextStyle(fontWeight: FontWeight.bold))),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 100, left: 50, right: 50),
                              ),
                            );
                          } else {
                            pdm.toggleCharacterSelection(character.id);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEquipped ? Colors.redAccent.withOpacity(0.8) : Colors.cyanAccent.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          isEquipped ? '출전 해제' : '팀에 합류',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> images) {
    return SizedBox(
      height: 220,
      child: ImageSliderWidget(images: images),
    );
  }

  Widget _buildRankProgressBar(PlayerCharacter pc, PlayerDataManager pdm) {
    int cardCost = 12;
    int goldCost = pc.level * 5000;
    int currentCards = pdm.characterCards[pc.characterId] ?? 0;
    bool hasEnoughCards = currentCards >= cardCost;
    bool hasEnoughGold = pdm.gold >= goldCost;
    bool canLevelUp = hasEnoughCards && hasEnoughGold;

    return Column(
      children: [
        // 12단계 도트/바
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(12, (index) {
            bool isReached = index < pc.currentStage;
            bool isCurrent = index == pc.currentStage - 1;
            
            return Expanded(
              child: Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isReached ? _getRankColor(pc.rank) : Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isCurrent ? [
                    BoxShadow(color: _getRankColor(pc.rank).withOpacity(0.5), blurRadius: 4, spreadRadius: 1)
                  ] : null,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 15),
        
        // 레벨업 버튼 및 정보
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pc.currentStage} / 12 단계',
                  style: TextStyle(color: _getRankColor(pc.rank), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '보유 카드: $currentCards / $cardCost',
                  style: TextStyle(color: hasEnoughCards ? Colors.white70 : Colors.redAccent, fontSize: 11),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: canLevelUp ? () => pdm.levelUpCharacter(pc.characterId) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getRankColor(pc.rank).withOpacity(0.2),
                foregroundColor: _getRankColor(pc.rank),
                side: BorderSide(color: _getRankColor(pc.rank).withOpacity(canLevelUp ? 0.5 : 0.1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.yellow, size: 16),
                  const SizedBox(width: 4),
                  Text('$goldCost 강화', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        if (pc.currentStage == 12)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '다음 레벨업 시 랭크가 상승합니다!',
              style: TextStyle(color: Colors.amberAccent.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.amberAccent, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSkillInfo(CharacterDefinition character, AppLocalizations l10n) {
    final skillId = character.baseSkillId;
    final skill = GameStats.instance.skillDefinitions[skillId];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill != null ? l10n.translate(skill.nameLocaleKey) : '기본 공격',
            style: const TextStyle(color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            skill != null ? l10n.translate(skill.descriptionLocaleKey) : '적에게 피해를 입힙니다.',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(CharacterRank rank) {
    switch (rank) {
      case CharacterRank.silver: return const Color(0xFFE0E0E0);
      case CharacterRank.gold: return const Color(0xFFFFD700);
      case CharacterRank.platinum: return const Color(0xFF00FF7F);
      case CharacterRank.diamond: return Colors.white;
    }
  }

  Color _getFactionColor(Faction faction) {
    switch (faction) {
      case Faction.angel: return Colors.cyanAccent;
      case Faction.demon: return Colors.redAccent;
      case Faction.ancient: return Colors.purpleAccent;
    }
  }

  Color _getElementColor(ElementType element) {
    switch (element) {
      case ElementType.fire: return Colors.orange;
      case ElementType.water: return Colors.blue;
      case ElementType.nature: return Colors.green;
      case ElementType.electric: return Colors.yellow;
      case ElementType.light: return Colors.amberAccent;
      case ElementType.dark: return Colors.purple;
      case ElementType.ice: return Colors.cyan;
      default: return Colors.grey;
    }
  }

  IconData _getElementIconData(ElementType element) {
    switch (element) {
      case ElementType.fire: return Icons.local_fire_department;
      case ElementType.water: return Icons.waves;
      case ElementType.nature: return Icons.terrain;
      case ElementType.electric: return Icons.bolt;
      case ElementType.light: return Icons.wb_sunny;
      case ElementType.dark: return Icons.nightlight_round;
      case ElementType.ice: return Icons.ac_unit;
      default: return Icons.help_outline;
    }
  }
}

class ImageSliderWidget extends StatefulWidget {
  final List<String> images;
  const ImageSliderWidget({super.key, required this.images});

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  late PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          onPageChanged: (index) => setState(() => _page = index),
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  widget.images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/fallback.png', fit: BoxFit.contain),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) => Container(
              width: 6, height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _page == index ? Colors.white : Colors.white24,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
