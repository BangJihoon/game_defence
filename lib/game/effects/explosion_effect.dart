import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class ExplosionEffect extends PositionComponent {
  double life = 0.3;

  ExplosionEffect(Vector2 center) {
    position = center;
    size = Vector2.all(10);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    life -= dt;
    size += Vector2.all(300 * dt);

    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final opacity = life / 0.3;
    
    // 외곽 원 - 빨간색
    final outerPaint = Paint()
      ..color = Colors.red.withOpacity(opacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset.zero, size.x / 2, outerPaint);

    // 중간 원 - 주황색
    final middlePaint = Paint()
      ..color = Colors.orange.withOpacity(opacity * 0.6);
    canvas.drawCircle(Offset.zero, size.x / 3, middlePaint);

    // 내부 원 - 노란색
    final innerPaint = Paint()
      ..color = Colors.yellow.withOpacity(opacity * 0.8);
    canvas.drawCircle(Offset.zero, size.x / 6, innerPaint);

    // 파티클 효과 (간단한 점들)
    final particlePaint = Paint()
      ..color = Colors.white.withOpacity(opacity);
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi * 2) / 8;
      final x = (size.x / 2 * 0.7) * (1 - opacity) * (0.5 + opacity) * cos(angle);
      final y = (size.x / 2 * 0.7) * (1 - opacity) * (0.5 + opacity) * sin(angle);
      canvas.drawCircle(Offset(x, y), 3, particlePaint);
    }
  }
}
