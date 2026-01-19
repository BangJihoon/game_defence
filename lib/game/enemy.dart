import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'player_base.dart';
import '../config/game_config.dart';

enum EnemyType { normal, fast, tank }

class Enemy extends PositionComponent {
  double hp;
  double baseSpeed;
  double speed;
  final PlayerBase base;
  final VoidCallback? onDestroyed;
  final int damage;
  final int score;
  final Color color;

  double freezeTimer = 0;
  double freezeMultiplier = 1.0;

  Enemy({
    required this.base,
    required EnemyStats stats,
    this.onDestroyed,
  })  : hp = stats.hp.toDouble(),
        baseSpeed = stats.speed,
        speed = stats.speed,
        damage = stats.damage,
        score = stats.score,
        color = stats.color {
    size = Vector2(stats.width.toDouble(), stats.height.toDouble());
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

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
    hp -= dmg;
    if (hp <= 0) {
      _destroy();
    }
  }

  void kill() {
    hp = 0;
    _destroy();
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
        colors: [
          baseColor,
          baseColor.withOpacity(0.7),
        ],
      ).createShader(size.toRect());
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      gradientPaint,
    );

    // Enemy border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      borderPaint,
    );
    
    // Sparkles for freeze effect
    if (freezeTimer > 0) {
      final sparklePaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size.x * 0.3, size.y * 0.3),
        3,
        sparklePaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.7, size.y * 0.7),
        3,
        sparklePaint,
      );
    }
  }

  void _destroy() {
    onDestroyed?.call();
    removeFromParent();
  }
}