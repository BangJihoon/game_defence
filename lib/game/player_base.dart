// lib/game/player_base.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart'; 
import 'package:game_defence/game/overflow_game.dart';

class PlayerBase extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final int maxHp;
  double hp;
  double shield = 0.0;
  VoidCallback? onDestroyed;
  VoidCallback? onHit;

  double get regenPerSecond => maxHp * 0.01; // 초당 1% 회복

  PlayerBase({required int hp, required int height})
    : maxHp = hp,
      hp = hp.toDouble() {
    size = Vector2(0, height.toDouble());
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size.x = gameRef.size.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (hp <= 0) return;

    // 자동 체력 회복
    if (hp < maxHp) {
      hp = (hp + regenPerSecond * dt).clamp(0, maxHp.toDouble());
    }
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

    // --- 개선된 HP bar ---
    final hpRatio = (hp / maxHp).clamp(0.0, 1.0);
    final hpRect = Rect.fromLTWH(0, 0, size.x * hpRatio, size.y);
    
    // 체력에 따라 색상 변화 (녹색 -> 노랑 -> 빨강)
    final hpColor = Color.lerp(Colors.red, Colors.green, hpRatio)!;
    final hpPaint = Paint()..color = hpColor.withValues(alpha: 0.8);
    canvas.drawRect(hpRect, hpPaint);

    // Shield bar (눈에 띄게 파란색 선으로 표시)
    if (shield > 0) {
      final shieldRatio = (shield / maxHp).clamp(0.0, 1.0);
      canvas.drawRect(
        Rect.fromLTWH(0, size.y - 4, size.x * shieldRatio, 4),
        Paint()..color = Colors.cyanAccent,
      );
    }

    // Base border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), borderPaint);

    // --- 체력 수치 텍스트 ---
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'HP: ${hp.toInt()} / $maxHp',
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 14, 
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2)
    );
  }

  void takeDamage(int dmg) {
    if (hp <= 0) return;
    
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
    shake(); 

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
        MoveByEffect(Vector2(0, 0), EffectController(duration: 0.05)),
      ]),
    );
  }
}
