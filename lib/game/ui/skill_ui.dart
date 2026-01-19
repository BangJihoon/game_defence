import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../skills/skill_system.dart';
import '../overflow_game.dart';
import '../../config/game_config.dart';

class SkillUI extends RectangleComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final SkillSystem skillSystem;
  final Locale locale;
  final GameStats gameStats;
  late double buttonSize;
  late double spacing;
  late double upgradeButtonHeight;

  SkillUI(this.skillSystem, {required this.locale, required this.gameStats});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    buttonSize = gameStats.skillButtonSize.toDouble();
    spacing = gameStats.skillButtonSpacing.toDouble();
    upgradeButtonHeight = 20; // Height for the upgrade button

    size = Vector2(
      (buttonSize + spacing) * skillSystem.skills.length - spacing,
      buttonSize + spacing + upgradeButtonHeight, // Accommodate upgrade button
    );
    position = Vector2(
      gameRef.size.x - size.x - 20,
      gameRef.size.y - size.y - 20, // Move up to accommodate
    );
    paint = Paint()..color = Colors.transparent;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    double xOffset = 0;
    for (int i = 0; i < skillSystem.skills.length; i++) {
      final skill = skillSystem.skills[i];
      final skillButtonRect = Rect.fromLTWH(
        xOffset,
        0,
        buttonSize,
        buttonSize,
      );
      final upgradeButtonRect = Rect.fromLTWH(
        xOffset,
        buttonSize + spacing,
        buttonSize,
        upgradeButtonHeight,
      );

      // Skill Button Background
      final skillBgColor = skill.isReady
          ? const Color(0xFF4a90e2)
          : const Color(0xFF666666);
      final skillBgPaint = Paint()..color = skillBgColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(skillButtonRect, const Radius.circular(8)),
        skillBgPaint,
      );

      // Cooldown Overlay
      if (!skill.isReady) {
        final cooldownRatio = skill.currentCooldown / skill.cooldown;
        final overlayHeight = buttonSize * cooldownRatio;
        final overlayPaint = Paint()..color = Colors.black.withOpacity(0.6);
        canvas.drawRect(
          Rect.fromLTWH(
            xOffset,
            buttonSize - overlayHeight,
            buttonSize,
            overlayHeight,
          ),
          overlayPaint,
        );

        // Cooldown Text
        final cooldownText = skill.currentCooldown.toStringAsFixed(1);
        final textPainter = TextPainter(
          text: TextSpan(
            text: cooldownText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            xOffset + (buttonSize - textPainter.width) / 2,
            (buttonSize - textPainter.height) / 2,
          ),
        );
      }

      // Skill Icon
      final iconText = _getSkillIcon(skill.type);
      final iconPainter = TextPainter(
        text: TextSpan(
          text: iconText,
          style: TextStyle(
            color: skill.isReady ? Colors.white : Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          xOffset + (buttonSize - iconPainter.width) / 2,
          (buttonSize - iconPainter.height) / 2 - 8,
        ),
      );

      // Skill Name & Level
      final nameAndLevelText = '${skill.name} L${skill.currentLevel + 1}';
      final nameAndLevelPainter = TextPainter(
        text: TextSpan(
          text: nameAndLevelText,
          style: TextStyle(
            color: skill.isReady ? Colors.white : Colors.grey,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      nameAndLevelPainter.layout();
      nameAndLevelPainter.paint(
        canvas,
        Offset(
          xOffset + (buttonSize - nameAndLevelPainter.width) / 2,
          buttonSize - 12,
        ),
      );

      // Skill Button Border
      final skillBorderPaint = Paint()
        ..color = skill.isReady ? Colors.white : Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(skillButtonRect, const Radius.circular(8)),
        skillBorderPaint,
      );

      // Upgrade Button Background
      final canAffordUpgrade = game.score >= skill.upgradeCost;
      final upgradeBgColor = skill.canUpgrade && canAffordUpgrade
          ? const Color(0xFF4CAF50) // Green if upgradable and affordable
          : const Color(0xFF9E9E9E); // Grey if not
      final upgradeBgPaint = Paint()..color = upgradeBgColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(upgradeButtonRect, const Radius.circular(4)),
        upgradeBgPaint,
      );

      // Upgrade Button Text
      final upgradeText = skill.canUpgrade
          ? 'UP: ${skill.upgradeCost}'
          : 'MAX';
      final upgradeTextPainter = TextPainter(
        text: TextSpan(
          text: upgradeText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      upgradeTextPainter.layout();
      upgradeTextPainter.paint(
        canvas,
        Offset(
          xOffset + (buttonSize - upgradeTextPainter.width) / 2,
          buttonSize + spacing + (upgradeButtonHeight - upgradeTextPainter.height) / 2,
        ),
      );

      xOffset += buttonSize + spacing;
    }
  }

  String _getSkillIcon(SkillType type) {
    switch (type) {
      case SkillType.lightning:
        return '⚡';
      case SkillType.freeze:
        return '❄';
      case SkillType.heal:
        return '💚';
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (game.isGameOver) return false;

    final tapPos = event.localPosition;
    double xOffset = 0;

    for (int i = 0; i < skillSystem.skills.length; i++) {
      final skill = skillSystem.skills[i];
      final skillButtonRect = Rect.fromLTWH(
        xOffset,
        0,
        buttonSize,
        buttonSize,
      );
      final upgradeButtonRect = Rect.fromLTWH(
        xOffset,
        buttonSize + spacing,
        buttonSize,
        upgradeButtonHeight,
      );

      if (skillButtonRect.contains(Offset(tapPos.x, tapPos.y)) && skill.isReady) {
        skillSystem.useSkill(skill.type);
        return true;
      }
      
      if (upgradeButtonRect.contains(Offset(tapPos.x, tapPos.y)) && skill.canUpgrade && game.score >= skill.upgradeCost) {
        skillSystem.upgradeSkill(skill.type);
        return true;
      }

      xOffset += buttonSize + spacing;
    }

    return false;
  }
}