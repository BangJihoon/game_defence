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
    final activeSkills = skillSystem.activeSkills;
    
    const double iconSize = 42.0; 
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
  final SkillState skill;
  final AppLocalizations l10n;
  late RectangleComponent _cooldownOverlay;
  late TextComponent _cooldownText;
  late TextComponent _nameText;

  SkillIconComponent({required this.skill, required this.l10n, required Vector2 size, required Vector2 position}) 
      : super(size: size, position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final skillColor = _getSkillColor(skill.data.id);
    
    // 1. 배경
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF111111).withValues(alpha: 0.95),
    )..add(RectangleComponent(
      size: size,
      paint: Paint()..color = skillColor.withValues(alpha: 0.8)..style = PaintingStyle.stroke..strokeWidth = 2,
    )));

    // 2. 스킬 이름
    _nameText = TextComponent(
      text: _getSkillShortName(skill.data.id),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 10, 
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

    // 4. 쿨타임 숫자
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
    final fullName = l10n.translate(skill.data.nameLocaleKey);
    if (fullName.length > 4) {
      return fullName.substring(0, 4);
    }
    return fullName;
  }

  Color _getSkillColor(String skillId) {
    if (skillId.contains('MICHAEL')) return Colors.orangeAccent;
    if (skillId.contains('RAPHAEL')) return Colors.cyanAccent;
    if (skillId.contains('URIEL')) return Colors.yellow;
    if (skillId.contains('GABRIEL')) return Colors.white;
    if (skillId.contains('SERAPHIM')) return Colors.redAccent;
    if (skillId.contains('LUCIFER')) return Colors.deepPurpleAccent;
    if (skillId.contains('ASMODEUS')) return Colors.greenAccent;
    if (skillId.contains('BAAL')) return Colors.blueAccent;
    if (skillId.contains('LEVIATHAN')) return Colors.blue;
    if (skillId.contains('BEELZEBUB')) return Colors.lightGreenAccent;
    return Colors.white;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (skill.cooldownTimer > 0) {
      final progress = (skill.cooldownTimer / skill.data.cooldown).clamp(0.0, 1.0);
      _cooldownOverlay.size.y = size.y * progress;
      _cooldownText.text = skill.cooldownTimer.toStringAsFixed(1);
      _nameText.text = ''; 
    } else {
      _cooldownOverlay.size.y = 0;
      _cooldownText.text = '';
      _nameText.text = _getSkillShortName(skill.data.id);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isMounted || gameRef.paused || gameRef.isGameOver) return;
    gameRef.showSkillInfo(skill);
  }
}

class SkillInfoPopup extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final SkillState skill;
  final Locale locale;
  late final AppLocalizations l10n;

  SkillInfoPopup({required this.skill, required this.locale}) : super(priority: 600);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    l10n = AppLocalizations(locale);
    size = gameRef.size;
    add(RectangleComponent(size: size, paint: Paint()..color = Colors.black.withValues(alpha: 0.7)));
    final center = size / 2;
    const popupWidth = 280.0;
    const popupHeight = 260.0;
    add(RectangleComponent(size: Vector2(popupWidth, popupHeight), position: center, anchor: Anchor.center, paint: Paint()..color = const Color(0xFF222222))..add(RectangleComponent(size: Vector2(popupWidth, popupHeight), paint: Paint()..color = Colors.white.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2)));
    
    // Title (Localized Skill Name)
    add(TextComponent(
      text: l10n.translate(skill.data.nameLocaleKey), 
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), 
      anchor: Anchor.topCenter, 
      position: center - Vector2(0, popupHeight / 2 - 20)
    ));

    // Description (Localized)
    add(TextComponent(
      text: l10n.translate(skill.data.descriptionLocaleKey),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.grey, fontSize: 12)),
      anchor: Anchor.topCenter,
      position: center - Vector2(0, popupHeight / 2 - 50),
    ));

    final isKo = locale.languageCode == 'ko';
    String detailText = '${isKo ? '속성' : 'Elem'}: ${skill.data.element.name.toUpperCase()}\n${isKo ? '계수' : 'Mult'}: x${skill.data.multiplier.toStringAsFixed(1)}\n${isKo ? '쿨타임' : 'CD'}: ${skill.data.cooldown.toStringAsFixed(1)}s';
    add(TextComponent(text: detailText, textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)), anchor: Anchor.center, position: center + Vector2(0, 30)));
    add(TextComponent(text: isKo ? '탭하여 닫기' : 'Tap to close', textRenderer: TextPaint(style: const TextStyle(color: Colors.blueAccent, fontSize: 12)), anchor: Anchor.bottomCenter, position: center + Vector2(0, popupHeight / 2 - 20)));
  }
  @override
  void onMount() { super.onMount(); gameRef.paused = true; }
  @override
  void onTapUp(TapUpEvent event) { gameRef.paused = false; removeFromParent(); }
}
