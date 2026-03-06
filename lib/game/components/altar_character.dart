// lib/game/components/altar_character.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/game/overflow_game.dart';

class AltarCharacterComponent extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final CharacterDefinition character;
  
  AltarCharacterComponent({required this.character, required Vector2 position}) 
    : super(position: position, size: Vector2.all(80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 1. 바닥 마법진 (회전 효과)
    final aura = CircleComponent(
      radius: size.x * 0.4,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.8),
      paint: Paint()
        ..color = _getFactionColor(character.faction).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(aura);
    aura.add(RotateEffect.by(2 * math.pi, EffectController(duration: 10, infinite: true)));

    // 2. 캐릭터 스프라이트 (둥실거리는 효과)
    final sprite = await gameRef.loadSprite(character.idleBackAssetPath);
    final characterVisual = SpriteComponent(
      sprite: sprite,
      size: Vector2.all(60),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(characterVisual);
    
    // 둥실거리는 애니메이션
    characterVisual.add(MoveByEffect(
      Vector2(0, -5), 
      EffectController(duration: 2.0, alternate: true, infinite: true, curve: Curves.easeInOut)
    ));

    // 글로우 효과 (캐릭터 뒤에)
    characterVisual.add(GlowEffectComponent()..priority = -1);
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

  Color _getFactionColor(Faction faction) {
    switch (faction) {
      case Faction.angel: return Colors.cyanAccent;
      case Faction.demon: return Colors.redAccent;
      case Faction.ancient: return Colors.purpleAccent;
    }
  }
}

class GlowEffectComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 20, paint);
  }
}
