import 'dart:math';

import 'package:flame/components.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:flutter/foundation.dart';
import 'package:game_defence/game/overflow_game.dart';

class CardManager extends Component with HasGameRef<OverflowDefenseGame> {
  final List<CardDefinition> cardDeck = [];
  final Random _random = Random();
  int rerolls = 1;
  bool _isDeckInitialized = false;

  CardManager() {
    // For now, add all cards from GameStats. In a real game, this might be
    // filtered by player level, unlocked cards, etc.
    // This is called before onLoad, so game.gameStats might not be fully loaded.
    // We need to defer this until game.gameStats is available.
  }

  void _initializeDeck() {
    cardDeck.addAll(game.gameStats.cards);
  }

  bool get isDeckInitialized => _isDeckInitialized;

  void addRerolls(int amount) {
    rerolls += amount;
    // Here you might want to update a UI element to show the new reroll count
    debugPrint("Rerolls remaining: $rerolls");
  }

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

    // This is where the logic from "Core Systems Implementation Plan" will go.
    // It will parse the card.effect map and dispatch actions.

    // Example dispatcher logic (to be built out)
    final effect = card.effect;
    final type = effect['type'];

    switch (type) {
      case 'add_modifier':
        // Apply a stat modifier to global stats, wall, or a specific skill
        _applyStatModifier(effect);
        break;
      case 'skill_modifier':
        // Apply a modifier to a specific skill
        _applySkillModifier(effect);
        break;
      case 'apply_variant':
        // Apply a skill variant
        _applySkillVariant(effect);
        break;
      case 'instant_heal_wall_percent':
        // Heal the wall
        _healWall(effect);
        break;
      case 'add_shield_percent':
        final double shieldPercent = effect['value'];
        game.playerBase.addShield(game.playerBase.maxHp * shieldPercent);
        break;
      case 'gain_rerolls':
        final int amount = effect['value'];
        addRerolls(amount);
        break;
      case 'unlock_skill_slot':
        game.skillSystem.addRandomSkill();
        break;
      case 'disable_coin_gain':
        game.modifierManager.disableCoinGain();
        break;
      // ... other cases for each effect type ...
      default:
        debugPrint("Unhandled card effect type: $type");
    }

    // Handle risks for cursed cards
    if (card.risk != null) {
      _applyRisk(card.risk!);
    }
  }

  void _applyStatModifier(Map<String, dynamic> effect) {
    final String target = effect['target'];
    final String stat = effect['stat'];
    final double value = effect['value'];

    switch (target) {
      case 'global':
        game.modifierManager.applyGlobalModifier(stat, value);
        break;
      case 'wall':
        game.modifierManager.applyWallModifier(stat, value);
        break;
      default:
        debugPrint("Unhandled stat modifier target: $target");
    }
  }

  void _applySkillModifier(Map<String, dynamic> effect) {
    final String skillId = effect['skillId'];
    final String stat = effect['stat'];
    final double value = effect['value'];
    game.modifierManager.applySkillModifier(skillId, stat, value);
  }

  void _applySkillVariant(Map<String, dynamic> effect) {
    final String skillId = effect['skillId'];
    final String variantId = effect['variantId'];
    game.skillSystem.skills
        .firstWhere((skill) => skill.skillId == skillId)
        .applyVariant(variantId);
    debugPrint("Applying Skill Variant: $skillId with variant $variantId");
  }

  void _healWall(Map<String, dynamic> effect) {
    final double healPercent = effect['value'];
    game.playerBase.hp =
        (game.playerBase.hp + (game.playerBase.maxHp * healPercent))
            .clamp(0, game.playerBase.maxHp)
            .toDouble();
    debugPrint("Healed wall for ${healPercent * 100}%");
  }

  void _applyRisk(Map<String, dynamic> risk) {
    final type = risk['type'];

    switch (type) {
      case 'reduce_modifier':
        _reduceStatModifier(risk);
        break;
      case 'disable_coin_gain':
        game.modifierManager.disableCoinGain();
        break;
      default:
        debugPrint("Unhandled risk type: $type");
    }
  }

  void _reduceStatModifier(Map<String, dynamic> effect) {
    final String target = effect['target'];
    final String stat = effect['stat'];
    final double value = effect['value'];

    // Negate the value for reduction
    _applyStatModifier({'target': target, 'stat': stat, 'value': -value});
  }
}
