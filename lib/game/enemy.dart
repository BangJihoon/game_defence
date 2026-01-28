import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'overflow_game.dart';
import 'player_base.dart';
import '../data/enemy_data.dart';
import 'effects/damage_text_effect.dart';
import 'package:flame/effects.dart';

class Enemy extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  double hp;
  final double maxHp;
  double baseSpeed;
  double speed;
  final PlayerBase base;
  final VoidCallback? onDestroyed;
  final int damage;
  final int score;
  final Color color;
  final String enemyId; // Add enemyId

  double freezeTimer = 0;
  double freezeMultiplier = 1.0;
  bool isDying = false;

  Enemy({
    required this.base,
    required EnemyDefinition definition, // Use EnemyDefinition
    this.onDestroyed,
  }) : hp = definition.hp.toDouble(),
       maxHp = definition.hp.toDouble(),
       baseSpeed = definition.speed,
       speed = definition.speed,
       damage = definition.damage,
       score = definition.coinReward, // Use coinReward from definition
       color = definition.color,
       enemyId = definition
           .enemyId // Assign enemyId
           {
    size = Vector2(definition.width, definition.height);
    scale = Vector2.all(1.0);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDying) {
      return;
    }

    // Update freeze effect
    if (freezeTimer > 0) {
      freezeTimer -= dt;
      speed = baseSpeed * freezeMultiplier;
    } else {
      speed = baseSpeed;
      freezeMultiplier = 1.0;
    }

    // Move downwards
    position.y += speed * dt;

    // Damage base on contact
    if (position.y + size.y / 2 >= base.position.y) {
      base.takeDamage(damage);
      _destroy();
    }
  }

  void takeDamage(int dmg) {
    if (isDying) return;
    hp -= dmg;

    // Show damage text
    game.add(
      DamageTextEffect(text: dmg.toString(), initialPosition: position.clone()),
    );

    // Hit animation
    add(
      ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(duration: 0.1, alternate: true),
      ),
    );

    if (hp <= 0) {
      isDying = true;
      // Start death animation
      add(
        SequenceEffect([
          ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.5)),
          RemoveEffect(),
        ]),
      );
      onDestroyed?.call();
    }
  }

  void kill() {
    if (isDying) return;
    hp = 0;
    isDying = true;
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(0), EffectController(duration: 0.5)),
        RemoveEffect(),
      ]),
    );
    onDestroyed?.call();
  }

  void applyFreeze(double multiplier, double duration) {
    freezeMultiplier = multiplier;
    freezeTimer = duration;
    speed = baseSpeed * multiplier;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final baseColor = freezeTimer > 0 ? const Color(0xFF87CEEB) : color;

    // Enemy body with gradient
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [baseColor, baseColor.withValues(alpha: .7)],
      ).createShader(size.toRect());
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      gradientPaint,
    );

    // Enemy border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, borderPaint);

    // Sparkles for freeze effect
    if (freezeTimer > 0) {
      final sparklePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.3), 3, sparklePaint);
      canvas.drawCircle(Offset(size.x * 0.7, size.y * 0.7), 3, sparklePaint);
    }

    // Health bar
    if (!isDying) {
      final healthBarWidth = size.x * 1.2;
      final healthBarHeight = 5.0;
      final healthBarOffset = Offset(-size.x * 0.1, -healthBarHeight * 2);

      // Health bar background
      final backgroundPaint = Paint()..color = Colors.red;
      canvas.drawRect(
        Rect.fromLTWH(
          healthBarOffset.dx,
          healthBarOffset.dy,
          healthBarWidth,
          healthBarHeight,
        ),
        backgroundPaint,
      );

      // Current health
      final healthPaint = Paint()..color = Colors.green;
      final currentHealthWidth = (hp / maxHp) * healthBarWidth;
      canvas.drawRect(
        Rect.fromLTWH(
          healthBarOffset.dx,
          healthBarOffset.dy,
          currentHealthWidth,
          healthBarHeight,
        ),
        healthPaint,
      );
    }
  }

  void _destroy() {
    // This is now handled by the death animation
  }
}
