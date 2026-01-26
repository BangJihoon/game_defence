
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/game/overflow_game.dart';

class CardSelectionOverlay extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final List<CardDefinition> cards;

  CardSelectionOverlay({required this.cards});

  @override
  Future<void> onLoad() async {
    size = game.size; // Cover the whole screen
    super.onLoad();
    // Add card components
    final cardWidth = size.x / 4;
    final cardHeight = size.y / 2;
    final spacing = (size.x - (3 * cardWidth)) / 4;

    for (int i = 0; i < cards.length; i++) {
      add(
        CardDisplay(
          card: cards[i],
          position: Vector2(spacing * (i + 1) + cardWidth * i, size.y / 4),
          size: Vector2(cardWidth, cardHeight),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Darken the background
    canvas.drawRect(size.toRect(), Paint()..color = Colors.black.withOpacity(0.7));
  }
}

class CardDisplay extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final CardDefinition card;

  CardDisplay({required this.card, required Vector2 position, required Vector2 size}) {
    this.position = position;
    this.size = size;
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.selectCard(card);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Simple card background
    final paint = Paint()..color = _getColorForRank(card.rank);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)),
      paint,
    );

    // Card Title
    TextPainter(
      text: TextSpan(
        text: card.titleLocaleKey, // In a real game, you'd use l10n here
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: size.x - 20)
      ..paint(canvas, Offset(10, 20));

    // Card Description
    TextPainter(
      text: TextSpan(
        text: card.descriptionLocaleKey, // In a real game, you'd use l10n here
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: size.x - 20)
      ..paint(canvas, Offset(10, 80));
  }

  Color _getColorForRank(CardRank rank) {
    switch (rank) {
      case CardRank.normal:
        return Colors.grey.shade700;
      case CardRank.bronze:
        return Colors.brown;
      case CardRank.silver:
        return Colors.blueGrey;
      case CardRank.gold:
        return Colors.amber.shade700;
      case CardRank.platinum:
        return Colors.teal;
      case CardRank.diamond:
        return Colors.lightBlue;
      case CardRank.master:
        return Colors.purple.shade700;
    }
  }
}
