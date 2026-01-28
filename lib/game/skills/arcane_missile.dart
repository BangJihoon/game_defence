import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/enemy.dart';
import 'package:game_defence/game/overflow_game.dart';

class ArcaneMissileProjectile extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  final Enemy target;
  final int damage;
  final bool isHoming;

  final double _speed = 300;

  ArcaneMissileProjectile({
    required this.target,
    required this.damage,
    this.isHoming = false,
  });

  @override
  void update(double dt) {
    super.update(dt);

    if (!target.isMounted) {
      removeFromParent();
      return;
    }

    final direction = (target.position - position).normalized();
    position += direction * _speed * dt;

    if (position.distanceTo(target.position) < 10) {
      target.takeDamage(damage);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.purple;
    canvas.drawCircle(Offset.zero, 5, paint);
  }
}
