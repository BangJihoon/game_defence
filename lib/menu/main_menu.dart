// lib/menu/main_menu.dart
//
// The visual component for the main menu screen.
// Responsibilities:
// - Rendering the game title, description, and "Start Game" button.
// - Handling touch interactions to start the game or toggle the language.
// - Rendering a simple language toggle button.

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class MainMenu extends RectangleComponent with HasGameRef, TapCallbacks {
  final VoidCallback onStartGame;
  final Locale locale;
  final VoidCallback onToggleLocale;
  late AppLocalizations l10n;

  MainMenu({
    required this.onStartGame,
    required this.locale,
    required this.onToggleLocale,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    position = Vector2.zero();
    paint = Paint()..color = Colors.transparent;
    l10n = AppLocalizations(locale);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 배경
    final bgPaint = Paint()..color = const Color(0xFF1a1a2e);
    canvas.drawRect(gameRef.size.toRect(), bgPaint);

    // 그라데이션 효과 (간단한 원형 그라데이션)
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF16213e).withOpacity(0.8),
          const Color(0xFF0f3460).withOpacity(0.4),
        ],
      ).createShader(gameRef.size.toRect());
    canvas.drawRect(gameRef.size.toRect(), gradientPaint);

    // 타이틀
    final titlePainter = TextPainter(
      text: TextSpan(
        text: l10n.gameTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.blue, blurRadius: 10, offset: Offset(2, 2)),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset((gameRef.size.x - titlePainter.width) / 2, gameRef.size.y * 0.25),
    );

    // 게임 시작 버튼
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 0.6),
      width: 200,
      height: 60,
    );

    // 버튼 배경
    final buttonPaint = Paint()
      ..color = const Color(0xFF4a90e2)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(10)),
      buttonPaint,
    );

    // 버튼 테두리
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, const Radius.circular(10)),
      borderPaint,
    );

    // 버튼 텍스트
    final buttonTextPainter = TextPainter(
      text: TextSpan(
        text: l10n.startGame,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    buttonTextPainter.layout();
    buttonTextPainter.paint(
      canvas,
      Offset(
        buttonRect.center.dx - buttonTextPainter.width / 2,
        buttonRect.center.dy - buttonTextPainter.height / 2,
      ),
    );

    // 설명 텍스트
    final descPainter = TextPainter(
      text: TextSpan(
        text: l10n.gameDescription,
        style: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    );

    // 언어 전환 버튼 (우측 상단)
    final langButtonRect = Rect.fromLTWH(gameRef.size.x - 80, 20, 60, 30);
    final langButtonPaint = Paint()
      ..color = Colors.grey.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(langButtonRect, const Radius.circular(5)),
      langButtonPaint,
    );
    final langTextPainter = TextPainter(
      text: TextSpan(
        text: locale.languageCode.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    langTextPainter.layout();
    langTextPainter.paint(
      canvas,
      Offset(
        langButtonRect.center.dx - langTextPainter.width / 2,
        langButtonRect.center.dy - langTextPainter.height / 2,
      ),
    );
    descPainter.layout();
    descPainter.paint(
      canvas,
      Offset((gameRef.size.x - descPainter.width) / 2, gameRef.size.y * 0.75),
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    final tapPos = event.localPosition;
    final buttonRect = Rect.fromCenter(
      center: Offset(gameRef.size.x / 2, gameRef.size.y * 0.6),
      width: 200,
      height: 60,
    );
    final langButtonRect = Rect.fromLTWH(gameRef.size.x - 80, 20, 60, 30);

    if (langButtonRect.contains(Offset(tapPos.x, tapPos.y))) {
      onToggleLocale();
      l10n = AppLocalizations(locale);
      return true;
    }

    if (buttonRect.contains(Offset(tapPos.x, tapPos.y))) {
      onStartGame();
      return true;
    }
    return false;
  }
}
