// lib/game/card_manager.dart
//
// Manages the card system within the game.
// Responsibilities include:
// - Initializing the deck from game statistics.
// - Drawing a hand of random cards based on rarity weights.
// - Applying the specific effects (buffs, skill modifications) of chosen cards to the game state via events.

import 'dart:math';

import 'package:flame/components.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:flutter/foundation.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';

class CardManager extends Component with HasGameRef<OverflowDefenseGame> {
  final List<CardDefinition> cardDeck = [];
  final Random _random = Random();
  bool _isDeckInitialized = false;
  final EventBus _eventBus; // Declare EventBus

  CardManager({required EventBus eventBus}) : _eventBus = eventBus;

  void _initializeDeck() {
    cardDeck.addAll(game.gameStats.cards);
  }

  bool get isDeckInitialized => _isDeckInitialized;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initializeDeck();
    _isDeckInitialized = true;
  }

  /// Draws 3 unique cards to present as a choice to the player.
  List<CardDefinition> drawHand() {
    if (!_isDeckInitialized || cardDeck.isEmpty) {
      return [];
    }

    final hand = <CardDefinition>{}; // Use a Set to ensure unique cards
    while (hand.length < 3 && hand.length < cardDeck.length) {
      final card = weightedRandomDraw();
      hand.add(card);
    }

    return hand.toList();
  }

  @visibleForTesting
  CardDefinition weightedRandomDraw() {
    final totalWeight = cardDeck
        .map((card) => getRankWeight(card.rank))
        .reduce((a, b) => a + b);
    final randomValue = _random.nextDouble() * totalWeight;

    var cumulativeWeight = 0.0;
    for (final card in cardDeck) {
      cumulativeWeight += getRankWeight(card.rank);
      if (randomValue <= cumulativeWeight) {
        return card;
      }
    }

    // Fallback, should not be reached
    return cardDeck.last;
  }

  @visibleForTesting
  double getRankWeight(CardRank rank) {
    switch (rank) {
      case CardRank.normal:
        return 20.0;
      case CardRank.bronze:
        return 15.0;
      case CardRank.silver:
        return 10.0;
      case CardRank.gold:
        return 7.0;
      case CardRank.platinum:
        return 4.0;
      case CardRank.diamond:
        return 2.0;
      case CardRank.master:
        return 1.0;
    }
  }

  /// Applies the effect of the chosen card.
  /// This is the core of the game's progression system.
  void applyCard(CardDefinition card) {
    debugPrint("Applying card: ${card.cardId}");

    final effect = card.effect;
    final type = effect['type'];

    switch (type) {
      case 'add_modifier':
        _eventBus.fire(StatModifierAppliedEvent(
          target: effect['target'],
          stat: effect['stat'],
          value: effect['value'],
        ));
        break;
      case 'skill_modifier':
        _eventBus.fire(StatModifierAppliedEvent(
          target: 'skill',
          skillId: effect['skillId'],
          stat: effect['stat'],
          value: effect['value'],
        ));
        break;
      case 'apply_variant':
        _eventBus.fire(SkillVariantAppliedEvent(
          skillId: effect['skillId'],
          variantId: effect['variantId'],
        ));
        break;
      case 'instant_heal_wall_percent':
        _eventBus.fire(WallHealedEvent(effect['value']));
        break;
      case 'add_shield_percent':
        _eventBus.fire(ShieldGainedEvent(effect['value']));
        break;
      case 'gain_rerolls':
        _eventBus.fire(RerollsGainedEvent(effect['value']));
        break;
      case 'unlock_skill_slot':
        _eventBus.fire(SkillSlotUnlockedEvent());
        break;
      case 'disable_coin_gain':
        _eventBus.fire(CoinGainDisabledEvent());
        break;
      default:
        debugPrint("Unhandled card effect type: $type");
    }

    if (card.risk != null) {
      _applyRisk(card.risk!);
    }
  }

  void _applyRisk(Map<String, dynamic> risk) {
    final type = risk['type'];

    switch (type) {
      case 'reduce_modifier':
        _eventBus.fire(StatModifierAppliedEvent(
          target: risk['target'],
          stat: risk['stat'],
          value: -risk['value'], // Negative value for reduction
        ));
        break;
      case 'disable_coin_gain':
        _eventBus.fire(CoinGainDisabledEvent());
        break;
      default:
        debugPrint("Unhandled risk type: $type");
    }
    _eventBus.fire(RiskAppliedEvent(risk)); // Fire a generic risk event too
  }
}
