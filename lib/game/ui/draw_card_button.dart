
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class DrawCardButton extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  DrawCardButton() {
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(game.size.x / 2, game.size.y - 20);
    size = Vector2(120, 40);
    print('DrawCardButton position: $position, size: $size, gameSize: ${game.size}');
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.cardManager.isDeckInitialized) {
      game.showCardSelection();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final isEnabled = game.cardManager.isDeckInitialized;
    final paint = Paint()..color = isEnabled ? Colors.blue.withAlpha(200) : Colors.grey.withAlpha(150);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );

    TextPainter(
      text: TextSpan(
        text: 'Draw Card (${game.cardDrawCost})',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(size.x / 2 - 50, size.y / 2 - 18));

    TextPainter(
      text: TextSpan(
        text: 'CP: ${game.cardPoints}',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(size.x / 2 - 20, size.y / 2 + 5));
  }
}
