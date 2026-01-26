import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class ScoreDisplay extends Component {
  int _score = 0;
  final Locale locale;
  late AppLocalizations l10n;

  ScoreDisplay({required this.locale}) {
    l10n = AppLocalizations(locale);
  }

  @override
  void render(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: l10n.score(_score),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));
  }

  void updateScore(int newScore) {
    _score = newScore;
  }
}
