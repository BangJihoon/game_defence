import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class GameOverOverlay extends RectangleComponent with HasGameRef, TapCallbacks {
  final int score;
  final VoidCallback onRestart;
  final Locale locale;
  late AppLocalizations l10n;

  GameOverOverlay({
    required this.score,
    required this.onRestart,
    required this.locale,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    paint = Paint()..color = Colors.black.withOpacity(0.7);
    position = Vector2.zero();
    l10n = AppLocalizations(locale);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${l10n.gameOver}\n${l10n.score(score)}\n\n${l10n.tapToRestart}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: size.x);
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onRestart();
    return true;
  }
}
