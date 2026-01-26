import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../overflow_game.dart';
import '../../l10n/app_localizations.dart';
import '../../config/game_config.dart';
import '../enemy.dart';
import '../../data/skill_data.dart'; // Import SkillDefinition

class Skill {
  final OverflowDefenseGame game;
  final String skillId;
  final SkillDefinition definition;
  int currentLevel;
  double currentCooldown = 0;
  String? currentVariantId;
  Map<String, dynamic>? variantEffect;

  Skill({
    required this.game,
    required this.skillId,
    required this.definition,
    this.currentLevel = 0,
    this.currentVariantId,
    this.variantEffect,
  });

  // Getters for calculated skill properties using definition AND modifiers
  double get cooldown {
    final base = definition.baseCooldown;
    final levelBonus = (0.5 * currentLevel); // This should eventually come from a modifier too
    final globalMultiplier = game.modifierManager.globalCooldownMultiplier;
    final skillMultiplier = game.modifierManager.getSkillModifier(skillId, 'cooldown');
    return (base - levelBonus) * globalMultiplier * skillMultiplier;
  }

  double get damage {
    final base = definition.baseDamage;
    final levelBonus = (10.0 * currentLevel); // This should eventually come from a modifier too
    final globalMultiplier = game.modifierManager.globalDamageMultiplier;
    final skillMultiplier = game.modifierManager.getSkillModifier(skillId, 'damage');
    return (base + levelBonus) * globalMultiplier * skillMultiplier;
  }
  
  double get range => definition.baseRange + (10.0 * currentLevel);
  int get count => 1 + (game.modifierManager.getSkillModifier(skillId, 'chains') -1).toInt(); // Example for chains
  double get speedMultiplier => 1.0;
  double get duration => 0.0;
  int get amount => 0;

  bool get isReady => currentCooldown <= 0;
  bool get canUpgrade => currentLevel < definition.maxLevel;
  int get upgradeCost => 100;

  void use() {
    currentCooldown = cooldown;
  }

  void upgrade() {
    if (canUpgrade) {
      currentLevel++;
    }
  }

  // Method to apply a variant
  void applyVariant(String variantId) {
    currentVariantId = variantId;
    final variant = definition.variants.firstWhere((v) => v.variantId == variantId);
    variantEffect = variant.effect;
  }
}

class SkillSystem extends Component with HasGameRef<OverflowDefenseGame> {
  final List<Skill> skills = [];
  final Random _random = Random();
  final Locale locale;
  final GameStats gameStats; // Still needed for other game stats, not just skill stats
  final Map<String, SkillDefinition> skillDefinitions; // New field for loaded skill definitions
  late AppLocalizations l10n;

