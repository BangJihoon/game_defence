import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class ScoreDisplay extends PositionComponent {
  int _score = 0;
  final Locale locale;
  late AppLocalizations l10n;
  late TextComponent _scoreText;

  ScoreDisplay({required this.locale}) {
    l10n = AppLocalizations(locale);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(10, 10);
    anchor = Anchor.topLeft;

    _scoreText = TextComponent(
      text: l10n.score(_score),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
      ),
    );
    add(_scoreText);
  }

  void updateScore(int newScore) {
    _score = newScore;
    _scoreText.text = l10n.score(_score);

    // Remove any existing scale effects to ensure the animation restarts correctly
    children.whereType<ScaleEffect>().forEach((effect) => effect.removeFromParent());
    
    // Add a "pop" animation
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.3), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
      ]),
    );
  }
}
