// lib/game/ui/score_display.dart
//
// A HUD component that displays the player's current game score.
// Responsibilities:
// - Rendering the score text.
// - Updating the displayed score when notified by the game loop.
// - Adding visual feedback (pop effect) when the score changes.

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class ScoreDisplay extends PositionComponent {
  int _gameScore = 0;
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
      text: l10n.score(_gameScore),
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

  void updateScore(int newGameScore) {
    _gameScore = newGameScore;
    _scoreText.text = l10n.score(_gameScore);

    // Remove any existing scale effects to ensure the animation restarts correctly
    children.whereType<Effect>().toList().forEach((e) => e.removeFromParent());

    // Add a "pop" animation
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.3), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
      ]),
    );
  }
}
