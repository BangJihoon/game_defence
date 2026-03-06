// lib/game/combat/skill_engine.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../overflow_game.dart';
import '../enemy.dart';
import '../../data/skill_data.dart';
import '../../data/character_data.dart';
import 'package:flame/effects.dart';

class SkillEngine {
  final OverflowDefenseGame game;
  final DamageCalculator damageCalculator;
  final StatusEngine statusEngine;
  final EffectSpawner effectSpawner;
  final HitFeedbackSystem feedbackSystem;
  final TargetSelector targetSelector;

  SkillEngine(this.game)
      : damageCalculator = DamageCalculator(),
        statusEngine = StatusEngine(),
        effectSpawner = EffectSpawner(game),
        feedbackSystem = HitFeedbackSystem(game),
        targetSelector = TargetSelector(game);

  void executeSkill({
    required CharacterDefinition caster,
    required SkillData skill,
    required Vector2 spawnPosition,
  }) {
    try {
      final targets = targetSelector.selectTargets(skill, spawnPosition);
      print("DEBUG: Skill ${skill.id} (Owner: ${caster.id}). Targets found: ${targets.length}");
      
      if (targets.isEmpty) return;

      if (skill.targetType == TargetType.chain) {
        _executeChain(caster, skill, targets, spawnPosition);
      } else {
        for (final target in targets) {
          _applyHit(caster, skill, target);
        }
      }

      effectSpawner.spawnCastEffect(skill.element, spawnPosition);
    } catch (e, stack) {
      print("DEBUG: CRITICAL ERROR in executeSkill: $e\n$stack");
    }
  }

  void _applyHit(CharacterDefinition caster, SkillData skill, Enemy target) {
    for (int i = 0; i < skill.hitCount; i++) {
      final delay = i * 0.08;
      Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), () {
        try {
          if (!target.isMounted) return;

          final damage = damageCalculator.calculate(
            caster: caster,
            target: target,
            skill: skill,
          );

          target.takeDamage(damage.toInt());
          print("DEBUG: Applied $damage damage to ${target.definition.enemyId}");
          
          statusEngine.applyEffects(target, skill.effects, skill.element);
          feedbackSystem.playHitFeedback(target.position);
          effectSpawner.spawnImpactEffect(skill.element, target.position);
        } catch (e) {
          print("DEBUG: Error in _applyHit delayed: $e");
        }
      });
    }
  }

  void _executeChain(CharacterDefinition caster, SkillData skill, List<Enemy> targets, Vector2 startPos) {
    Vector2 currentFrom = startPos;
    for (int i = 0; i < targets.length; i++) {
      final target = targets[i];
      final delay = i * 0.15; 
      
      Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), () {
        try {
          if (!target.isMounted) return;

          final damage = damageCalculator.calculate(
            caster: caster,
            target: target,
            skill: skill,
          );

          target.takeDamage(damage.toInt());
          statusEngine.applyEffects(target, skill.effects, skill.element);
          
          effectSpawner.spawnLightningChain(from: currentFrom, to: target.position);
          feedbackSystem.playHitFeedback(target.position, isChain: true);
          effectSpawner.spawnImpactEffect(skill.element, target.position);
          
          currentFrom = target.position;
        } catch (e) {
          print("DEBUG: Error in _executeChain delayed: $e");
        }
      });
    }
  }
}

class DamageCalculator {
  double calculate({
    required CharacterDefinition caster,
    required Enemy target,
    required SkillData skill,
  }) {
    double base = (caster.baseStats.attack) * (skill.multiplier > 0 ? skill.multiplier : 1.0);
    double elementMultiplier = ElementSystem.getMultiplier(skill.element, ElementType.none);
    return math.max(1.0, base * elementMultiplier);
  }
}

class TargetSelector {
  final OverflowDefenseGame game;
  TargetSelector(this.game);

