// lib/game/events/game_events.dart
abstract class GameEvent {}

class EnemyKilledEvent extends GameEvent {
  final int scoreValue;
  EnemyKilledEvent(this.scoreValue);
}

// Add other event types here as needed
class ShieldGainedEvent extends GameEvent {
  final double amount;
  ShieldGainedEvent(this.amount);
}

class StatModifierAppliedEvent extends GameEvent {
  final String target; // e.g., 'global', 'wall', 'skill'
  final String stat;   // e.g., 'damage', 'max_hp', 'cooldown'
  final double value;
  final String? skillId; // Required if target is 'skill'

  StatModifierAppliedEvent({
    required this.target,
    required this.stat,
    required this.value,
    this.skillId,
  });
}

class SkillVariantAppliedEvent extends GameEvent {
  final String skillId;
  final String variantId;
  SkillVariantAppliedEvent({required this.skillId, required this.variantId});
}

class WallHealedEvent extends GameEvent {
  final double amount;
  WallHealedEvent(this.amount);
}

class RerollsGainedEvent extends GameEvent {
  final int amount;
  RerollsGainedEvent(this.amount);
}

class SkillSlotUnlockedEvent extends GameEvent {}

class CoinGainDisabledEvent extends GameEvent {}

class RiskAppliedEvent extends GameEvent {
  final Map<String, dynamic> riskDetails;
  RiskAppliedEvent(this.riskDetails);
}

// New events for GameStateManager state changes
class ScoreChangedEvent extends GameEvent {
  final int newScore;
  ScoreChangedEvent(this.newScore);
}

class CardPointsChangedEvent extends GameEvent {
  final int newCardPoints;
  CardPointsChangedEvent(this.newCardPoints);
}

class CardDrawCostChangedEvent extends GameEvent {
  final int newCardDrawCost;
  CardDrawCostChangedEvent(this.newCardDrawCost);
}

class RerollsChangedEvent extends GameEvent {
  final int newRerolls;
  RerollsChangedEvent(this.newRerolls);
}

class GameOverChangedEvent extends GameEvent {
  final bool isGameOver;
  GameOverChangedEvent(this.isGameOver);
}

class GameStateResetEvent extends GameEvent {}

class EnemyKilledHandledEvent extends GameEvent {
  final int scoreValue;
  EnemyKilledHandledEvent(this.scoreValue);
}

class CoinGainAttemptedEvent extends GameEvent {
  final int scoreValue;
  CoinGainAttemptedEvent(this.scoreValue);
}
