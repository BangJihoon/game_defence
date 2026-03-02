// lib/game/ui/skill_ui.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/skills/skill_system.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class SkillUI extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final SkillSystem skillSystem;
  final Locale locale;
  final GameStats gameStats;
  late AppLocalizations l10n;

  SkillUI(this.skillSystem, {required this.locale, required this.gameStats}) : super(priority: 100);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    l10n = AppLocalizations(locale);
    anchor = Anchor.centerLeft;
    position = Vector2(10, gameRef.size.y * 0.5); 
    refreshSkillIcons();
  }

  void refreshSkillIcons() {
    removeAll(children);
    final equippedSkillIds = gameRef.playerDataManager.equippedCharacterIds.map((id) {
      return gameRef.playerDataManager.masterCharacterList.firstWhere((c) => c.id == id).skillId;
    }).toList();
    final activeSkills = skillSystem.skills.where((s) => equippedSkillIds.contains(s.skillId)).toList();
    
    const double iconSize = 42.0; // 크기 확대
    const double spacing = 10.0;
    final int skillCount = activeSkills.length;
    if (skillCount == 0) return;

    for (int i = 0; i < skillCount; i++) {
      add(SkillIconComponent(
        skill: activeSkills[i],
        l10n: l10n,
        size: Vector2.all(iconSize),
        position: Vector2(0, (i * (iconSize + spacing)) - ((iconSize + spacing) * skillCount / 2) + (iconSize / 2)),
      ));
    }
  }
}

class SkillIconComponent extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final Skill skill;
  final AppLocalizations l10n;
  late RectangleComponent _cooldownOverlay;
  late TextComponent _cooldownText;
  late TextComponent _nameText;

  SkillIconComponent({required this.skill, required this.l10n, required Vector2 size, required Vector2 position}) 
      : super(size: size, position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final skillColor = _getSkillColor(skill.skillId);
    
    // 1. 배경
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF111111).withValues(alpha: 0.95), // 거의 검은색으로
    )..add(RectangleComponent(
      size: size,
      paint: Paint()..color = skillColor.withValues(alpha: 0.8)..style = PaintingStyle.stroke..strokeWidth = 2,
    )));

    // 2. 스킬 이름 (중앙 배치, 가독성 최우선)
    _nameText = TextComponent(
      text: _getSkillShortName(skill.skillId),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 11, 
          fontWeight: FontWeight.w900, 
          shadows: [Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 1))]
        )
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_nameText);

    // 3. 쿨타임 오버레이
    _cooldownOverlay = RectangleComponent(
      size: Vector2(size.x, 0),
      position: Vector2(0, size.y),
      anchor: Anchor.bottomLeft,
      paint: Paint()..color = Colors.black.withValues(alpha: 0.6),
    );
    add(_cooldownOverlay);

    // 4. 쿨타임 숫자 (중앙 배치하여 덮어씀)
    _cooldownText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.yellowAccent, fontSize: 14, fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.black, blurRadius: 6)])
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(_cooldownText);
  }

  String _getSkillShortName(String skillId) {
    switch (skillId) {
      case "lightning_strike": return '번개';
      case "freeze_nova": return '빙결';
      case "healing_aura": return '치유';
      case "fireball": return '화염';
      case "chain_lightning": return '연쇄';
      case "arcane_missile": return '비전';
      case "frost_nova": return '서리';
      case "poison_cloud": return '맹독';
      default: return 'SKL';
    }
  }

  Color _getSkillColor(String skillId) {
    switch (skillId) {
      case "lightning_strike": return Colors.yellow;
      case "freeze_nova": return Colors.lightBlueAccent;
      case "healing_aura": return Colors.greenAccent;
      case "fireball": return Colors.orangeAccent;
      case "chain_lightning": return Colors.blueAccent;
      case "arcane_missile": return Colors.purpleAccent;
      case "frost_nova": return Colors.cyanAccent;
      case "poison_cloud": return Colors.lightGreenAccent;
      default: return Colors.white;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (skill.currentCooldown > 0) {
      final progress = (skill.currentCooldown / skill.cooldown).clamp(0.0, 1.0);
      _cooldownOverlay.size.y = size.y * progress;
      _cooldownText.text = skill.currentCooldown.toStringAsFixed(1);
      _nameText.text = ''; // 쿨타임 중에는 이름 숨김
    } else {
      _cooldownOverlay.size.y = 0;
      _cooldownText.text = '';
      _nameText.text = _getSkillShortName(skill.skillId); // 복구
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isMounted || gameRef.paused || gameRef.isGameOver) return;
    gameRef.showSkillInfo(skill);
  }
}

class SkillInfoPopup extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final Skill skill;
  final Locale locale;
  SkillInfoPopup({required this.skill, required this.locale}) : super(priority: 600);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    final l10n = AppLocalizations(locale);
    add(RectangleComponent(size: size, paint: Paint()..color = Colors.black.withValues(alpha: 0.7)));
    final center = size / 2;
    const popupWidth = 260.0;
    const popupHeight = 220.0;
    add(RectangleComponent(size: Vector2(popupWidth, popupHeight), position: center, anchor: Anchor.center, paint: Paint()..color = const Color(0xFF222222))..add(RectangleComponent(size: Vector2(popupWidth, popupHeight), paint: Paint()..color = Colors.white.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2)));
    add(TextComponent(text: l10n.translate(skill.definition.titleLocaleKey), textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), anchor: Anchor.topCenter, position: center - Vector2(0, popupHeight / 2 - 20)));
    final isKo = locale.languageCode == 'ko';
    String detailText = '${isKo ? '현재 레벨' : 'Level'}: ${skill.currentLevel + 1}\n${isKo ? '공격력' : 'Dmg'}: ${skill.damage.toStringAsFixed(1)}\n${isKo ? '쿨타임' : 'CD'}: ${skill.cooldown.toStringAsFixed(1)}s';
    add(TextComponent(text: detailText, textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)), anchor: Anchor.center, position: center + Vector2(0, 10)));
    add(TextComponent(text: isKo ? '탭하여 닫기' : 'Tap to close', textRenderer: TextPaint(style: const TextStyle(color: Colors.blueAccent, fontSize: 12)), anchor: Anchor.bottomCenter, position: center + Vector2(0, popupHeight / 2 - 20)));
  }
  @override
  void onMount() { super.onMount(); gameRef.paused = true; }
  @override
  void onTapUp(TapUpEvent event) { gameRef.paused = false; removeFromParent(); }
}
