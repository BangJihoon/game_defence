import 'dart:convert';
import 'dart:io';

import 'package:flame_test/flame_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/game/card_manager.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:flame/game.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/player/player_data_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EventBus eventBus;
  late PlayerDataManager playerDataManager;
  late GameStats gameStats;

  setUp(() {
    eventBus = EventBus();

    final cardsJson = [
      {
        "cardId": "test_normal",
        "rank": "normal",
        "type": "stat",
        "titleLocaleKey": "title",
        "descriptionLocaleKey": "desc",
        "effect": {"type": "attack_power_up", "value": 0.1}
      },
      {
        "cardId": "test_bronze",
        "rank": "bronze",
        "type": "stat",
        "titleLocaleKey": "title",
        "descriptionLocaleKey": "desc",
        "effect": {"type": "attack_power_up", "value": 0.2}
      },
      {
        "cardId": "test_silver",
        "rank": "silver",
        "type": "stat",
        "titleLocaleKey": "title",
        "descriptionLocaleKey": "desc",
        "effect": {"type": "attack_power_up", "value": 0.3}
      },
      {
        "cardId": "test_gold",
        "rank": "gold",
        "type": "stat",
        "titleLocaleKey": "title",
        "descriptionLocaleKey": "desc",
        "effect": {"type": "attack_power_up", "value": 0.4}
      },
    ];
    final loadedCards = cardsJson.map((j) => CardDefinition.fromJson(j)).toList();

    gameStats = GameStats.forTest(cards: loadedCards);
    GameStats.instance = gameStats;

    playerDataManager = PlayerDataManager(eventBus: eventBus);
  });

  group('CardManager', () {
    testWithGame<OverflowDefenseGame>(
      'Deck is initialized with cards',
      () => OverflowDefenseGame(
        playerDataManager: playerDataManager,
        eventBus: eventBus,
        soundEnabled: false,
      ),
      (game) async {
        // CardManager is added in OverflowDefenseGame.onLoad
        // Wait for it to be added and loaded
        await game.ready();
        final cardManager = game.children.whereType<CardManager>().first;
        
        expect(cardManager.cardDeck.length, greaterThan(0));
        expect(cardManager.cardDeck.length, game.gameStats.cards.length);
      },
    );

    testWithGame<OverflowDefenseGame>(
      'drawHand returns unique cards',
      () => OverflowDefenseGame(
        playerDataManager: playerDataManager,
        eventBus: eventBus,
        soundEnabled: false,
      ),
      (game) async {
        await game.ready();
        final cardManager = game.children.whereType<CardManager>().first;

        final hand = cardManager.drawHand();
        expect(hand.length, 3);

        final cardIds = hand.map((c) => c.cardId).toSet();
        expect(cardIds.length, hand.length);
      },
    );

    testWithGame<OverflowDefenseGame>(
      'weightedRandomDraw respects rank weights',
      () => OverflowDefenseGame(
        playerDataManager: playerDataManager,
        eventBus: eventBus,
        soundEnabled: false,
      ),
      (game) async {
        await game.ready();
        final cardManager = game.children.whereType<CardManager>().first;

        final rankCounts = <CardRank, int>{};
        const drawCount = 500; 

        for (var i = 0; i < drawCount; i++) {
          final card = cardManager.weightedRandomDraw();
          rankCounts[card.rank] = (rankCounts[card.rank] ?? 0) + 1;
        }

        final totalWeight = cardManager.cardDeck
            .map((c) => cardManager.getRankWeight(c.rank))
            .reduce((a, b) => a + b);

        for (final rank in CardRank.values) {
          if (cardManager.cardDeck.any((card) => card.rank == rank)) {
            final totalRankWeight = cardManager.cardDeck
                .where((c) => c.rank == rank)
                .map((c) => cardManager.getRankWeight(c.rank))
                .fold(0.0, (a, b) => a + b);

            final expectedPercentage = totalRankWeight / totalWeight;
            final actualPercentage = (rankCounts[rank] ?? 0) / drawCount;

            expect(actualPercentage, closeTo(expectedPercentage, 0.2));
          }
        }
      },
    );
  });
}
