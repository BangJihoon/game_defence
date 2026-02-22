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

  CardSelectionOverlay({required this.cards, required this.l10n}) : super(priority: 200);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = game.size; // Cover the whole screen

    // This loop creates and positions the visual display for each card.
    final cardWidth = 200.0;
    final cardHeight = 300.0;
    final gap = 20.0;
    
    // 화면 중앙 정렬 계산
    final totalWidth = (cardWidth * cards.length) + (gap * (cards.length - 1));
    final startX = (size.x - totalWidth) / 2 + cardWidth / 2;
    final centerY = size.y / 2;

    for (int i = 0; i < cards.length; i++) {
      add(
        CardDisplay(
          card: cards[i],
          l10n: l10n, // Pass down the localization instance
          position: Vector2(startX + i * (cardWidth + gap), centerY),
          size: Vector2(cardWidth, cardHeight),
        ),
      );
    }
  }

  @override
  void onMount() {
    super.onMount();
    // 컴포넌트가 게임 트리에 완전히 추가된(Mount) 직후에 게임을 멈춥니다.
    game.paused = true;
  }

  /// This render method provides the dark, semi-transparent background for the overlay.
  @override
  void render(Canvas canvas) {
    // 1. 배경을 먼저 그립니다.
    canvas.drawRect(
      size.toRect(),
      Paint()..color = Colors.black.withOpacity(0.7),
    );
    // 2. 그 위에 자식 컴포넌트(카드들)를 그립니다.
    super.render(canvas);
  }
}

/// This component represents a single card visually on the screen.
/// It handles rendering the card's details and processing tap events.
class CardDisplay extends PositionComponent with TapCallbacks, HoverCallbacks, HasGameRef<OverflowDefenseGame> {
  final CardDefinition card;
  final AppLocalizations l10n; // Use the passed-in localization instance

  CardDisplay({
    required this.card,
    required this.l10n,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  /// When a card is tapped, this method calls the main game's `selectCard` function.
  @override
  void onTapUp(TapUpEvent event) {
    game.selectCard(card);
  }

  @override
  void onHoverEnter() {
    scale = Vector2.all(1.05); // 마우스 오버 시 확대 효과
  }

  @override
  void onHoverExit() {
    scale = Vector2.all(1.0);
  }

  /// This render method draws the card's background, title, and description.
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = _getColorForRank(card.rank);
    
    // 카드 배경
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)),
      paint,
    );
    
    // 내부 컨텐츠 배경 (가독성 확보)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, 6, size.x - 12, size.y - 12),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF222222),
    );

    // Card Title
    TextPainter(
        text: TextSpan(
          text: l10n.translate(card.titleLocaleKey) ?? card.cardId.toUpperCase(),
          style: TextStyle(
            color: _getColorForRank(card.rank), // 등급 색상 적용
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
      ..layout(maxWidth: size.x - 20, minWidth: size.x - 20)
      ..paint(canvas, Offset(10, 20)); // 위치 조정

    // Card Description
    TextPainter(
        text: TextSpan(
          text: l10n.translate(card.descriptionLocaleKey) ?? card.effect.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
      ..layout(maxWidth: size.x - 20, minWidth: size.x - 20)
      ..paint(canvas, Offset(10, 60)); // 위치 조정
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
