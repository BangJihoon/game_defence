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

import 'package:game_defence/player/player_data_manager.dart';

// Mock classes
class MockPlayerDataManager extends PlayerDataManager {
  MockPlayerDataManager() : super();
}

class MockGameStats extends GameStats {
  MockGameStats() : super.empty() {
    final file = File('assets/data/cards.json');
    final jsonString = file.readAsStringSync();
    final List<dynamic> jsonList = json.decode(jsonString);
    cards.addAll(
      jsonList.map((json) => CardDefinition.fromJson(json)).toList(),
    );
  }
}

class MockOverflowDefenseGame extends OverflowDefenseGame {
  MockOverflowDefenseGame()
      : super(soundEnabled: false, playerDataManager: MockPlayerDataManager()) {
    gameStats = MockGameStats();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CardManager', () {
    final flameGame = FlameGame();
    late CardManager cardManager;
    late MockOverflowDefenseGame mockGame;

    setUp(() async {
      mockGame = MockOverflowDefenseGame();
      cardManager = CardManager();
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

    testWithGame<
      MockOverflowDefenseGame
    >('weightedRandomDraw respects rank weights', () => mockGame, (game) async {
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
