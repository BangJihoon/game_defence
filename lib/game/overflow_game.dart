// lib/game/overflow_game.dart
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'player_base.dart';
import 'enemy_system.dart';
import 'input/tap_input_layer.dart';
import 'ui/score_display.dart';
import 'skills/skill_system.dart';
import 'ui/wave_display.dart';
import 'wave_manager.dart';
import 'modifier_manager.dart';
import 'ui/attack_power_display.dart';
import 'ui/skill_ui.dart';
import 'card_manager.dart';
import 'ui/card_selection_overlay.dart';
import 'ui/game_over_overlay.dart';
import 'ui/draw_card_button.dart';
import 'ui/settings_overlay.dart'; // 추가
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:game_defence/game/game_state_manager.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:flame/events.dart';

import 'ui/victory_overlay.dart';
import 'components/altar_character.dart';
import 'enemy.dart'; // Add Enemy import
import 'effects/explosion_effect.dart'; // Add ExplosionEffect import

class OverflowDefenseGame extends FlameGame with HasCollisionDetection {
  late PlayerBase playerBase;
  late EnemySystem enemySystem;
  late TapInputLayer tapInputLayer;
  late ScoreDisplay scoreDisplay;
  late SkillSystem skillSystem;
  late WaveManager waveManager;
  late WaveDisplay waveDisplay;
  late SkillUI skillUI;
  late CardManager cardManager;
  late DrawCardButton drawCardButton;
  late ModifierManager modifierManager;
  late AttackPowerDisplay attackPowerDisplay;
  late GameStateManager gameStateManager;
  late AppLocalizations l10n;

  final List<AltarCharacterComponent> altarCharacters = [];
  final Random _random = Random();
  final Locale locale;
  late GameStats gameStats;
  final VoidCallback? onExit;
  final PlayerDataManager playerDataManager;
  late final EventBus eventBus;

  bool get _soundEnabled => playerDataManager.soundEnabled;

  bool get isGameOver => gameStateManager.isGameOver;
  int get gameScore => gameStateManager.gameScore;
  int get cardPoints => gameStateManager.cardPoints;
  int get cardDrawCost => gameStateManager.cardDrawCost;
  int get rerolls => gameStateManager.rerolls;
  Random get random => _random;

