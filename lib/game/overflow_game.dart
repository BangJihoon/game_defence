import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/components.dart'; // Added
import 'package:flame/effects.dart'
    show SequenceEffect, OpacityEffect, EffectController, RemoveEffect;

import 'player_base.dart';
import 'enemy_system.dart';
import 'input/tap_input_layer.dart';
import 'ui/game_over_overlay.dart';
import 'ui/score_display.dart';
import 'ui/skill_ui.dart';
import 'skills/skill_system.dart';
import 'background.dart';
import '../../config/game_config.dart';
import 'ui/wave_display.dart';
import 'card_manager.dart';
import 'ui/draw_card_button.dart';
import 'ui/card_selection_overlay.dart';
import 'package:game_defence/data/card_data.dart';
import 'modifier_manager.dart';
import 'package:game_defence/game/ui/attack_power_display.dart';
import 'wave_manager.dart'; // Import ModifierManager

class OverflowDefenseGame extends FlameGame with HasCollisionDetection {
  late PlayerBase playerBase;
  late EnemySystem enemySystem;
  late TapInputLayer tapInputLayer;
  late ScoreDisplay scoreDisplay;
  late SkillSystem skillSystem;
  late SkillUI skillUI;
  late WaveManager waveManager;
  late WaveDisplay waveDisplay;
  late CardManager cardManager;
  late DrawCardButton drawCardButton;
  late ModifierManager modifierManager; // Add ModifierManager instance
  late AttackPowerDisplay attackPowerDisplay;

  final Random _random = Random();
  final Locale locale;
  late GameStats gameStats;

  bool _isGameOver = false;
  int _score = 0;
  int _cardPoints = 50;
  int _cardDrawCost = 10;
  bool _soundEnabled;

  bool get isGameOver => _isGameOver;
  int get score => _score;
  int get cardPoints => _cardPoints;
  int get cardDrawCost => _cardDrawCost;
  Random get random => _random;

  OverflowDefenseGame({
    this.locale = const Locale('ko'),
    bool soundEnabled = true,
  }) : _soundEnabled = soundEnabled;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameStats = await GameStats.load();

    if (_soundEnabled) {
      _initializeSounds();
    }

    modifierManager = ModifierManager(); // Initialize ModifierManager

    playerBase =
        PlayerBase(hp: gameStats.baseHP, height: gameStats.baseSize.height)
          ..position = Vector2(0, size.y - gameStats.baseSize.height)
          ..onDestroyed = _onBaseDestroyed
          ..onHit = playBaseHitSound;

    enemySystem = EnemySystem(
      playerBase,
      gameStats.enemyDefinitions,
      onEnemyKilled: _onEnemyKilled,
    );

    tapInputLayer = TapInputLayer();

    scoreDisplay = ScoreDisplay(locale: locale);

    skillSystem = SkillSystem(
      locale: locale,
      gameStats: gameStats,
      skillDefinitions: gameStats.skillDefinitions,
    );

    skillUI = SkillUI(skillSystem, locale: locale, gameStats: gameStats);

    waveManager = WaveManager();

    waveDisplay = WaveDisplay(locale: locale);

    cardManager = CardManager();
    drawCardButton = DrawCardButton();
    attackPowerDisplay = AttackPowerDisplay();

    addAll([
      GameBackground(),
      playerBase,
      enemySystem,
      tapInputLayer,
      skillSystem,
      waveManager,
      modifierManager,
      scoreDisplay,
      waveDisplay,
      skillUI,
      drawCardButton,
      attackPowerDisplay,
    ]);
  }

  void showCardSelection() {
    if (paused) return; // Don't show if already paused

    if (_cardPoints >= _cardDrawCost) {
      print('Card draw clicked');
      _cardPoints -= _cardDrawCost;
      _cardDrawCost = (_cardDrawCost * 1.1).round();
      paused = true;
      final hand = cardManager.drawHand();
      print('Drawn cards: ${hand.map((c) => c.cardId).join(', ')}');
      if (hand.isNotEmpty) {
        add(CardSelectionOverlay(cards: hand));
      } else {
        paused = false; // Resume if no cards to show
      }
    } else {
      showMessage("카드 포인트 부족!");
    }
  }

  void selectCard(CardDefinition card) {
    print('Selected card: ${card.cardId}');
    cardManager.applyCard(card);

    // Remove the overlay
    remove(children.whereType<CardSelectionOverlay>().first);
    paused = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print("Game update loop active."); // For debugging

    if (_isGameOver) return;

    if (playerBase.hp <= 0 && !_isGameOver) {
      _gameOver();
    }
  }

  void _onEnemyKilled(int score) {
    if (modifierManager.isCoinGainDisabled) {
      print("Coin gain disabled. Skipping score update.");
      return;
    }

    _score += score;
    _cardPoints += 1;
    scoreDisplay.updateScore(_score);
    playEnemyDeathSound();
  }

  void _onBaseDestroyed() {
    if (!_isGameOver) {
      _gameOver();
    }
  }

  void _gameOver() {
    _isGameOver = true;
    playGameOverSound();
    add(
      GameOverOverlay(score: _score, onRestart: _restartGame, locale: locale),
    );
  }

  void _restartGame() {
    _isGameOver = false;
    _score = 0;
    removeAll(children.whereType<GameOverOverlay>());
    playerBase.hp = playerBase.maxHp.toDouble();
    enemySystem.clearEnemies();
    scoreDisplay.updateScore(0);
    waveManager.reset();
  }

  void showMessage(String message) {
    final wrapper = PositionComponent(
      anchor: Anchor.center,
      position: size / 2,
    );
    final textComponent = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
    );

    wrapper.add(textComponent);
    add(wrapper);

    wrapper.add(
      TimerComponent(
        period: 1.0,
        onTick: () {
          wrapper.add(
            OpacityEffect.fadeOut(
              EffectController(duration: 0.5),
              onComplete: () {
                wrapper.removeFromParent();
              },
            ),
          );
        },
        removeOnFinish: true,
      ),
    );
  }

  Future<void> _initializeSounds() async {
    try {
      await FlameAudio.audioCache.loadAll([
        'explosion.mp3',

        'enemy_death.mp3',

        'base_hit.mp3',

        'game_over.mp3',
      ]);

      _soundEnabled = true;
    } catch (e) {
      _soundEnabled = false;

      debugPrint('Could not load sound files: $e');
    }
  }

  void playExplosionSound() {
    if (!_soundEnabled) return;

    try {
      FlameAudio.play('explosion.mp3', volume: 0.3).ignore();
    } catch (e) {
      // Ignore
    }
  }

  void playEnemyDeathSound() {
    if (!_soundEnabled) return;

    try {
      FlameAudio.play('enemy_death.mp3', volume: 0.2).ignore();
    } catch (e) {
      // Ignore
    }
  }

  void playBaseHitSound() {
    if (!_soundEnabled) return;

    try {
      FlameAudio.play('base_hit.mp3', volume: 0.4).ignore();
    } catch (e) {
      // Ignore
    }
  }

  void playGameOverSound() {
    if (!_soundEnabled) return;

    try {
      FlameAudio.play('game_over.mp3', volume: 0.5).ignore();
    } catch (e) {
      // Ignore
    }
  }
}
