// lib/game/skills/skill_system.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../overflow_game.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:game_defence/config/game_config.dart';
import '../../data/skill_data.dart';
import 'package:game_defence/game/skills/arcane_missile.dart';
import 'package:game_defence/game/skills/frost_nova.dart';
import 'package:game_defence/game/skills/poison_cloud.dart';
import '../enemy.dart';
import 'package:flame/effects.dart';

class Skill {
  final OverflowDefenseGame game;
  final String skillId;
  final SkillDefinition definition;
  int currentLevel = 0;
  double _cooldownTimer = 0;
  Map<String, dynamic>? variantEffect;

  Skill({required this.game, required this.skillId, required this.definition});

  bool get isReady => _cooldownTimer <= 0;
  double get currentCooldown => _cooldownTimer;
  int get upgradeCost => (currentLevel + 1) * 100;
  bool get canUpgrade => currentLevel < definition.maxLevel;

  double get cooldown {
    final base = definition.baseCooldown;
    final levelBonus = currentLevel * 0.1;
    final globalMultiplier = game.modifierManager.globalCooldownMultiplier;
    final skillMultiplier = game.modifierManager.getSkillModifier(skillId, 'cooldown');
    return max(0.1, (base - levelBonus) * globalMultiplier * skillMultiplier);
  }

  double get damage {
    final base = definition.baseDamage;
    final levelBonus = currentLevel * 5.0;
    final globalMultiplier = game.modifierManager.globalDamageMultiplier;
    final skillMultiplier = game.modifierManager.getSkillModifier(skillId, 'damage');
    return (base + levelBonus) * globalMultiplier * skillMultiplier;
  }

  double get range {
    final base = definition.baseRange;
    final skillMultiplier = game.modifierManager.getSkillModifier(skillId, 'radius');
    return base * skillMultiplier;
  }

  void update(double dt) {
    if (_cooldownTimer > 0) _cooldownTimer -= dt;
  }

  void use() { _cooldownTimer = cooldown; }

  void upgrade() { if (canUpgrade) currentLevel++; }

  void applyVariant(String variantId) {
    try {
      final variant = definition.variants.firstWhere((v) => v.variantId == variantId);
      variantEffect = variant.effect;
    } catch (e) {
      print("Variant not found: $variantId");
    }
  }
}

class SkillSystem extends Component with HasGameRef<OverflowDefenseGame> {
  final List<Skill> skills = [];
  final Random _random = Random();
  final Locale locale;
  final GameStats gameStats; 
  final Map<String, SkillDefinition> skillDefinitions; 
  final int baseAttackPower;

  SkillSystem({
    required this.locale,
    required this.gameStats,
    required this.skillDefinitions,
    required this.baseAttackPower,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    skillDefinitions.forEach((skillId, definition) {
      skills.add(Skill(game: game, skillId: skillId, definition: definition));
    });

    game.eventBus.on<LevelUpSkillEvent>((event) => upgradeSkill(event.skillId));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) return;
    for (final skill in skills) {
      skill.update(dt);
      if (skill.isReady) _triggerSkill(skill);
    }
  }

  void _triggerSkill(Skill skill) {
    final skillId = skill.skillId;
    switch (skillId) {
      case "fireball": _useFireball(skill); break;
      case "chain_lightning": _useChainLightning(skill); break;
      case "arcane_missile": _useArcaneMissile(skill); break;
      case "frost_nova": _useFrostNova(skill); break;
      case "poison_cloud": _usePoisonCloud(skill); break;
      case "healing_aura": _useHeal(skill); break;
    }
    skill.use();
  }

  void upgradeSkill(String skillId) {
    try {
      final skill = skills.firstWhere((s) => s.skillId == skillId);
      skill.upgrade();
    } catch (e) {
      print("Warning: Attempted to upgrade non-existent skill: $skillId");
    }
  }

  void applyVariant(String skillId, String variantId) {
    try {
      final skill = skills.firstWhere((s) => s.skillId == skillId);
      skill.applyVariant(variantId);
    } catch (e) {
      print("Warning: Attempted to apply variant to non-existent skill: $skillId");
    }
  }

  void _useFireball(Skill skill) {
    final activeEnemies = game.enemySystem.enemies.where((e) => !e.isDying).toList();
    if (activeEnemies.isEmpty) return;
    final target = activeEnemies[0];
    final index = skills.indexOf(skill);
    final spawnPos = game.getCharacterPosition(index);

    if (skill.variantEffect?['type'] == 'change_projectile' && skill.variantEffect?['projectileId'] == 'meteor') {
      game.add(MeteorProjectile(target: target.position, damage: skill.damage.toInt(), radius: 50.0)..position = Vector2(target.position.x, 0));
    } else {
      game.add(FireballProjectile(target: target, damage: skill.damage.toInt())..position = spawnPos);
    }
  }

