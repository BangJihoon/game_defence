import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../skills/skill_system.dart';
import '../overflow_game.dart';
import '../../config/game_config.dart';
import '../../l10n/app_localizations.dart';

class SkillUI extends RectangleComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final SkillSystem skillSystem;
  final Locale locale;
  final GameStats gameStats;
  late double buttonSize;
  late double spacing;
  late double upgradeButtonHeight;
  late AppLocalizations l10n;

  SkillUI(this.skillSystem, {required this.locale, required this.gameStats}) {
    l10n = AppLocalizations(locale);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    buttonSize = gameStats.skillButtonSize.toDouble();
    spacing = gameStats.skillButtonSpacing.toDouble();
    upgradeButtonHeight = 20; // Height for the upgrade button

    const maxSkillsPerRow = 3;
    final numRows = (skillSystem.skills.length / maxSkillsPerRow).ceil();
    final numCols = (skillSystem.skills.length < maxSkillsPerRow) ? skillSystem.skills.length : maxSkillsPerRow;

    size = Vector2(
      (buttonSize + spacing) * numCols - spacing,
      (buttonSize + spacing + upgradeButtonHeight) * numRows - spacing,
    );
    position = Vector2(
      gameRef.size.x - size.x - 20,
      gameRef.size.y - size.y - 20,
    );
    paint = Paint()..color = Colors.transparent;
  }

    @override

    void render(Canvas canvas) {

      super.render(canvas);

  

      const maxSkillsPerRow = 3;

      for (int i = 0; i < skillSystem.skills.length; i++) {

        final skill = skillSystem.skills[i];

        final row = (i / maxSkillsPerRow).floor();

        final col = i % maxSkillsPerRow;

  

        final xOffset = col * (buttonSize + spacing);

        final yOffset = row * (buttonSize + spacing + upgradeButtonHeight);

  

        final skillButtonRect = Rect.fromLTWH(

          xOffset,

          yOffset,

          buttonSize,

          buttonSize,

        );

        final upgradeButtonRect = Rect.fromLTWH(

          xOffset,

          yOffset + buttonSize + spacing,

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

              yOffset + buttonSize - overlayHeight,

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

              yOffset + (buttonSize - textPainter.height) / 2,

            ),

          );

        }

  

        // Skill Icon

        final iconText = _getSkillIcon(skill.skillId);

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

            yOffset + (buttonSize - iconPainter.height) / 2 - 8,

          ),

        );

  

        // Skill Name & Level

        final nameAndLevelText = '${l10n.translate(skill.definition.titleLocaleKey)} L${skill.currentLevel + 1}';

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

            yOffset + buttonSize - 12,

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

            style: const TextStyle(

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

            yOffset + buttonSize + spacing + (upgradeButtonHeight - upgradeTextPainter.height) / 2,

          ),

        );

      }

    }

  

    String _getSkillIcon(String skillId) {

      switch (skillId) {

        case "lightning_strike":

          return '⚡';

        case "freeze_nova":

          return '❄';

        case "healing_aura":

          return '💚';

        case "fireball":

          return '🔥';

        case "chain_lightning":

          return '🔗';

        case "ice_wall":

          return '🧱';

        default:

          return '?';

      }

    }

  

    @override

    bool onTapDown(TapDownEvent event) {

      if (game.isGameOver) return false;

  

      final tapPos = event.localPosition;

      const maxSkillsPerRow = 3;

  

      for (int i = 0; i < skillSystem.skills.length; i++) {

        final skill = skillSystem.skills[i];

        final row = (i / maxSkillsPerRow).floor();

        final col = i % maxSkillsPerRow;

  

        final xOffset = col * (buttonSize + spacing);

        final yOffset = row * (buttonSize + spacing + upgradeButtonHeight);

  

        final upgradeButtonRect = Rect.fromLTWH(

          xOffset,

          yOffset + buttonSize + spacing,

          buttonSize,

          upgradeButtonHeight,

        );

  

        if (upgradeButtonRect.contains(Offset(tapPos.x, tapPos.y)) && skill.canUpgrade && game.score >= skill.upgradeCost) {

          skillSystem.upgradeSkill(skill.skillId);

          return true;

        }

      }

  

      return false;

    }

  }

  