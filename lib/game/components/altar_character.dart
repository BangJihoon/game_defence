// lib/game/components/altar_character.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/game/overflow_game.dart';

class AltarCharacterComponent extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final Character character;
  
  AltarCharacterComponent({required this.character, required Vector2 position}) 
    : super(position: position, size: Vector2.all(50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 1. 바닥 마법진 (회전 효과)
    final aura = CircleComponent(
      radius: size.x * 0.6,
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()
        ..color = _getTierColor(character.tier).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(aura);
    aura.add(RotateEffect.by(2 * math.pi, EffectController(duration: 10, infinite: true)));

    // 2. 중앙 코어 (둥실거리는 효과)
    final core = PositionComponent(
      size: Vector2.all(24),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(core);
    core.add(MoveByEffect(Vector2(0, -10), EffectController(duration: 1.5, alternate: true, infinite: true)));

    // 코어 비주얼 (빛나는 보석 느낌)
    core.add(CircleComponent(
      radius: 12,
      paint: Paint()..color = _getTierColor(character.tier),
    )..add(GlowEffectComponent())); 
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 캐릭터 이름 표시 (작게)
    final painter = TextPainter(
      text: TextSpan(
        text: character.name,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset((size.x - painter.width) / 2, size.y + 5));
  }

  Color _getTierColor(CharacterTier tier) {
    switch (tier) {
      case CharacterTier.mortal: return Colors.blueGrey;
      case CharacterTier.hero: return Colors.orangeAccent;
      case CharacterTier.celestial: return Colors.cyanAccent;
    }
  }
}

class GlowEffectComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 10, paint);
  }
}