  void _useChainLightning(Skill skill) {
    final activeEnemies = game.enemySystem.enemies.where((e) => e.isMounted && !e.isDying).toList();
    if (activeEnemies.isEmpty) return;
    final target = activeEnemies[0];
    final index = skills.indexOf(skill);
    final spawnPos = game.getCharacterPosition(index);
    final bounceCount = game.modifierManager.getSkillModifier(skill.skillId, 'chains').toInt() + 1;
    
    // 이펙트 추가 (간소화)
    game.add(LightningStrikeEffect(target.position));
    target.takeDamage(skill.damage.toInt());
  }

  void _useArcaneMissile(Skill skill) {
    final activeEnemies = game.enemySystem.enemies.where((e) => !e.isDying).toList();
    if (activeEnemies.isEmpty) return;
    final target = activeEnemies[0];
    final index = skills.indexOf(skill);
    final spawnPos = game.getCharacterPosition(index);
    final count = game.modifierManager.getSkillModifier(skill.skillId, 'count').toInt() + 1;

    for (int i = 0; i < count; i++) {
      game.add(ArcaneMissileProjectile(target: target, damage: skill.damage.toInt())..position = spawnPos + Vector2(i * 10.0 - (count * 5), 0));
    }
  }

  void _useFrostNova(Skill skill) {
    game.add(FrostNovaEffect(damage: skill.damage.toInt(), radius: skill.range)..position = game.size / 2);
  }

  void _usePoisonCloud(Skill skill) {
    final activeEnemies = game.enemySystem.enemies.where((e) => !e.isDying).toList();
    if (activeEnemies.isEmpty) return;
    game.add(PoisonCloudComponent(damage: (skill.damage / 5).toInt(), radius: skill.range, duration: 5.0)..position = activeEnemies[0].position);
  }

  void _useHeal(Skill skill) {
    game.playerBase.hp = min(game.playerBase.maxHp.toDouble(), game.playerBase.hp + skill.damage);
    game.add(HealVisualEffect(game.playerBase.position + Vector2(game.size.x/2, 0)));
  }
}

// --- Sub components and effects ---

class FireballProjectile extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final Enemy target;
  final int damage;
  final double _baseSpeed = 600;
  FireballProjectile({required this.target, required this.damage});
  @override
  void update(double dt) {
    super.update(dt);
    if (!target.isMounted) { removeFromParent(); return; }
    final speed = _baseSpeed * gameRef.modifierManager.projectileSpeedMultiplier;
    final direction = (target.position - position).normalized();
    position += direction * speed * dt;
    if (position.distanceTo(target.position) < 10) { target.takeDamage(damage); removeFromParent(); }
  }
  @override
  void render(Canvas canvas) { canvas.drawCircle(Offset.zero, 5, Paint()..color = Colors.orange); }
}

class MeteorProjectile extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final Vector2 target;
  final int damage;
  final double radius;
  final double _baseSpeed = 800;
  MeteorProjectile({required this.target, required this.damage, required this.radius});
  @override
  void update(double dt) {
    super.update(dt);
    final speed = _baseSpeed * gameRef.modifierManager.projectileSpeedMultiplier;
    final direction = (target - position).normalized();
    position += direction * speed * dt;
    if (position.distanceTo(target) < 10) { game.enemySystem.damageInRadius(target, radius, damage); removeFromParent(); }
  }
  @override
  void render(Canvas canvas) { canvas.drawCircle(Offset.zero, 15, Paint()..color = Colors.deepOrange); }
}

class LightningStrikeEffect extends PositionComponent {
  LightningStrikeEffect(Vector2 position) : super(position: position, size: Vector2.all(40), anchor: Anchor.center);
  @override
  Future<void> onLoad() async {
    add(TimerComponent(period: 0.3, onTick: () => removeFromParent(), removeOnFinish: true));
  }
  @override
  void render(Canvas canvas) { 
    final paint = Paint()..color = Colors.yellow.withValues(alpha: 0.8)..strokeWidth = 3;
    canvas.drawLine(Offset(0, -20), Offset(0, 20), paint); 
  }
}

class HealVisualEffect extends PositionComponent {
  HealVisualEffect(Vector2 position) : super(position: position, size: Vector2.all(100), anchor: Anchor.center);
  @override
  Future<void> onLoad() async {
    add(TimerComponent(period: 0.5, onTick: () => removeFromParent(), removeOnFinish: true));
  }
  @override
  void render(Canvas canvas) { canvas.drawCircle(Offset.zero, 50, Paint()..color = Colors.green.withValues(alpha: 0.2)); }
}