  SkillSystem({
    required this.locale,
    required this.gameStats,
    required this.skillDefinitions,
  }) {
    l10n = AppLocalizations(locale);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Initialize skills from skillDefinitions
    skillDefinitions.forEach((skillId, definition) {
      skills.add(Skill(game: game, skillId: skillId, definition: definition));
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final skill in skills) {
      if (skill.currentCooldown > 0) {
        skill.currentCooldown -= dt;
      }

      if (skill.isReady) {
        useSkill(skill.skillId);
      }
    }
  }

  void useSkill(String skillId) { // Changed SkillType to String
    final skill = skills.firstWhere((s) => s.skillId == skillId);
    
    if (!skill.isReady) return;

    // Apply variant effect first if it exists
    if (skill.variantEffect != null) {
      final effectType = skill.variantEffect!['type'];
      switch (effectType) {
        case 'change_projectile':
          _applyChangeProjectile(skill, skill.variantEffect!);
          break;
        case 'create_aoe':
          _applyCreateAoe(skill, skill.variantEffect!);
          break;
        case 'add_shatter_effect':
          _applyAddShatterEffect(skill, skill.variantEffect!);
          break;
        default:
          print("Unhandled variant effect type: $effectType");
          break;
      }
    }

    // Use a switch based on skillId or skill.definition.skillType
    switch (skillId) {
      case "lightning_strike": // Use the defined skillId
        _useLightning(skill);
        break;
      case "freeze_nova":
        _useFreeze(skill);
        break;
      case "healing_aura":
        _useHeal(skill);
        break;
      case "fireball":
        _useFireball(skill);
        break;
      case "chain_lightning":
        _useChainLightning(skill);
        break;
      case "ice_wall":
        _useIceWall(skill);
        break;
      default:
        print("Unhandled skill use: $skillId");
        break;
    }

    skill.use();
  }

  void upgradeSkill(String skillId) { // Changed SkillType to String
    final skill = skills.firstWhere((s) => s.skillId == skillId);
    if (skill.canUpgrade && game.score >= skill.upgradeCost) {
      game.scoreDisplay.updateScore(game.score - skill.upgradeCost); // Deduct cost
      skill.upgrade();
      // Optionally update UI here or trigger a rebuild in SkillUI
    }
  }

  void _applyChangeProjectile(Skill skill, Map<String, dynamic> effect) {
    print("Applying change_projectile variant for skill ${skill.skillId}: ${effect['projectileId']}");
    // Implement logic to change projectile, e.g., by modifying skill.definition or having a special projectile component
  }

  void _applyCreateAoe(Skill skill, Map<String, dynamic> effect) {
    print("Applying create_aoe variant for skill ${skill.skillId}: ${effect['aoeId']}");
    // Implement logic to create an AoE at skill target location
  }

    void _applyAddShatterEffect(Skill skill, Map<String, dynamic> effect) {

      print("Applying add_shatter_effect variant for skill ${skill.skillId}: Damage: ${effect['damage']}");

      // Implement logic to add shatter effect, e.g., on ice wall destruction

    }

  

  

    void _useLightning(Skill skill) {

      final activeEnemies = List<Enemy>.from(game.enemySystem.enemies);

      if (activeEnemies.isEmpty) return;

  

      activeEnemies.shuffle(_random);

      final targets = activeEnemies.take(skill.count).toList();

  

                  for (final enemy in targets) {

  

                    if (enemy.isMounted) {

  

                      game.enemySystem.damageInRadius(enemy.position, game.gameStats.explosionRadius, skill.damage.toInt());

  

                      game.add(LightningStrikeEffect(enemy.position));

  

                    }

  

                  }

  

                  game.playExplosionSound();

  

                }

  

    void _useFreeze(Skill skill) {

      game.enemySystem.freezeEnemies(skill.speedMultiplier, skill.duration);

      game.add(FreezeEffect());

    }

  

    void _useHeal(Skill skill) {

      game.playerBase.hp =

          (game.playerBase.hp + skill.amount).clamp(0, game.playerBase.maxHp).toDouble(); // Use playerBase.maxHp

      game.add(HealEffect(game.playerBase.center));

    }

  

    void _useFireball(Skill skill) {

      final activeEnemies = List<Enemy>.from(game.enemySystem.enemies);

      if (activeEnemies.isEmpty) return;

  

      activeEnemies.shuffle(_random);

      final target = activeEnemies.first;

  

      if (skill.variantEffect?['type'] == 'change_projectile' &&

          skill.variantEffect?['projectileId'] == 'meteor') {

        final projectile = MeteorProjectile(

          target: target.position,

          damage: skill.damage.toInt(),

          radius: 50.0, // Example radius for meteor

        )

          ..position = Vector2(target.position.x, 0); // Start from top of screen

        add(projectile);

      } else {

        final projectile = FireballProjectile(

          target: target,

          damage: skill.damage.toInt(),

        )

          ..position = game.playerBase.center; // Start from player base

        add(projectile);

      }

    }

  

      void _useChainLightning(Skill skill) {

  

        final activeEnemies = List<Enemy>.from(game.enemySystem.enemies.where((e) => e.isMounted));

  

        if (activeEnemies.isEmpty) return;

  

    

  

        activeEnemies.shuffle(_random);

  

        

  

        final targets = <Enemy>[];

  

        final Set<Enemy> hitEnemies = {};

  

        

  

        var currentTarget = activeEnemies.first;

  

        targets.add(currentTarget);

  

        hitEnemies.add(currentTarget);

  

    

  

        for (int i = 0; i < skill.count - 1; i++) {

  

          final potentialTargets = activeEnemies.where((e) => !hitEnemies.contains(e) && e.position.distanceTo(currentTarget.position) < 200).toList();

  

          if (potentialTargets.isEmpty) break;

  

          

  

          potentialTargets.sort((a, b) => a.position.distanceTo(currentTarget.position).compareTo(b.position.distanceTo(currentTarget.position)));

  

          currentTarget = potentialTargets.first;

  

          targets.add(currentTarget);

  

          hitEnemies.add(currentTarget);

  

        }

  

        

  

        for (final enemy in targets) {

  

          enemy.takeDamage(skill.damage.toInt());

  

          game.add(LightningStrikeEffect(enemy.position));

  

        }

  

    

  

        // Handle static field variant

  

        if (skill.variantEffect?['type'] == 'create_aoe' &&

  

            skill.variantEffect?['aoeId'] == 'static_field') {

  

          final lastTarget = targets.last;

  

          final aoe = StaticField(

  

            position: lastTarget.position,

  

            damage: 10, // Example damage

  

            duration: 5, // Example duration

  

            radius: 100, // Example radius

  

          );

  

          add(aoe);

  

        }

  

      }

  

      void _useIceWall(Skill skill) {

  

        final wall = IceWall(

  

          skill: skill,

  

        )

  

          ..position = Vector2(game.size.x / 2, game.size.y - 200); // Example position

  

        add(wall);

  

      }

  

    }

  

    

  

