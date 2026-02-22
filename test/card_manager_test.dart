import 'dart:convert';
import 'dart:io';

import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/game/card_manager.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:flame/game.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/player/player_data_manager.dart';

// Mock classes
class MockPlayerDataManager extends PlayerDataManager {
  MockPlayerDataManager({required super.eventBus});
}

class MockOverflowDefenseGame extends OverflowDefenseGame {
  MockOverflowDefenseGame(
      {required PlayerDataManager playerDataManager, required EventBus eventBus})
      : super(
            soundEnabled: false,
            playerDataManager: playerDataManager,
            eventBus: eventBus);

  @override
  Future<void> onLoad() async {
    gameStats = GameStats.instance;
    final file = File('assets/data/cards.json');
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonList = json.decode(jsonString);
    gameStats.cards.addAll(
      jsonList.map((json) => CardDefinition.fromJson(json)).toList(),
    );
    await super.onLoad();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CardManager', () {
    late CardManager cardManager;
    late MockOverflowDefenseGame mockGame;
    late EventBus eventBus;
    late MockPlayerDataManager mockPlayerDataManager;

    setUp(() async {
      await GameStats.initialize();
      eventBus = EventBus();
      mockPlayerDataManager = MockPlayerDataManager(eventBus: eventBus);
      mockGame = MockOverflowDefenseGame(
        playerDataManager: mockPlayerDataManager,
        eventBus: eventBus,
      );
      cardManager = CardManager(eventBus: eventBus);
      final flameGame = FlameGame();
      flameGame.add(mockGame);
      await mockGame.add(cardManager);
      await flameGame.ready();
    });

    testWithGame<MockOverflowDefenseGame>(
      'Deck is initialized with cards',
      () => mockGame,
      (game) async {
        expect(cardManager.cardDeck.length, greaterThan(0));
        expect(cardManager.cardDeck.length, game.gameStats.cards.length);
      },
    );

    testWithGame<MockOverflowDefenseGame>(
      'drawHand returns 3 unique cards',
      () => mockGame,
      (game) async {
        final hand = cardManager.drawHand();
        expect(hand.length, 3);

        final cardIds = hand.map((c) => c.cardId).toSet();
        expect(cardIds.length, 3);
      },
    );

    testWithGame<MockOverflowDefenseGame>(
        'weightedRandomDraw respects rank weights', () => mockGame, (game) async {
      final rankCounts = <CardRank, int>{};
      const drawCount = 10000;

      for (var i = 0; i < drawCount; i++) {
        final card = cardManager.weightedRandomDraw();
        rankCounts[card.rank] = (rankCounts[card.rank] ?? 0) + 1;
      }

      final totalWeight = cardManager.cardDeck
          .map((c) => cardManager.getRankWeight(c.rank))
          .reduce((a, b) => a + b);

      debugPrint('Total weight: $totalWeight');

      for (final rank in CardRank.values) {
        if (cardManager.cardDeck.any((card) => card.rank == rank)) {
          final totalRankWeight = cardManager.cardDeck
              .where((c) => c.rank == rank)
              .map((c) => cardManager.getRankWeight(c.rank))
              .reduce((a, b) => a + b);

          final expectedPercentage = totalRankWeight / totalWeight;
          final actualPercentage = (rankCounts[rank] ?? 0) / drawCount;

          debugPrint(
            'Rank: $rank, Expected: $expectedPercentage, Actual: $actualPercentage',
          );

          // Allow a tolerance for randomness
          expect(actualPercentage, closeTo(expectedPercentage, 0.1));
        }
      }
    });
  });
}