  OverflowDefenseGame({
    this.locale = const Locale('ko'),
    bool soundEnabled = true, // 무시됨 (pdm 사용)
    this.onExit,
    required this.playerDataManager,
    required this.eventBus,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    l10n = AppLocalizations(locale);
    gameStats = GameStats.instance;
    
    gameStateManager = GameStateManager(eventBus: eventBus);
    add(gameStateManager);
    gameStateManager.resetGameState();

    if (_soundEnabled) { _initializeSounds(); }

    modifierManager = ModifierManager();

    final equippedIds = playerDataManager.equippedCharacterIds;
    final masterList = playerDataManager.masterCharacterList;
    final ownedMap = playerDataManager.ownedCharacters;
    final activeTemple = playerDataManager.activeTemple;
    final templeBonus = activeTemple.currentBonus;
    final supportedFaction = activeTemple.supportedFaction;
    
    // 1. 모든 출전 캐릭터의 HP/공격력 합산
    double totalBaseHp = 0;
    double totalWeightedAttack = 0;

    for (var id in equippedIds) {
      final charDef = masterList.firstWhere((c) => c.id == id);
      final pc = ownedMap[id] ?? PlayerCharacter(characterId: id, rank: charDef.startingRank);
      
      // HP 성장: 레벨당 10% (선형)
      final hpMultiplier = 1.0 + (pc.level - 1) * 0.1;
      totalBaseHp += charDef.baseStats.hp * hpMultiplier;
      
      // 공격력 성장: 레벨당 8% 복리 성장 (강력한 후반 성장)
      final attackMultiplier = pow(1.08, pc.level - 1);
      double charAttack = charDef.baseStats.attack * attackMultiplier;
      
      if (charDef.faction == supportedFaction) {
        charAttack *= (1.0 + templeBonus);
      }
      totalWeightedAttack += charAttack;
    }

    // 공격력은 보정된 값들의 평균 사용
    final avgAttack = equippedIds.isNotEmpty ? (totalWeightedAttack / equippedIds.length) : 0.0;
    
    // 밸런스 패치: 초반 공격력을 0.3배로 낮추어 성장하는 맛을 강화
    const double attackBalanceMultiplier = 0.3;
    final totalAttackPower = (avgAttack * attackBalanceMultiplier + playerDataManager.totalAttackPower);

    playerBase = PlayerBase(hp: totalBaseHp.toInt(), height: gameStats.baseSize.height)
      ..position = Vector2(0, size.y - gameStats.baseSize.height)
      ..onDestroyed = _onBaseDestroyed
      ..onHit = playBaseHitSound;

    enemySystem = EnemySystem(playerBase, gameStats.enemyDefinitions, eventBus: eventBus);
    tapInputLayer = TapInputLayer();
    scoreDisplay = ScoreDisplay(locale: locale);

    skillSystem = SkillSystem(
      locale: locale,
      gameStats: gameStats,
      skillDefinitions: gameStats.skillDefinitions,
      baseAttackPower: totalAttackPower.toInt(),
    );

    altarCharacters.clear();
    final altarY = size.y - gameStats.baseSize.height - 40;
    final spacing = size.x / (equippedIds.length + 1);

    for (int i = 0; i < equippedIds.length; i++) {
      final char = playerDataManager.masterCharacterList.firstWhere((c) => c.id == equippedIds[i]);
      final charComp = AltarCharacterComponent(character: char, position: Vector2(spacing * (i + 1), altarY));
      altarCharacters.add(charComp);
      add(charComp);
    }

    add(ItemSlotUI(equippedItemIds: playerDataManager.equippedToolIds, availableItems: playerDataManager.mysticTools));

    skillUI = SkillUI(skillSystem, locale: locale, gameStats: gameStats);
    waveManager = WaveManager();
    waveDisplay = WaveDisplay(locale: locale);
    cardManager = CardManager(eventBus: eventBus);
    drawCardButton = DrawCardButton()..position = Vector2(size.x / 2, size.y - 140); 
    attackPowerDisplay = AttackPowerDisplay()..position = Vector2(20, 80);

    // 상단 버튼 추가 (종료, 설정)
    add(TopNavButton(icon: Icons.home, position: Vector2(20, 20), onTap: () => onExit?.call()));
    add(TopNavButton(icon: Icons.settings, position: Vector2(size.x - 60, 20), onTap: showSettings));

    addAll([GameBackground(), playerBase, enemySystem, tapInputLayer, skillSystem, skillUI, waveManager, modifierManager, scoreDisplay, waveDisplay, cardManager, drawCardButton, attackPowerDisplay]);

    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    eventBus.on<GameScoreChangedEvent>((event) => scoreDisplay.updateScore(event.newGameScore));
    eventBus.on<StatModifierAppliedEvent>((event) {
      if (event.target == 'global') modifierManager.applyGlobalModifier(event.stat, event.value);
      else if (event.target == 'skill') modifierManager.applySkillModifier(event.skillId!, event.stat, event.value);
    });
    eventBus.on<SkillVariantAppliedEvent>((event) => skillSystem.applyVariant(event.skillId, event.variantId));
    eventBus.on<LevelUpSkillEvent>((event) => skillSystem.upgradeSkill(event.skillId));
    eventBus.on<WallHealedEvent>((event) {
      final healAmount = playerBase.maxHp * event.amount;
      playerBase.hp = min(playerBase.maxHp.toDouble(), playerBase.hp + healAmount);
      showMessage("성벽 수리 완료! (+${(event.amount * 100).toInt()}%)");
    });
    eventBus.on<ShieldGainedEvent>((event) {
      final shieldAmount = playerBase.maxHp * event.amount;
      playerBase.addShield(shieldAmount);
      showMessage("보호막 생성!");
    });
    eventBus.on<WaveClearedEvent>((event) {
      gameStateManager.addFaith(20);
      if (event.waveNumber % 10 == 0) _showSpecialOracleOffer();
      else showMessage("${l10n.waveCleared} +20 Faith");
    });
  }

  void _showSpecialOracleOffer() {
    showMessage("보스 클리어! 특별한 신탁이 내려집니다!");
    final specialHand = cardManager.drawHand();
    add(CardSelectionOverlay(cards: specialHand, l10n: l10n, isSpecial: true));
  }

  void showCardSelection() {
    try {
      if (paused || children.whereType<CardSelectionOverlay>().isNotEmpty) return;
      playCardDrawSound();
      final hand = cardManager.drawHand();
      if (hand.isNotEmpty) add(CardSelectionOverlay(cards: hand, l10n: l10n));
    } catch (e) { paused = false; }
  }

  void selectCard(CardDefinition card) {
    cardManager.applyCard(card);
    gameStateManager.deductFaith(gameStateManager.oracleCost);
    gameStateManager.updateOracleCost(gameStateManager.oracleCost + 1);
  }

  Vector2 getCharacterPosition(int index) {
    if (index < altarCharacters.length) return altarCharacters[index].position;
    return size / 2;
  }

  void showVictoryOverlay() {
    if (children.whereType<VictoryOverlay>().isNotEmpty) return;
    add(VictoryOverlay(score: gameScore, locale: locale, onExit: () => onExit?.call()));
  }

  void showSkillInfo(SkillState skill) {
    if (children.whereType<SkillInfoPopup>().isNotEmpty) return;
    add(SkillInfoPopup(skill: skill, locale: locale));
  }

  void showSettings() {
    if (children.whereType<SettingsOverlay>().isNotEmpty) return;
    add(SettingsOverlay());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;
    if (playerBase.hp <= 0) _gameOver();
  }

  void _onBaseDestroyed() { if (!isGameOver) _gameOver(); }

  void _gameOver() {
    if (isGameOver) return;
    gameStateManager.setGameOver(true);
    playGameOverSound();
    add(GameOverOverlay(gameScore: gameScore, waveReached: waveManager.currentWaveNumber, onRestart: _restartGame, locale: locale, onExit: onExit));
  }

  void _restartGame() {
    removeAll(children.whereType<GameOverOverlay>());
    playerBase.hp = playerBase.maxHp.toDouble();
    enemySystem.clearEnemies();
    waveManager.reset();
    gameStateManager.resetGameState();
  }

  void showMessage(String message) {
    final textComponent = TextComponent(
      text: message,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.bold)),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(textComponent);
    add(TimerComponent(period: 2.0, onTick: () => textComponent.removeFromParent(), removeOnFinish: true));
  }

