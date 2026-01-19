import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class GameBackground extends RectangleComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    position = Vector2.zero();
    paint = Paint()..color = const Color(0xFF0f1419);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 그라데이션 배경
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0f1419),
          const Color(0xFF1a1a2e),
          const Color(0xFF16213e),
        ],
      ).createShader(size.toRect());
    canvas.drawRect(size.toRect(), gradientPaint);

    // 별 효과 (간단한 점들)
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
    for (int i = 0; i < 20; i++) {
      final x = (i * 37.5) % size.x;
      final y = (i * 23.7) % size.y;
      canvas.drawCircle(Offset(x, y), 1.5, starPaint);
    }
  }
}