    class IceWall extends PositionComponent with HasGameRef<OverflowDefenseGame> {

  

      final Skill skill;

  

      late double _hp;

  

      double _duration = 10; // Example duration

  

    

  

      IceWall({required this.skill}) {

  

        _hp = skill.damage; // Use damage as HP for the wall

  

      }

  

    

  

      @override

  

      void onMount() {

  

        super.onMount();

  

        // Logic to make enemies target the wall

  

      }

  

    

  

      @override

  

      void update(double dt) {

  

        super.update(dt);

  

    

  

        _duration -= dt;

  

        if (_duration <= 0) {

  

          _destroy();

  

        }

  

      }

  

    

  

      void takeDamage(double damage) {

  

        _hp -= damage;

  

        if (_hp <= 0) {

  

          _destroy();

  

        }

  

      }

  

    

  

      void _destroy() {

  

        if (skill.variantEffect?['type'] == 'add_shatter_effect') {

  

          final damage = skill.variantEffect!['damage'] as double;

  

          game.enemySystem.damageInRadius(position, 100, damage.toInt()); // Example radius

  

          game.add(ExplosionEffect(position: position, radius: 100)); // Reuse explosion effect for visual

  

        }

  

        removeFromParent();

  

      }

  

    

  

      @override

  

      void render(Canvas canvas) {

  

        super.render(canvas);

  

        final paint = Paint()..color = Colors.lightBlueAccent.withOpacity(0.5);

  

        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 200, height: 20), paint);

  

      }

  

    }

  

    

  

  class LightningStrikeEffect extends Component {

    final Vector2 strikePosition;

    double life = 0.2;

    final Paint _paint = Paint()

      ..color = Colors.yellow

      ..strokeWidth = 3

      ..style = PaintingStyle.stroke;

    final List<Vector2> _segments = [];

    final Random _random = Random();

  

    LightningStrikeEffect(this.strikePosition) {

      _createBolt();

    }

  

    void _createBolt() {

      _segments.add(Vector2(strikePosition.x, 0));

      Vector2 current = _segments.first;

      while(current.y < strikePosition.y) {

        final nextY = current.y + _random.nextDouble() * 20 + 5;

        final nextX = current.x + (_random.nextDouble() * 16 - 8);

        final next = Vector2(nextX, nextY);

        _segments.add(next);

        current = next;

      }

    }

  

    @override

    void update(double dt) {

      super.update(dt);

      life -= dt;

      if (life <= 0) {

        removeFromParent();

      }

    }

  

    @override

    void render(Canvas canvas) {

      _paint.color = Colors.yellow.withOpacity((life / 0.2).clamp(0.0, 1.0));

      for (int i = 0; i < _segments.length - 1; i++) {

        canvas.drawLine(

          _segments[i].toOffset(),

          _segments[i + 1].toOffset(),

          _paint,

        );

      }

    }

  }

  

  class FreezeEffect extends Component with HasGameRef<OverflowDefenseGame> {

    double life = 0.3;

  

    @override

    void update(double dt) {

      super.update(dt);

      life -= dt;

      if (life <= 0) {

        removeFromParent();

      }

    }

  

    @override

    void render(Canvas canvas) {

      final paint = Paint()

        ..color = const Color(0xFF87CEEB)

            .withOpacity((0.3 * (life / 0.3)).clamp(0.0, 1.0));

      canvas.drawRect(gameRef.size.toRect(), paint);

    }

  }

  

  class HealEffect extends Component {

    final Vector2 position;

    double life = 0.5;

    double radius = 0;

  

    HealEffect(this.position);

  

    @override

    void update(double dt) {

      super.update(dt);

      life -= dt;

      radius += 100 * dt;

      if (life <= 0) {

        removeFromParent();

      }

    }

  

    @override

    void render(Canvas canvas) {

      final paint = Paint()

        ..color = Colors.green.withOpacity((life / 0.5).clamp(0.0, 1.0))

        ..style = PaintingStyle.stroke

        ..strokeWidth = 3;

      

      canvas.drawCircle(

        position.toOffset(),

        radius,

        paint,

      );

    }

  }

  

  class FireballProjectile extends PositionComponent with HasGameRef<OverflowDefenseGame> {

    final Enemy target;

    final int damage;

    final double _speed = 300;

  

    FireballProjectile({required this.target, required this.damage});

  

    @override

    void update(double dt) {

      super.update(dt);

  

      if (!target.isMounted) {

        removeFromParent();

        return;

      }

  

      final direction = (target.position - position).normalized();

      position += direction * _speed * dt;

  

      if (position.distanceTo(target.position) < 10) {

        target.takeDamage(damage);

        removeFromParent();

      }

    }

  

    @override

    void render(Canvas canvas) {

      super.render(canvas);

      final paint = Paint()..color = Colors.orange;

      canvas.drawCircle(Offset.zero, 5, paint);

    }

  }

  

  class MeteorProjectile extends PositionComponent with HasGameRef<OverflowDefenseGame> {

    final Vector2 target;

    final int damage;

    final double radius;

    final double _speed = 400;

  

    MeteorProjectile({required this.target, required this.damage, required this.radius});

  

    @override

    void update(double dt) {

      super.update(dt);

  

      final direction = (target - position).normalized();

      position += direction * _speed * dt;

  

      if (position.distanceTo(target) < 10) {

        game.enemySystem.damageInRadius(target, radius, damage);

        game.add(ExplosionEffect(position: target, radius: radius));

        removeFromParent();

      }

    }

  

    @override

    void render(Canvas canvas) {

      super.render(canvas);

      final paint = Paint()..color = Colors.deepOrange;

      canvas.drawCircle(Offset.zero, 15, paint);

    }

  }

  

  class ExplosionEffect extends Component {

  

    final Vector2 position;

  

    final double radius;

  

    double life = 0.5;

  

  

  

    ExplosionEffect({required this.position, required this.radius});

  

  

  

    @override

  

    void update(double dt) {

  

      super.update(dt);

  

      life -= dt;

  

      if (life <= 0) {

  

        removeFromParent();

  

      }

  

    }

  

  

  

    @override

  

    void render(Canvas canvas) {

  

      final paint = Paint()

  

        ..color = Colors.red.withOpacity((life / 0.5).clamp(0.0, 1.0))

  

        ..style = PaintingStyle.fill;

  

      

  

      canvas.drawCircle(

  

        position.toOffset(),

  

        radius * (1 - life / 0.5),

  

        paint,

  

      );

  

    }

  

  }

  

  

  

  class StaticField extends PositionComponent with HasGameRef<OverflowDefenseGame> {

  

    final int damage;

  

    double duration;

  

    final double radius;

  

    double _damageTimer = 0;

  

  

  

    StaticField({

  

      required Vector2 position,

  

      required this.damage,

  

      required this.duration,

  

      required this.radius,

  

    }) {

  

      this.position = position;

  

    }

  

  

  

    @override

  

    void update(double dt) {

  

      super.update(dt);

  

  

  

      duration -= dt;

  

      if (duration <= 0) {

  

        removeFromParent();

  

        return;

  

      }

  

  

  

      _damageTimer -= dt;

  

      if (_damageTimer <= 0) {

  

        _damageTimer = 1.0; // Damage every 1 second

  

        final enemiesInRadius = game.enemySystem.enemies.where(

  

          (e) => e.position.distanceTo(position) < radius,

  

        );

  

        for (final enemy in enemiesInRadius) {

  

          enemy.takeDamage(damage);

  

        }

  

      }

  

    }

  

  

  

    @override

  

    void render(Canvas canvas) {

  

      super.render(canvas);

  

      final paint = Paint()

  

        ..color = Colors.blue.withOpacity(0.3)

  

        ..style = PaintingStyle.fill;

  

      canvas.drawCircle(Offset.zero, radius, paint);

  

    }

  

  }

  

  

  
    
    