  void _initializeSounds() { FlameAudio.audioCache.loadAll(['base_hit.mp3', 'enemy_death.mp3', 'explosion.mp3', 'game_over.mp3']); }
  void playBaseHitSound() { if (_soundEnabled) FlameAudio.play('base_hit.mp3', volume: 0.5); }
  void playEnemyDeathSound() { if (_soundEnabled) FlameAudio.play('enemy_death.mp3', volume: 0.2); }
  void playExplosionSound() { if (_soundEnabled) FlameAudio.play('explosion.mp3', volume: 0.4); }
  void playGameOverSound() { if (_soundEnabled) FlameAudio.play('game_over.mp3', volume: 0.6); }
  void playCardDrawSound() {}
  void playCurseSound() {}
  void playCardSelectSound() {}

  @override
  void onRemove() { super.onRemove(); }
}

class GameBackground extends Component {}

class ItemSlotUI extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final List<String> equippedItemIds;
  final List<GameItem> availableItems;
  ItemSlotUI({required this.equippedItemIds, required this.availableItems}) : super(priority: 100);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.centerRight;
    position = Vector2(gameRef.size.x - 12, gameRef.size.y * 0.5);
    const double btnSize = 34.0;
    const double spacing = 6.0;
    for (int i = 0; i < equippedItemIds.length; i++) {
      final itemId = equippedItemIds[i];
      final item = availableItems.firstWhere((it) => it.id == itemId);
      add(ItemButtonComponent(item: item, position: Vector2(0, (i * (btnSize + spacing)) - ((btnSize + spacing) * equippedItemIds.length / 2) + (btnSize / 2))));
    }
  }
}

class ItemButtonComponent extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final GameItem item;
  int charges = 1;
  ItemButtonComponent({required this.item, required Vector2 position}) : super(position: position, size: Vector2.all(34), anchor: Anchor.center);
  @override
  void render(Canvas canvas) {
    if (charges <= 0) return;
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), Paint()..color = item.color.withValues(alpha: 0.8));
    final textPainter = TextPainter(text: TextSpan(text: String.fromCharCode(item.icon.codePoint), style: TextStyle(fontSize: 18, fontFamily: item.icon.fontFamily, package: item.icon.fontPackage, color: Colors.white, shadows: const [Shadow(color: Colors.black, blurRadius: 2)])), textDirection: TextDirection.ltr)..layout();
    textPainter.paint(canvas, Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2));
  }
  @override
  void onTapDown(TapDownEvent event) {
    if (charges > 0) {
      charges--;
      _triggerVisualEffects();
      gameRef.showMessage("${item.name} 발동!");
      if (item.id == 'tsunami') _applyTsunami();
      else if (item.id == 'meteor_shower') _applyMeteorShower();
      else gameRef.enemySystem.damageInRadius(gameRef.size / 2, 2000, 200);
      if (charges <= 0) removeFromParent();
    }
  }
  void _triggerVisualEffects() {
    gameRef.camera.viewfinder.add(MoveByEffect(Vector2(5, 5), EffectController(duration: 0.1, alternate: true, repeatCount: 3)));
    final flash = RectangleComponent(size: gameRef.size, paint: Paint()..color = item.color.withValues(alpha: 0.3));
    gameRef.add(flash);
    flash.add(OpacityEffect.fadeOut(EffectController(duration: 0.4), onComplete: () => flash.removeFromParent()));
  }
  void _applyTsunami() {
    final targets = List<Enemy>.from(gameRef.enemySystem.enemies);
    for (final enemy in targets) { 
      if (enemy.isMounted && !enemy.isDying) { enemy.position.y -= 200; enemy.takeDamage(50); }
    }
  }
  void _applyMeteorShower() {
    for (int i = 0; i < 10; i++) {
      final randomPos = Vector2(gameRef.random.nextDouble() * gameRef.size.x, gameRef.random.nextDouble() * gameRef.size.y * 0.7);
      gameRef.enemySystem.damageInRadius(randomPos, 100, 150);
      gameRef.add(ExplosionEffect(randomPos));
    }
  }
}

/// 상단 네비게이션 버튼 (홈, 설정용)
class TopNavButton extends PositionComponent with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  final IconData icon;
  final VoidCallback onTap;
  TopNavButton({required this.icon, required Vector2 position, required this.onTap}) 
    : super(position: position, size: Vector2.all(40), anchor: Anchor.topLeft, priority: 200);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.1);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    
    final textPainter = TextPainter(
      text: TextSpan(text: String.fromCharCode(icon.codePoint), style: TextStyle(fontSize: 24, fontFamily: icon.fontFamily, package: icon.fontPackage, color: Colors.white70)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
