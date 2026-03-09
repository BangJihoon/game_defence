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

  /// 기준 등급/타입을 먼저 정한 뒤, 해당 카테고리에서 3장을 뽑습니다.
  List<CardDefinition> drawHand() {
    if (!_isDeckInitialized || cardDeck.isEmpty) {
      return [];
    }

    // 1. 기준 카드를 하나 뽑아서 기준 카테고리를 결정 (기존 가중치 확률 적용)
    final baseCard = weightedRandomDraw();
    
    // 2. 기준 카드와 같은 랭크 또는 같은 타입(skillLevel)인 카드들을 필터링
    List<CardDefinition> pool;
    if (baseCard.type == CardType.skillLevel) {
      pool = cardDeck.where((c) => c.type == CardType.skillLevel).toList();
    } else {
      pool = cardDeck.where((c) => c.rank == baseCard.rank && c.type != CardType.skillLevel).toList();
    }

    // 만약 풀이 너무 작으면 (3장 미만) 전체 덱에서 기준 랭크만 필터링
    if (pool.length < 3) {
      pool = cardDeck.where((c) => c.rank == baseCard.rank).toList();
    }

    // 3. 필터링된 풀에서 3장 랜덤 선택 (중복 제거)
    final hand = <CardDefinition>{};
    final targetCount = min(3, pool.length);
    
    final poolCopy = List<CardDefinition>.from(pool);
    poolCopy.shuffle(_random);
    
    for (int i = 0; i < targetCount; i++) {
      hand.add(poolCopy[i]);
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
          value: (effect['value'] as num).toDouble(),
        ));
        break;
      case 'skill_modifier':
        _eventBus.fire(StatModifierAppliedEvent(
          target: 'skill',
          skillId: effect['skillId'],
          stat: effect['stat'],
          value: (effect['value'] as num).toDouble(),
        ));
        break;
      case 'apply_variant':
        _eventBus.fire(SkillVariantAppliedEvent(
          skillId: effect['skillId'],
          variantId: effect['variantId'],
        ));
        break;
      case 'instant_heal_wall_percent':
        _eventBus.fire(WallHealedEvent((effect['value'] as num).toDouble()));
        break;
      case 'add_shield_percent':
        _eventBus.fire(ShieldGainedEvent((effect['value'] as num).toDouble()));
        break;
      case 'gain_rerolls':
        _eventBus.fire(RerollsGainedEvent((effect['value'] as num).toInt()));
        break;
      case 'unlock_skill_slot':
        _eventBus.fire(SkillSlotUnlockedEvent());
        break;
      case 'level_up_skill':
        _eventBus.fire(LevelUpSkillEvent(effect['skillId']));
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
          value: -(risk['value'] as num).toDouble(), // Negative value for reduction
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
