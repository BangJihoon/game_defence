import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/l10n/app_localizations.dart';

/// This overlay component pauses the game and displays a selection of cards for the player to choose from.
/// It covers the entire screen with a semi-transparent background.
class CardSelectionOverlay extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final List<CardDefinition> cards;
  final AppLocalizations l10n;
  late TimerComponent _autoSelectTimer;

  CardSelectionOverlay({required this.cards, required this.l10n}) : super(priority: 200);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = game.size; // Cover the whole screen
    
    // For debugging: Automatically selects the first card if the player doesn't choose within a time limit.
    _autoSelectTimer = TimerComponent(
      period: 10, // Increased to 10 seconds to allow for manual testing
      onTick: () {
        if (cards.isNotEmpty) {
          game.selectCard(cards.first); // Select the first card by default
        }
      },
      removeOnFinish: true,
    );
    add(_autoSelectTimer);

    // This loop creates and positions the visual display for each card.
    final cardWidth = size.x / 4;
    final cardHeight = size.y / 2;
    final spacing = (size.x - (3 * cardWidth)) / 4;

    for (int i = 0; i < cards.length; i++) {
      add(
        CardDisplay(
          card: cards[i],
          l10n: l10n, // Pass down the localization instance
          position: Vector2(spacing * (i + 1) + cardWidth * i, size.y / 4),
          size: Vector2(cardWidth, cardHeight),
        ),
      );
    }
  }

  /// This render method provides the dark, semi-transparent background for the overlay.
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      size.toRect(),
      Paint()..color = Colors.black.withOpacity(0.7),
    );
  }
}

/// This component represents a single card visually on the screen.
/// It handles rendering the card's details and processing tap events.
class CardDisplay extends PositionComponent
    with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final CardDefinition card;
  final AppLocalizations l10n; // Use the passed-in localization instance

  CardDisplay({
    required this.card,
    required this.l10n,
    required Vector2 position,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
  }

  /// When a card is tapped, this method calls the main game's `selectCard` function.
  @override
  void onTapUp(TapUpEvent event) {
    // Also stop the auto-select timer on the parent overlay
    final parentOverlay = parent as CardSelectionOverlay?;
    parentOverlay?._autoSelectTimer.timer.stop();
    
    game.selectCard(card);
  }

  /// This render method draws the card's background, title, and description.
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = _getColorForRank(card.rank);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)),
      paint,
    );

    // Card Title
    TextPainter(
        text: TextSpan(
          text: l10n.translate(card.titleLocaleKey), // Use the passed-in l10n
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
      ..layout(maxWidth: size.x - 20)
      ..paint(canvas, Offset(10, 20));

    // Card Description
    TextPainter(
        text: TextSpan(
          text: l10n.translate(card.descriptionLocaleKey), // Use the passed-in l10n
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
      ..layout(maxWidth: size.x - 20)
      ..paint(canvas, Offset(10, 80));
  }

  /// This is a helper function to determine the card's color based on its rarity (rank).
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
