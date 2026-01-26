import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DamageTextEffect extends PositionComponent {
  final String text;
  final Vector2 initialPosition;
  final double _initialLifeTime = 0.8; // Duration for the text to move and fade
  late double _lifeTime;

  DamageTextEffect({
    required this.text,
    required this.initialPosition,
  }) : super(
          position: initialPosition,
          anchor: Anchor.center,
          size: Vector2(50, 20), // Placeholder size
        ) {
    _lifeTime = _initialLifeTime;
  }

  late TextComponent _textComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    _textComponent = TextComponent(
      text: text,
      textRenderer: textPaint,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2), // Center text within this component
    );

    add(_textComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _lifeTime -= dt;

    if (_lifeTime <= 0) {
      removeFromParent();
      return;
    }
  }
}