// lib/game/ui/attack_power_display.dart
//
// A debug/HUD component that displays the player's current global attack power multiplier.
// Responsibilities:
// - Reading the global damage multiplier from the `ModifierManager`.
// - Updating and rendering the text every frame to reflect real-time changes.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class AttackPowerDisplay extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  late TextPainter _textPainter;

  AttackPowerDisplay() {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(20, 50);
    _updateText();
  }

  void _updateText() {
    final damageMultiplier =
        (game.modifierManager.globalDamageMultiplier * 100).toStringAsFixed(0);
    _textPainter = TextPainter(
      text: TextSpan(
        text: 'Attack Power: $damageMultiplier%',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _textPainter.paint(canvas, Offset.zero);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateText();
  }
}
