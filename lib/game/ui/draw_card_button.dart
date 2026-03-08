import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:game_defence/game/overflow_game.dart';

class DrawCardButton extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  late final TextComponent _pointsComponent;
  late final TextComponent _labelComponent;
  
  double _glowTimer = 0;

  DrawCardButton() {
    anchor = Anchor.center;
    priority = 100;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2.all(80); // 원형 버튼 크기
    position = Vector2(game.size.x / 2, game.size.y - 120); // 위치 조정

    _labelComponent = TextComponent(
      text: '신탁',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'NanumGothic',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 10),
    );

    _pointsComponent = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 + 12),
    );

    add(_labelComponent);
    add(_pointsComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final current = game.cardPoints;
    final cost = game.cardDrawCost;
    
    _pointsComponent.text = '$current/$cost';
    
    if (current >= cost) {
      _glowTimer += dt;
      _labelComponent.text = '발동 가능';
      _labelComponent.textRenderer = TextPaint(
        style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'NanumGothic'),
      );
    } else {
      _glowTimer = 0;
      _labelComponent.text = '신성한 신탁';
      _labelComponent.textRenderer = TextPaint(
        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'NanumGothic'),
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.cardPoints >= game.cardDrawCost) {
      game.showCardSelection();
    }
  }

  @override
  void render(Canvas canvas) {
    final current = game.cardPoints;
    final cost = game.cardDrawCost;
    final progress = math.min(1.0, current / cost);
    final isFull = current >= cost;

    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2 - 5;

    // 1. 배경 가이드 원 (매우 연하게)
    canvas.drawCircle(
      center, 
      radius, 
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 2. 프로그레스 원형 게이지
    final progressPaint = Paint()
      ..color = isFull ? Colors.cyanAccent : Colors.amberAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // 3. 풀 게이지 시 글로우 효과
    if (isFull) {
      final glowOpacity = (math.sin(_glowTimer * 5) + 1) / 2 * 0.4;
      canvas.drawCircle(
        center, 
        radius + 2, 
        Paint()
          ..color = Colors.cyanAccent.withValues(alpha: glowOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    super.render(canvas);
  }
}
