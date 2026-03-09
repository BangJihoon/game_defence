// lib/game/ui/card_selection_overlay.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class CardSelectionOverlay extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final List<CardDefinition> cards;
  final AppLocalizations l10n;
  final bool isSpecial; // 보스 클리어용 스페셜 오퍼

  CardSelectionOverlay({
    required this.cards, 
    required this.l10n,
    this.isSpecial = false,
  }) : super(priority: 500);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;

    // 1. 배경 연출 (스페셜일 때 황금빛 효과 추가)
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = isSpecial 
        ? Colors.amber.withValues(alpha: 0.2) 
        : Colors.black.withValues(alpha: 0.8),
    ));
    
    if (isSpecial) {
      // 황금빛 파티클 효과 같은 걸 추가하면 좋음 (생략)
    }

    // 2. 타이틀 (중앙 정렬)
    add(TextComponent(
      text: isSpecial ? '✨ 보스 클리어: 신비로운 제안 ✨' : '신의 신탁 (Divine Oracle)',
      textRenderer: TextPaint(
        style: TextStyle(
          color: isSpecial ? Colors.yellowAccent : Colors.amberAccent,
          fontSize: isSpecial ? 28 : 24,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: isSpecial ? Colors.orange : Colors.black, blurRadius: 15)],
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.2),
    ));

    // 3. 석판 배치 (세로 정렬 및 중앙 집중)
    final double tabletWidth = size.x * 0.7;
    final double tabletHeight = 100;
    final double spacing = 15;
    
    for (int i = 0; i < cards.length; i++) {
      add(OracleTablet(
        card: cards[i],
        l10n: l10n,
        isFree: isSpecial, // 스페셜 오퍼는 무료
        size: Vector2(tabletWidth, tabletHeight),
        position: Vector2(size.x / 2, size.y * 0.4 + (i * (tabletHeight + spacing))),
      ));
    }
  }

  @override
  void onMount() {
    super.onMount();
    gameRef.paused = true;
  }
}

class OracleTablet extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final CardDefinition card;
  final AppLocalizations l10n;
  final bool isFree;

  OracleTablet({
    required this.card, 
    required this.l10n, 
    required Vector2 size, 
    required Vector2 position,
    this.isFree = false,
  }) : super(size: size, position: position, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final RRect rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(15));
    
    // 배경
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.black87, _getRankColor(card.rank).withValues(alpha: 0.3)],
      ).createShader(size.toRect());
    canvas.drawRRect(rrect, paint);
    
    // 테두리
    canvas.drawRRect(rrect, Paint()
      ..color = _getRankColor(card.rank).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }

  @override
  Future<void> onLoad() async {
    // 등급 아이콘/룬 (좌측)
    add(TextComponent(
      text: 'ᛟ', 
      textRenderer: TextPaint(style: TextStyle(color: _getRankColor(card.rank), fontSize: 30)),
      anchor: Anchor.centerLeft,
      position: Vector2(20, size.y / 2),
    ));

    // 텍스트 정보 (중앙)
    add(TextComponent(
      text: l10n.translate(card.titleLocaleKey),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      anchor: Anchor.centerLeft,
      position: Vector2(60, size.y * 0.3),
    ));

    add(TextComponent(
      text: l10n.translate(card.descriptionLocaleKey),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white54, fontSize: 11)),
      anchor: Anchor.centerLeft,
      position: Vector2(60, size.y * 0.7),
    ));

    // "무료" 또는 "선택" 표시 (우측)
    if (isFree) {
      add(TextComponent(
        text: 'FREE',
        textRenderer: TextPaint(style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
        anchor: Anchor.centerRight,
        position: Vector2(size.x - 20, size.y / 2),
      ));
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.selectCard(card);
    gameRef.paused = false;
    (parent as CardSelectionOverlay).removeFromParent();
  }

  Color _getRankColor(CardRank rank) {
    switch (rank) {
      case CardRank.normal: return Colors.white38;
      case CardRank.bronze: return Colors.orange;
      case CardRank.silver: return Colors.blueGrey;
      case CardRank.gold: return Colors.amber;
      case CardRank.platinum: return Colors.cyanAccent;
      case CardRank.diamond: return Colors.lightBlueAccent;
      case CardRank.master: return Colors.purpleAccent;
    }
  }
}
