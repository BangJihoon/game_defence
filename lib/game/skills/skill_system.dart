import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../overflow_game.dart';
import '../../l10n/app_localizations.dart';
import '../../config/game_config.dart';
import '../enemy.dart';

enum SkillType {
  lightning,
  freeze,
  heal,
}

class Skill {
  final SkillType type;
  final String name;
  final String description;
  final SkillStats stats;
  int currentLevel;
  double currentCooldown = 0;

  Skill({
    required this.type,
    required this.name,
    required this.description,
    required this.stats,
    this.currentLevel = 0,
  });

  // Getters for calculated skill properties
  double get cooldown => stats.initialCooldown - (stats.cooldownReductionPerLevel * currentLevel);
  int get count => (stats.initialCount ?? 0) + (stats.countPerLevel ?? 0) * currentLevel;
  double get speedMultiplier => (stats.initialSpeedMultiplier ?? 1.0) - ((stats.speedMultiplierPerLevel ?? 0.0) * currentLevel);
  double get duration => (stats.initialDuration ?? 0.0) + ((stats.durationPerLevel ?? 0.0) * currentLevel);
  int get amount => (stats.initialAmount ?? 0) + (stats.amountPerLevel ?? 0) * currentLevel;

  bool get isReady => currentCooldown <= 0;
  bool get canUpgrade => currentLevel < stats.maxLevel;
  int get upgradeCost => stats.upgradeCost;

  void update(double dt) {
    if (currentCooldown > 0) {
      currentCooldown -= dt;
    }
  }

  void use() {
    currentCooldown = cooldown;
  }

  void upgrade() {
    if (canUpgrade) {
      currentLevel++;
    }
  }
}

class SkillSystem extends Component with HasGameRef<OverflowDefenseGame> {
  final List<Skill> skills = [];
  final Random _random = Random();
  final Locale locale;
  final GameStats gameStats;
  late AppLocalizations l10n;

  SkillSystem({required this.locale, required this.gameStats}) {
    l10n = AppLocalizations(locale);
    skills.addAll([
      Skill(
        type: SkillType.lightning,
        name: l10n.lightningSkill,
        description: l10n.lightningSkillDesc,
        stats: gameStats.lightning,
      ),
      Skill(
        type: SkillType.freeze,
        name: l10n.freezeSkill,
        description: l10n.freezeSkillDesc,
        stats: gameStats.freeze,
      ),
      Skill(
        type: SkillType.heal,
        name: l10n.healSkill,
        description: l10n.healSkillDesc,
        stats: gameStats.heal,
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final skill in skills) {
      skill.update(dt);
    }
  }

  void useSkill(SkillType type) {
    final skill = skills.firstWhere((s) => s.type == type);
    
    if (!skill.isReady) return;

    switch (type) {
      case SkillType.lightning:
        _useLightning(skill);
        break;
      case SkillType.freeze:
        _useFreeze(skill);
        break;
      case SkillType.heal:
        _useHeal(skill);
        break;
    }

    skill.use();
  }

  void _useLightning(Skill skill) {
    final activeEnemies = List<Enemy>.from(game.enemySystem.enemies);
    if (activeEnemies.isEmpty) return;

    activeEnemies.shuffle(_random);
    final targets = activeEnemies.take(skill.count).toList();

    for (final enemy in targets) {
      if (enemy.isMounted) {
        game.add(LightningStrikeEffect(enemy.position));
        enemy.kill();
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
        (game.playerBase.hp + skill.amount).clamp(0, gameStats.baseHP).toDouble();
    game.add(HealEffect(game.playerBase.center));
  }

  void upgradeSkill(SkillType type) {
    final skill = skills.firstWhere((s) => s.type == type);
    if (skill.canUpgrade && game.score >= skill.upgradeCost) {
      game.scoreDisplay.updateScore(game.score - skill.upgradeCost); // Deduct cost
      skill.upgrade();
      // Optionally update UI here or trigger a rebuild in SkillUI
    }
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