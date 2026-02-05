// lib/game/player_base.dart
//
// Represents the player's base or wall that must be defended.
// Responsibilities:
// - Tracking current HP and Shield values.
// - Rendering the visual representation of the base, including HP and Shield bars.
// - Handling incoming damage, applying it first to shields then to HP.
// - Triggering visual feedback (shake) and events (destruction, hit) on damage.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart'; 

import 'package:game_defence/game/overflow_game.dart';

class PlayerBase extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  final int maxHp;
  double hp;
  double shield = 0.0;
  VoidCallback? onDestroyed;
  VoidCallback? onHit;

  PlayerBase({required int hp, required int height})
    : maxHp = hp,
      hp = hp.toDouble() {
    size = Vector2(0, height.toDouble()); // Width will be set in onLoad
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size.x = gameRef.size.x;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Base body
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF4a90e2), const Color(0xFF2c5aa0)],
      ).createShader(size.toRect());
    canvas.drawRect(size.toRect(), gradientPaint);

    // HP bar
    final hpRatio = hp / maxHp;
    final hpRect = Rect.fromLTWH(0, 0, size.x * hpRatio, size.y);
    final hpGradient = LinearGradient(
      colors: [
        Colors.green.withOpacity(0.5),
        Colors.lightGreen.withOpacity(0.5),
      ],
    );
    final hpPaint = Paint()..shader = hpGradient.createShader(hpRect);
    canvas.drawRect(hpRect, hpPaint);

    // Shield bar
    if (shield > 0) {
      final shieldRatio = shield / maxHp;
      final shieldRect = Rect.fromLTWH(0, 0, size.x * shieldRatio, size.y);
      final shieldPaint = Paint()..color = Colors.blue.withOpacity(0.5);
      canvas.drawRect(shieldRect, shieldPaint);
    }

    // Base border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), borderPaint);
  }

  void takeDamage(int dmg) {
    final double damageToDeal = dmg.toDouble();

    if (shield > 0) {
      final double shieldDamage = shield.clamp(0, damageToDeal);
      shield -= shieldDamage;
      final remainingDamage = damageToDeal - shieldDamage;
      if (remainingDamage > 0) {
        hp -= remainingDamage;
      }
    } else {
      hp -= damageToDeal;
    }

    if (hp < 0) hp = 0;

    onHit?.call();
    shake(); // Call shake when hit

    if (hp <= 0) {
      onDestroyed?.call();
    }
  }

  void addShield(double amount) {
    shield += amount;
  }

  void shake() {
    add(
      SequenceEffect([
        MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(0, 0), EffectController(duration: 0.05)), // Return to original position
      ]),
    );
  }
}

