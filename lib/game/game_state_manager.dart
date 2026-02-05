// lib/game/game_state_manager.dart
//
// Manages the global mutable state of the game session.
// This component tracks:
// - Current game score (`gameScore`)
// - Currency for drawing cards (`cardPoints`) and its escalating cost (`cardDrawCost`)
// - Number of rerolls available (`rerolls`)
// - Game over status (`isGameOver`)
// It listens to game events to update these states and fires change events to notify the UI.

import 'package:flame/components.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class GameStateManager extends Component {
  final EventBus _eventBus;

  int _gameScore = 0;
  int _cardPoints = 50;
  int _cardDrawCost = 10;
  int _rerolls = 1;
  bool _isGameOver = false;

  int get gameScore => _gameScore;
  int get cardPoints => _cardPoints;
  int get cardDrawCost => _cardDrawCost;
  int get rerolls => _rerolls;
  bool get isGameOver => _isGameOver;

  GameStateManager({required EventBus eventBus}) : _eventBus = eventBus {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventBus.on<EnemyKilledEvent>((event) {
      _eventBus.fire(CoinGainAttemptedEvent(event.scoreValue)); // Signal to check if coin gain is disabled
    });

    _eventBus.on<RerollsGainedEvent>((event) {
      _rerolls += event.amount;
      _eventBus.fire(RerollsChangedEvent(_rerolls));
      debugPrint("GameStateManager: Rerolls updated to $_rerolls");
    });
  }

  void addGameScore(int amount) {
    _gameScore += amount;
    _eventBus.fire(GameScoreChangedEvent(_gameScore));
  }

  void addCardPoints(int amount) {
    _cardPoints += amount;
    _eventBus.fire(CardPointsChangedEvent(_cardPoints));
  }

  void deductCardPoints(int amount) {
    if (_cardPoints >= amount) {
      _cardPoints -= amount;
      _eventBus.fire(CardPointsChangedEvent(_cardPoints));
      debugPrint("GameStateManager: Card points deducted by $amount, remaining $_cardPoints");
    } else {
      debugPrint("GameStateManager: Attempted to deduct $amount card points, but only $_cardPoints available.");
    }
  }

  void updateCardDrawCost(int newCost) {
    _cardDrawCost = newCost;
    _eventBus.fire(CardDrawCostChangedEvent(_cardDrawCost));
    debugPrint("GameStateManager: Card draw cost updated to $_cardDrawCost");
  }

  void setGameOver(bool value) {
    if (_isGameOver != value) {
      _isGameOver = value;
      _eventBus.fire(GameOverChangedEvent(_isGameOver));
      debugPrint("GameStateManager: Game Over set to $_isGameOver");
    }
  }

  void resetGameState() {
    _gameScore = 0;
    _cardPoints = 50;
    _cardDrawCost = 10;
    _rerolls = 1;
    _isGameOver = false;
    _eventBus.fire(GameScoreChangedEvent(_gameScore));
    _eventBus.fire(CardPointsChangedEvent(_cardPoints));
    _eventBus.fire(CardDrawCostChangedEvent(_cardDrawCost));
    _eventBus.fire(RerollsChangedEvent(_rerolls));
    _eventBus.fire(GameOverChangedEvent(_isGameOver));
    _eventBus.fire(GameStateResetEvent());
    debugPrint("GameStateManager: Game state reset.");
  }
}
