
// lib/game/ui/draw_card_button.dart
//
// A touchable UI component that allows the player to manually draw a card.
// Responsibilities:
// - Rendering the button with current cost and available card points.
// - Handling touch input to trigger the `showCardSelection` method in the game.
// - Visualizing the enabled/disabled state based on deck initialization.

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class DrawCardButton extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  late final TextComponent _labelComponent;
  late final TextComponent _costComponent;

  DrawCardButton() {
    anchor = Anchor.bottomCenter;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(140, 50); // 터치 영역 확대
    position = Vector2(game.size.x / 2, game.size.y - 20);

    // 텍스트 컴포넌트로 변경하여 성능 및 정렬 개선
    _labelComponent = TextComponent(
      text: 'Draw Card',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 - 8),
    );

    _costComponent = TextComponent(
      text: '', // update에서 갱신
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amberAccent,
          fontSize: 12,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 + 10),
    );

    add(_labelComponent);
    add(_costComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _costComponent.text = 'CP: ${game.cardPoints} / ${game.cardDrawCost}';
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (game.cardManager.isDeckInitialized && game.cardPoints >= game.cardDrawCost) {
      game.showCardSelection();
    } else {
      if (!game.cardManager.isDeckInitialized) debugPrint('[DrawCardButton] Deck not ready');
      if (game.cardPoints < game.cardDrawCost) debugPrint('[DrawCardButton] Not enough CP');
    }
  }

  @override
  void render(Canvas canvas) {
    final isDeckReady = game.cardManager.isDeckInitialized;
    final canAfford = game.cardPoints >= game.cardDrawCost;
    final isEnabled = isDeckReady && canAfford;

    final paint = Paint()..color = isEnabled ? Colors.blue.withAlpha(200) : Colors.grey.withAlpha(150);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)),
      paint,
    );
    
    // 자식 컴포넌트(텍스트)는 super.render에서 그려짐
    super.render(canvas);
  }
}
