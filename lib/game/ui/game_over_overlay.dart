// lib/game/ui/game_over_overlay.dart
//
// An overlay component displayed when the game ends.
// Responsibilities:
// - Showing the "Game Over" title and the player's final score.
// - Providing interactive buttons to restart the game or return to the main menu.
// - Handling touch input to trigger the restart or exit callbacks.

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class GameOverOverlay extends RectangleComponent with HasGameRef, TapCallbacks {
  final int gameScore;
  final VoidCallback onRestart;
  final VoidCallback? onExit;
  final Locale locale;
  late AppLocalizations l10n;

  late Rect _restartButtonRect;
  late Rect _exitButtonRect;

  GameOverOverlay({
    required this.gameScore,
    required this.onRestart,
    required this.locale,
    this.onExit,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    paint = Paint()..color = Colors.black.withOpacity(0.7);
    position = Vector2.zero();
    l10n = AppLocalizations(locale);

    _restartButtonRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.6),
      width: 200,
      height: 50,
    );

    _exitButtonRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.75),
      width: 200,
      height: 50,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Game Over Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: l10n.gameOver,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset((size.x - titlePainter.width) / 2, size.y * 0.2));

    // Score
    final scorePainter = TextPainter(
      text: TextSpan(
        text: l10n.score(gameScore),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(canvas, Offset((size.x - scorePainter.width) / 2, size.y * 0.35));

    // --- Render Buttons ---
    _renderButton(canvas, _restartButtonRect, l10n.restartGame);
    if (onExit != null) {
      _renderButton(canvas, _exitButtonRect, l10n.returnToMenu);
    }
  }

  void _renderButton(Canvas canvas, Rect rect, String text) {
    final buttonPaint = Paint()..color = const Color(0xFF4a90e2);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)), buttonPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)), borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(rect.center.dx - textPainter.width / 2, rect.center.dy - textPainter.height / 2));
  }

  @override
  bool onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition.toOffset();
    
    if (_restartButtonRect.contains(tapPosition)) {
      onRestart();
      return true;
    }
    
    if (onExit != null && _exitButtonRect.contains(tapPosition)) {
      onExit?.call();
      return true;
    }

    return false;
  }
}
