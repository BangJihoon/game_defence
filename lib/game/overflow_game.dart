import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'player_base.dart';
import 'enemy.dart';
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
import 'wave_manager.dart'; // Import ModifierManager

class OverflowDefenseGame extends FlameGame {
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

  final Random _random = Random();
  final Locale locale;
  late GameStats gameStats;

  bool _isGameOver = false;
  int _score = 0;
  int _cardPoints = 50;
  int _cardDrawCost = 10;
  bool _soundEnabled = false;

  bool get isGameOver => _isGameOver;
  int get score => _score;
  int get cardPoints => _cardPoints;
  int get cardDrawCost => _cardDrawCost;
  Random get random => _random;

  OverflowDefenseGame({this.locale = const Locale('ko')});

      @override

      Future<void> onLoad() async {

        await super.onLoad();

    

        gameStats = await GameStats.load();

        

        _initializeSounds();

    

        modifierManager = ModifierManager(); // Initialize ModifierManager

    

        playerBase = PlayerBase(

          hp: gameStats.baseHP,

          height: gameStats.baseSize.height,

        )

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

            skillDefinitions: gameStats.skillDefinitions);

          

        skillUI = SkillUI(skillSystem, locale: locale, gameStats: gameStats);

        waveManager = WaveManager();

        waveDisplay = WaveDisplay(locale: locale);

        cardManager = CardManager();

        drawCardButton = DrawCardButton();

    

        add(GameBackground());

        add(playerBase);

        add(enemySystem);

        add(tapInputLayer);

        add(scoreDisplay);

        add(skillSystem);

        add(skillUI);

        add(waveManager);

        add(waveDisplay);

        add(cardManager);

        add(drawCardButton);

        add(modifierManager); // Add ModifierManager to the game

      }

    

        void showCardSelection() {

    

          if (paused) return; // Don't show if already paused

    

      

    

          if (_cardPoints >= _cardDrawCost) {

    

            _cardPoints -= _cardDrawCost;

    

            _cardDrawCost = (_cardDrawCost * 1.1).round();

    

      

    

            paused = true;

    

            final hand = cardManager.drawHand();

    

            if (hand.isNotEmpty) {

    

              add(CardSelectionOverlay(cards: hand));

    

            } else {

    

              paused = false; // Resume if no cards to show

    

            }

    

          } else {

    

            print("Not enough card points to draw a card.");

    

          }

    

        }

    

      void selectCard(CardDefinition card) {

        cardManager.applyCard(card);

        // Remove the overlay

        remove(children.whereType<CardSelectionOverlay>().first);

        paused = false;

      }

    

      @override

      void update(double dt) {

        super.update(dt);

    

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

        add(GameOverOverlay(

          score: _score,

          onRestart: _restartGame,

          locale: locale,

        ));

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

    

  

  