  List<Enemy> selectTargets(SkillData skill, Vector2 origin) {
    try {
      // descendants() finds components even if they are nested inside EnemySystem
      final activeEnemies = game.descendants().whereType<Enemy>().where((e) => e.isAlive).toList();
      
      if (activeEnemies.isEmpty) return [];

      switch (skill.targetType) {
        case TargetType.single:
          activeEnemies.sort((a, b) => a.position.distanceTo(origin).compareTo(b.position.distanceTo(origin)));
          return [activeEnemies.first];
        
        case TargetType.area:
        case TargetType.frontCone:
          // For defense game, just hit everything in sight (range 2000)
          return activeEnemies.where((e) => e.position.distanceTo(origin) <= 2000).toList();

        case TargetType.global:
          return activeEnemies;

        case TargetType.chain:
          return _selectChain(activeEnemies, origin, 5, 2000);

        default:
          return [activeEnemies.first];
      }
    } catch (e) {
      print("DEBUG: Error in selectTargets: $e");
      return [];
    }
  }
      }
    } catch (e) {
      print("DEBUG: Error in selectTargets: $e");
      return [];
    }
  }

  List<Enemy> _selectChain(List<Enemy> enemies, Vector2 start, int count, double range) {
    final List<Enemy> result = [];
    final Set<Enemy> visited = {};
    Vector2 currentPos = start;

    for (int i = 0; i < count; i++) {
      Enemy? next;
      double closest = range;

      for (final e in enemies) {
        if (visited.contains(e)) continue;
        final dist = e.position.distanceTo(currentPos);
        if (dist < closest) {
          closest = dist;
          next = e;
        }
      }

      if (next != null) {
        result.add(next);
        visited.add(next);
        currentPos = next.position;
      } else {
        break;
      }
    }
    return result;
  }
}

class StatusEngine {
  void applyEffects(Enemy target, List<StatusEffectData> effects, ElementType element) {
    for (final effectData in effects) {
      target.applyStatus(effectData, element);
    }
  }
}

class EffectSpawner {
  final OverflowDefenseGame game;
  EffectSpawner(this.game);

  void spawnImpactEffect(ElementType element, Vector2 position) {
    try {
      switch (element) {
        case ElementType.fire:
          game.add(FireExplosion(position));
          break;
        case ElementType.electric:
          game.add(ElectricImpact(position));
          break;
        default:
          game.add(DefaultImpact(position));
          break;
      }
    } catch (e) {
      print("DEBUG: Error spawning impact effect: $e");
    }
  }

  void spawnCastEffect(ElementType element, Vector2 position) {
  }

  void spawnLightningChain({required Vector2 from, required Vector2 to}) {
    try {
      game.add(LightningChainEffect(from: from, to: to));
    } catch (e) {
      print("DEBUG: Error spawning lightning chain: $e");
    }
  }
}

class HitFeedbackSystem {
  final OverflowDefenseGame game;
  HitFeedbackSystem(this.game);

  void playHitFeedback(Vector2 position, {bool isChain = false}) {
    try {
      game.camera.viewfinder.add(MoveByEffect(Vector2(0, isChain ? 1 : 2), EffectController(duration: 0.05, alternate: true)));
    } catch (e) {
      print("DEBUG: Error in playHitFeedback: $e");
    }
  }
}

// Visual Effects

class FireExplosion extends CircleComponent with HasGameRef<OverflowDefenseGame> {
  FireExplosion(Vector2 position) : super(position: position, radius: 5, anchor: Anchor.center, paint: Paint()..color = Colors.orange.withValues(alpha: 0.8));
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ScaleEffect.to(Vector2.all(8.0), EffectController(duration: 0.3, curve: Curves.easeOut)));
    add(OpacityEffect.to(0, EffectController(duration: 0.3))..onComplete = removeFromParent);
  }
}

class ElectricImpact extends PositionComponent {
  ElectricImpact(Vector2 position) : super(position: position, size: Vector2.all(40), anchor: Anchor.center);
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.cyanAccent..strokeWidth = 2;
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      canvas.drawLine(Offset.zero, Offset(math.cos(angle)*20, math.sin(angle)*20), paint);
    }
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(OpacityEffect.to(0, EffectController(duration: 0.2))..onComplete = removeFromParent);
  }
}

class DefaultImpact extends CircleComponent {
  DefaultImpact(Vector2 position) : super(position: position, radius: 2, anchor: Anchor.center, paint: Paint()..color = Colors.white.withValues(alpha: 0.5));
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ScaleEffect.to(Vector2.all(5.0), EffectController(duration: 0.2)));
    add(OpacityEffect.to(0, EffectController(duration: 0.2))..onComplete = removeFromParent);
  }
}

class LightningChainEffect extends PositionComponent {
  final Vector2 from;
  final Vector2 to;
  LightningChainEffect({required this.from, required this.to}) : super(anchor: Anchor.topLeft);
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.cyanAccent..strokeWidth = 3;
    canvas.drawLine((from - position).toOffset(), (to - position).toOffset(), paint);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(OpacityEffect.to(0, EffectController(duration: 0.2))..onComplete = removeFromParent);
  }
}
