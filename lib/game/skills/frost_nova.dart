
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class FrostNovaEffect extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  final int damage;
  final double radius;
  final bool isExpanding;

  FrostNovaEffect({
    required this.damage,
    required this.radius,
    this.isExpanding = false,
  }) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = game.playerBase.position;

    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final circle = CircleComponent(
      radius: 0,
      paint: paint,
      anchor: Anchor.center,
    );

    add(circle);

    final effect = ScaleEffect.to(
      Vector2.all(radius / 10), // The circle component has a radius of 10
      EffectController(duration: 0.5),
      onComplete: () {
        final enemies = game.enemySystem.enemies.where(
          (enemy) => enemy.position.distanceTo(position) < radius,
        );
        for (final enemy in enemies) {
          enemy.takeDamage(damage);
          // TODO: Add slow effect
        }
        removeFromParent();
      },
    );

    circle.add(effect);
  }
}
