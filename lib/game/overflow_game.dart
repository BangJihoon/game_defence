import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/components.dart'; // Added
import 'package:flame/effects.dart'
    show
        SequenceEffect,
        OpacityEffect,
        EffectController,
        RemoveEffect,
        MoveByEffect;

import 'player_base.dart';
import 'enemy_system.dart';
import 'input/tap_input_layer.dart';
import 'ui/game_over_overlay.dart';
import 'ui/score_display.dart';
import 'ui/skill_ui.dart';
import 'skills/skill_system.dart';
import 'background.dart';
import '../../l10n/app_localizations.dart';
import '../../config/game_config.dart';
import 'ui/wave_display.dart';
import 'card_manager.dart';
import 'ui/draw_card_button.dart';
import 'ui/card_selection_overlay.dart';
import 'package:game_defence/data/card_data.dart';
import 'modifier_manager.dart';
import 'package:game_defence/game/ui/attack_power_display.dart';
import 'wave_manager.dart';
import 'package:game_defence/player/player_data_manager.dart';
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
  late GameStateManager gameStateManager; // Declare GameStateManager
  late TimerComponent _cardSelectionTimer;
  late AppLocalizations l10n;

  final Random _random = Random();
  final Locale locale;
  late GameStats gameStats;
  final VoidCallback? onExit;
  final PlayerDataManager playerDataManager;
  late final EventBus eventBus;

  bool _soundEnabled;

  bool get isGameOver => gameStateManager.isGameOver;
  int get gameScore => gameStateManager.gameScore;
  int get cardPoints => gameStateManager.cardPoints;
  int get cardDrawCost => gameStateManager.cardDrawCost;
  int get rerolls => gameStateManager.rerolls;
  Random get random => _random;

  OverflowDefenseGame({
    this.locale = const Locale('ko'),
    bool soundEnabled = true,
    this.onExit,
    required this.playerDataManager,
    required this.eventBus,
  }) : _soundEnabled = soundEnabled;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    l10n = AppLocalizations(locale);
    gameStats = GameStats.instance; // Use singleton instance
    gameStateManager = GameStateManager(
      eventBus: eventBus,
    ); // Initialize GameStateManager

    if (_soundEnabled) {
      _initializeSounds();
    }

    modifierManager = ModifierManager(); // Initialize ModifierManager

    // Get active character and apply stats
    final activeCharacterId = playerDataManager.playerData.activeCharacterId;
    final activeCharacter = masterCharacterList.firstWhere(
      (c) => c.id == activeCharacterId,
    );
    final totalHpBonus = 0; // playerDataManager.playerData.totalHpBonus;

    playerBase =
        PlayerBase(
            hp: activeCharacter.baseHp + totalHpBonus,
            height: gameStats.baseSize.height,
          )
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

    final totalAttackPower = playerDataManager.playerData.totalAttackPower;
    skillSystem = SkillSystem(
      locale: locale,
      gameStats: gameStats,
      skillDefinitions: gameStats.skillDefinitions,
      baseAttackPower: activeCharacter.baseAttack + totalAttackPower,
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
      gameStateManager.addGameScore(event.scoreValue);
      gameStateManager.addCardPoints(1);
      playEnemyDeathSound();
    });

    eventBus.on<GameScoreChangedEvent>((event) {
      scoreDisplay.updateScore(event.newGameScore);
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
              event.skillId!,
              event.stat,
              event.value,
            );
          }
          break;
        default:
          debugPrint(
            "Unhandled stat modifier target in listener: ${event.target}",
          );
      }
    });

    eventBus.on<ShieldGainedEvent>((event) {
      playerBase.addShield(playerBase.maxHp * event.amount);
    });

    eventBus.on<WallHealedEvent>((event) {
      playerBase.hp = (playerBase.hp + (playerBase.maxHp * event.amount))
          .clamp(0, playerBase.maxHp)
          .toDouble();
      debugPrint("Healed wall for ${event.amount * 100}%");
    });

    eventBus.on<SkillVariantAppliedEvent>((event) {
      skillSystem.skills
          .firstWhere((skill) => skill.skillId == event.skillId)
          .applyVariant(event.variantId);
      debugPrint(
        "Applying Skill Variant: ${event.skillId} with variant ${event.variantId}",
      );
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

    eventBus.on<WaveClearedEvent>((event) {
      debugPrint("Wave ${event.waveNumber} cleared! Showing card selection.");
      _showAutomaticCardSelection();
    });

    _cardSelectionTimer = TimerComponent(
      period: 30.0,
      repeat: true,
      onTick: _showAutomaticCardSelection,
    );
    add(_cardSelectionTimer);
  }

  void _showAutomaticCardSelection() {
    // 이미 오버레이가 떠있거나 일시정지 상태면 무시
    if (paused || children.whereType<CardSelectionOverlay>().isNotEmpty) return;

    playCardDrawSound();
    final hand = cardManager.drawHand();
    print('Drawn cards automatically: ${hand.map((c) => c.cardId).join(', ')}');
    if (hand.isNotEmpty) {
      add(CardSelectionOverlay(cards: hand, l10n: l10n));
    }
  }

  void showCardSelection() {
    debugPrint("--- Attempting to show card selection ---");
    try {
      // 이미 오버레이가 떠있거나 일시정지 상태면 무시
      if (paused || children.whereType<CardSelectionOverlay>().isNotEmpty) {
        debugPrint("[CARD DRAW] FAILED: Game is already paused or overlay exists.");
        return;
      }

      debugPrint(
        "[CARD DRAW] Current card points: $cardPoints, Cost: $cardDrawCost",
      );

      if (cardPoints >= cardDrawCost) {
        debugPrint("[CARD DRAW] SUCCESS: Sufficient card points. Proceeding.");
        playCardDrawSound();
        gameStateManager.deductCardPoints(cardDrawCost);
        gameStateManager.updateCardDrawCost((cardDrawCost * 1.1).round());

        final hand = cardManager.drawHand();
        debugPrint(
          '[CARD DRAW] Drawn cards: ${hand.map((c) => c.cardId).join(', ')}',
        );

        if (hand.isNotEmpty) {
          debugPrint("[CARD DRAW] Adding CardSelectionOverlay to the game.");
          add(CardSelectionOverlay(cards: hand, l10n: l10n));
        } else {
          debugPrint("[CARD DRAW] WARNING: Drew an empty hand.");
        }
      } else {
        debugPrint("[CARD DRAW] FAILED: Insufficient card points.");
        showMessage("카드 포인트 부족!");
      }
    } catch (e, st) {
      debugPrint("[CARD DRAW] CRITICAL ERROR in showCardSelection: $e\n$st");
      paused = false; // Attempt to resume game on error
    }
  }

  void selectCard(CardDefinition card) {
    debugPrint("--- Attempting to select card ---");
    try {
      debugPrint("[CARD SELECT] Selected card ID: ${card.cardId}");
      playCardSelectSound();
      cardManager.applyCard(card);

      final overlay = children.whereType<CardSelectionOverlay>().firstOrNull;
      if (overlay != null) {
        debugPrint("[CARD SELECT] Removing CardSelectionOverlay.");
        remove(overlay);
      } else {
        debugPrint(
          "[CARD SELECT] WARNING: CardSelectionOverlay not found to remove.",
        );
      }

      paused = false;
      debugPrint("[CARD SELECT] Game resumed.");
    } catch (e, st) {
      debugPrint("[CARD SELECT] CRITICAL ERROR in selectCard: $e\n$st");
      paused = false; // Attempt to resume game on error
    }
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
    _cardSelectionTimer.timer.pause();
    add(
      GameOverOverlay(
        gameScore: gameScore,
        onRestart: () => gameStateManager.resetGameState(),
        locale: locale,
        onExit: onExit,
      ),
    );
  }

  void _restartGame() {
    removeAll(children.whereType<GameOverOverlay>());
    playerBase.hp = playerBase.maxHp.toDouble();
    enemySystem.clearEnemies();
    // scoreDisplay.updateScore(0); // This is now handled by ScoreChangedEvent
    waveManager.reset();
    _cardSelectionTimer.timer.start();
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
