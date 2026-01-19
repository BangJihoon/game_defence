import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ExitButton extends RectangleComponent with HasGameRef, TapCallbacks {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(60, 40);
    position = Vector2(gameRef.size.x - 70, 20); // 우측 상단
    paint = Paint()..color = Colors.transparent;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 버튼 배경
    final buttonRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final bgPaint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(8)),
      bgPaint,
    );

    // 버튼 테두리
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(8)),
      borderPaint,
    );

    // X 표시
    final xPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final halfSize = 8.0;

    // X 모양 그리기
    canvas.drawLine(
      Offset(centerX - halfSize, centerY - halfSize),
      Offset(centerX + halfSize, centerY + halfSize),
      xPaint,
    );
    canvas.drawLine(
      Offset(centerX + halfSize, centerY - halfSize),
      Offset(centerX - halfSize, centerY + halfSize),
      xPaint,
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // 게임 종료 - 메인 메뉴로 돌아가기
    // 실제로는 앱 종료나 메뉴로 돌아가기 로직을 추가할 수 있음
    return true;
  }
}