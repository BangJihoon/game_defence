// lib/game/game_state_manager.dart
import 'package:flame/components.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:flutter/foundation.dart';

class GameStateManager extends Component {
  final EventBus _eventBus;

  int _gameScore = 0;
  int _faith = 50; // 신앙심 (기존 Card Points)
  int _oracleCost = 10; // 신탁 비용 (기존 Card Draw Cost)
  int _rerolls = 1;
  bool _isGameOver = false;

  int get gameScore => _gameScore;
  int get faith => _faith;
  int get oracleCost => _oracleCost;
  int get rerolls => _rerolls;
  bool get isGameOver => _isGameOver;

  // 호환성을 위한 게터 유지
  int get cardPoints => _faith;
  int get cardDrawCost => _oracleCost;

  GameStateManager({required EventBus eventBus}) : _eventBus = eventBus {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventBus.on<EnemyKilledEvent>((event) {
      _eventBus.fire(CoinGainAttemptedEvent(event.scoreValue));
    });

    _eventBus.on<RerollsGainedEvent>((event) {
      _rerolls += event.amount;
      _eventBus.fire(RerollsChangedEvent(_rerolls));
    });
  }

  void addGameScore(int amount) {
    _gameScore += amount;
    _eventBus.fire(GameScoreChangedEvent(_gameScore));
  }

  void addFaith(int amount) {
    _faith += amount;
    _eventBus.fire(CardPointsChangedEvent(_faith));
  }

  void addCardPoints(int amount) => addFaith(amount); // 호환성 유지

  void deductFaith(int amount) {
    if (_faith >= amount) {
      _faith -= amount;
      _eventBus.fire(CardPointsChangedEvent(_faith));
    }
  }

  void deductCardPoints(int amount) => deductFaith(amount); // 호환성 유지

  void updateOracleCost(int newCost) {
    _oracleCost = newCost;
    _eventBus.fire(CardDrawCostChangedEvent(_oracleCost));
  }

  void updateCardDrawCost(int newCost) => updateOracleCost(newCost); // 호환성 유지

  void setGameOver(bool value) {
    if (_isGameOver != value) {
      _isGameOver = value;
      _eventBus.fire(GameOverChangedEvent(_isGameOver));
    }
  }

  void resetGameState() {
    _gameScore = 0;
    _faith = 50;
    _oracleCost = 10;
    _rerolls = 1;
    _isGameOver = false;
    _eventBus.fire(GameScoreChangedEvent(_gameScore));
    _eventBus.fire(CardPointsChangedEvent(_faith));
    _eventBus.fire(CardDrawCostChangedEvent(_oracleCost));
    _eventBus.fire(RerollsChangedEvent(_rerolls));
    _eventBus.fire(GameOverChangedEvent(_isGameOver));
    _eventBus.fire(GameStateResetEvent());
  }
}
