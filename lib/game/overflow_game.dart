import 'package:game_defence/player/player_data_manager.dart'; // Import PlayerDataManager
import 'package:game_defence/data/character_data.dart'; // Import masterCharacterList
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/components.dart'; // Added
import 'package:flame/effects.dart'
    show SequenceEffect, OpacityEffect, EffectController, RemoveEffect, MoveByEffect;

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
import 'wave_manager.dart';
import 'package:game_defence/game/events/event_bus.dart'; // Import EventBus
import 'package:game_defence/game/events/game_events.dart'; // Import GameEvent
import 'package:game_defence/game/game_state_manager.dart'; // Import GameStateManager

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
  late EventBus eventBus; // Declare EventBus
  late GameStateManager gameStateManager; // Declare GameStateManager

  final Random _random = Random();
  final Locale locale;
  late GameStats gameStats;
  final PlayerDataManager _playerDataManager; // Declare PlayerDataManager

  bool _soundEnabled;

  bool get isGameOver => gameStateManager.isGameOver;
  int get score => gameStateManager.score;
  int get cardPoints => gameStateManager.cardPoints;
  int get cardDrawCost => gameStateManager.cardDrawCost;
  int get rerolls => gameStateManager.rerolls;
  Random get random => _random;

  OverflowDefenseGame({
    this.locale = const Locale('ko'),
    bool soundEnabled = true,
    required PlayerDataManager playerDataManager, // Require PlayerDataManager
  }) : _soundEnabled = soundEnabled,
       _playerDataManager = playerDataManager;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameStats = GameStats.instance; // Use singleton instance
    eventBus = EventBus(); // Initialize EventBus
    gameStateManager = GameStateManager(eventBus: eventBus); // Initialize GameStateManager

    if (_soundEnabled) {
      _initializeSounds();
    }

    modifierManager = ModifierManager(); // Initialize ModifierManager

    // Get the active character's stats
    final activeCharacterId = _playerDataManager.playerData.activeCharacterId;
    final activeCharacter = masterCharacterList.firstWhere(
            (c) => c.id == activeCharacterId,
        orElse: () => masterCharacterList.first // Default to the first character if not found
    );

    playerBase =
    PlayerBase(hp: activeCharacter.baseHp, height: gameStats.baseSize.height)
      ..position = Vector2(0, size.y - gameStats.baseSize.height)
      ..onDestroyed = _onBaseDestroyed
      ..onHit = playBaseHitSound;

    enemySystem = EnemySystem(
      playerBase,
      gameStats.enemyDefinitions,
      eventBus: eventBus, // Pass eventBus
    );

    tapInputLayer = TapInputLayer();

    scoreDisplay = ScoreDisplay(locale: locale);

    skillSystem = SkillSystem(
      locale: locale,
      gameStats: gameStats,
      skillDefinitions: gameStats.skillDefinitions,
      playerSkills: _playerDataManager.playerData.ownedSkills, // Pass owned skills
    );

    skillUI = SkillUI(skillSystem, locale: locale, gameStats: gameStats);

    waveManager = WaveManager();

    waveDisplay = WaveDisplay(locale: locale);

    cardManager = CardManager(eventBus: eventBus);
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
      cardManager, // CardManager is a component
      drawCardButton,
      attackPowerDisplay,
      gameStateManager, // Add GameStateManager to component tree
    ]);

    // Listen for events
    eventBus.on<CoinGainAttemptedEvent>((event) {
      if (modifierManager.isCoinGainDisabled) {
        print("Coin gain disabled. Skipping score update.");
        return;
      }
      gameStateManager.addScore(event.scoreValue);
      gameStateManager.addCardPoints(1);
      playEnemyDeathSound();
    });

    eventBus.on<ScoreChangedEvent>((event) {
      scoreDisplay.updateScore(event.newScore);
    });

    eventBus.on<GameOverChangedEvent>((event) {
      if (event.isGameOver) {
        _gameOver();
      }
    });

    eventBus.on<GameStateResetEvent>((event) {
      _restartGame();
    });

    eventBus.on<StatModifierAppliedEvent>((event) {
      switch (event.target) {
        case 'global':
          modifierManager.applyGlobalModifier(event.stat, event.value);
          break;
        case 'wall':
          modifierManager.applyWallModifier(event.stat, event.value);
          break;
        case 'skill':
          if (event.skillId != null) {
            modifierManager.applySkillModifier(
                event.skillId!, event.stat, event.value);
          }
          break;
        default:
          debugPrint("Unhandled stat modifier target in listener: ${event.target}");
      }
    });

    eventBus.on<ShieldGainedEvent>((event) {
      playerBase.addShield(playerBase.maxHp * event.amount);
    });

    eventBus.on<WallHealedEvent>((event) {
      playerBase.hp =
          (playerBase.hp + (playerBase.maxHp * event.amount))
              .clamp(0, playerBase.maxHp)
              .toDouble();
      debugPrint("Healed wall for ${event.amount * 100}%");
    });

    eventBus.on<SkillVariantAppliedEvent>((event) {
      skillSystem.skills
          .firstWhere((skill) => skill.skillId == event.skillId)
          .applyVariant(event.variantId);
      debugPrint("Applying Skill Variant: ${event.skillId} with variant ${event.variantId}");
    });

    eventBus.on<SkillSlotUnlockedEvent>((event) {
      skillSystem.addRandomSkill();
      debugPrint("New skill slot unlocked!");
      // Potentially update UI here
    });

    eventBus.on<CoinGainDisabledEvent>((event) {
      modifierManager.disableCoinGain();
      debugPrint("Coin gain disabled!");
      // Potentially update UI here
    });

    eventBus.on<RiskAppliedEvent>((event) {
      debugPrint("Risk applied: ${event.riskDetails}");
      // Add a screen shake effect
      camera.viewfinder.add(
        SequenceEffect([
          MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
          MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.05)),
          MoveByEffect(Vector2(5, 5), EffectController(duration: 0.05)),
          MoveByEffect(Vector2(0, -5), EffectController(duration: 0.05)),
        ]),
      );
      // Play a curse sound
      playCurseSound();
    });
  }

  void showCardSelection() {
    if (paused) return; // Don't show if already paused

    if (cardPoints >= cardDrawCost) {
      print('Card draw clicked');
      playCardDrawSound(); // Play card draw sound
      gameStateManager.deductCardPoints(cardDrawCost);
      gameStateManager.updateCardDrawCost((cardDrawCost * 1.1).round());
      paused = true;
      final hand = cardManager.drawHand();
      print('Drawn cards: ${hand.map((c) => c.cardId).join(', ')}');
      if (hand.isNotEmpty) {
        add(CardSelectionOverlay(cards: hand, l10n: skillSystem.l10n));
      } else {
        paused = false; // Resume if no cards to show
      }
    } else {
      showMessage("카드 포인트 부족!");
    }
  }

  void selectCard(CardDefinition card) {
    print('Selected card: ${card.cardId}');
    playCardSelectSound(); // Play card select sound
    cardManager.applyCard(card);

    // Remove the overlay
    remove(children.whereType<CardSelectionOverlay>().first);
    paused = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    if (playerBase.hp <= 0 && !isGameOver) {
      gameStateManager.setGameOver(true);
    }
  }

  void _onBaseDestroyed() {
    if (!isGameOver) {
      gameStateManager.setGameOver(true);
    }
  }

  void _gameOver() {
    playGameOverSound();
    add(
      GameOverOverlay(score: score, onRestart: () => gameStateManager.resetGameState(), locale: locale),
    );
  }

  void _restartGame() {
    removeAll(children.whereType<GameOverOverlay>());
    playerBase.hp = playerBase.maxHp.toDouble();
    enemySystem.clearEnemies();
    // scoreDisplay.updateScore(0); // This is now handled by ScoreChangedEvent
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

  void playCurseSound() {
    if (!_soundEnabled) return;

    // TODO: Add a 'curse.mp3' sound file and uncomment below
    // try {
    //   FlameAudio.play('curse.mp3', volume: 0.4).ignore();
    // } catch (e) {
    //   // Ignore
    // }
  }

  void playCardDrawSound() {
    if (!_soundEnabled) return;

    // TODO: Add a 'card_draw.mp3' sound file and uncomment below
    // try {
    //   FlameAudio.play('card_draw.mp3', volume: 0.3).ignore();
    // } catch (e) {
    //   // Ignore
    // }
  }

  void playCardSelectSound() {
    if (!_soundEnabled) return;

    // TODO: Add a 'card_select.mp3' sound file and uncomment below
    // try {
    //   FlameAudio.play('card_select.mp3', volume: 0.3).ignore();
    // } catch (e) {
    //   // Ignore
    // }
  }

  @override
  void onRemove() {
    eventBus.dispose(); // Dispose the event bus
    super.onRemove();
  }
}




