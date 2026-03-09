// lib/game/ui/game_over_overlay.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:game_defence/game/overflow_game.dart';

class GameOverOverlay extends RectangleComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final int gameScore;
  final int waveReached;
  final VoidCallback onRestart;
  final VoidCallback? onExit;
  final Locale locale;
  late AppLocalizations l10n;

  late Rect _restartButtonRect;
  late Rect _exitButtonRect;

  GameOverOverlay({
    required this.gameScore,
    required this.waveReached,
    required this.onRestart,
    required this.locale,
    this.onExit,
  }) : super(priority: 1000);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    paint = Paint()..color = Colors.black.withValues(alpha: 0.85);
    position = Vector2.zero();
    l10n = AppLocalizations(locale);

    _restartButtonRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.75),
      width: 200,
      height: 50,
    );

    _exitButtonRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.85),
      width: 200,
      height: 50,
    );
  }

  @override
  void onMount() {
    super.onMount();
    gameRef.paused = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final isKo = locale.languageCode == 'ko';

    // Game Over Title
    _drawText(canvas, l10n.gameOver, size.y * 0.15, fontSize: 48, color: Colors.redAccent, isBold: true);

    // Wave Reached
    _drawText(canvas, '${isKo ? '도달 웨이브' : 'Wave Reached'}: $waveReached', size.y * 0.3, fontSize: 24);

    // Score
    _drawText(canvas, l10n.score(gameScore), size.y * 0.37, fontSize: 20);

    // --- 차등 보상 표시 ---
    final goldReward = waveReached * 50; 
    final expReward = waveReached * 20;  

    final rewardBoxRect = Rect.fromCenter(center: Offset(size.x / 2, size.y * 0.52), width: 260, height: 100);
    canvas.drawRRect(RRect.fromRectAndRadius(rewardBoxRect, const Radius.circular(12)), Paint()..color = Colors.white.withValues(alpha: 0.1));
    
    _drawText(canvas, isKo ? '- 획득 보상 -' : '- REWARDS -', size.y * 0.48, fontSize: 16, color: Colors.amberAccent);
    _drawText(canvas, 'Gold: +$goldReward', size.y * 0.53, fontSize: 18, color: Colors.yellow);
    _drawText(canvas, 'EXP: +$expReward', size.y * 0.57, fontSize: 18, color: Colors.lightBlueAccent);

    // --- Render Buttons ---
    _renderButton(canvas, _restartButtonRect, l10n.restartGame);
    if (onExit != null) {
      _renderButton(canvas, _exitButtonRect, l10n.returnToMenu);
    }
  }

  void _drawText(Canvas canvas, String text, double y, {double fontSize = 20, Color color = Colors.white, bool isBold = false}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    painter.paint(canvas, Offset((size.x - painter.width) / 2, y));
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
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition.toOffset();
    
    if (_restartButtonRect.contains(tapPosition)) {
      gameRef.paused = false;
      onRestart();
    }
    
    if (onExit != null && _exitButtonRect.contains(tapPosition)) {
      gameRef.paused = false;
      onExit?.call();
    }
  }
}
