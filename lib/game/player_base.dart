import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'overflow_game.dart';

class PlayerBase extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final int maxHp;
  double hp;
  VoidCallback? onDestroyed;
  VoidCallback? onHit;

  PlayerBase({required int hp, required int height}) : maxHp = hp, hp = hp.toDouble() {
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
        colors: [
          const Color(0xFF4a90e2),
          const Color(0xFF2c5aa0),
        ],
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
    final hpPaint = Paint()
      ..shader = hpGradient.createShader(hpRect);
    canvas.drawRect(hpRect, hpPaint);

    // Base border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), borderPaint);
  }

  void takeDamage(int dmg) {
    hp -= dmg;
    if (hp < 0) hp = 0;

    onHit?.call();

    if (hp <= 0) {
      onDestroyed?.call();
    }
  }
}
