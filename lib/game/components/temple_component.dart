// lib/game/components/temple_component.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TempleComponent extends SpriteComponent with HasGameRef {
  final int level;
  
  TempleComponent({
    required this.level,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load temple image based on level
    try {
      sprite = await gameRef.loadSprite('temple/temple$level.png');
    } catch (e) {
      print('Warning: Temple asset missing, using fallback');
      // No-op or use a generic sprite if available
    }
    
    // 1. Floating effect
    add(MoveByEffect(
      Vector2(0, -10),
      EffectController(duration: 3.0, alternate: true, infinite: true, curve: Curves.easeInOut),
    ));
    
    // 2. Subtle pulse effect (scaling)
    add(ScaleEffect.by(
      Vector2.all(1.05),
      EffectController(duration: 2.0, alternate: true, infinite: true, curve: Curves.easeInOut),
    ));

    // 3. Add background aura/glow
    final aura = TempleAuraComponent(size: size);
    add(aura);
  }
}

class TempleAuraComponent extends PositionComponent {
  TempleAuraComponent({required Vector2 size}) : super(size: size, anchor: Anchor.center, position: size / 2, priority: -1);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.6, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Rotating aura if desired
  }
}
