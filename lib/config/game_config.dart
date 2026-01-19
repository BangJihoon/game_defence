import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameStats {
  // Game base stats
  final int baseHP;
  final double explosionRadius;
  final int explosionDamage;

  // Wave definitions
  final List<Wave> waves;

  // Enemy stats
  final Map<String, EnemyStats> enemies;

  // Skill stats
  final SkillStats lightning;
  final SkillStats freeze;
  final SkillStats heal;

  // UI stats
  final UiSizeStats baseSize;
  final int skillButtonSize;
  final int skillButtonSpacing;

  GameStats({
    required this.baseHP,
    required this.explosionRadius,
    required this.explosionDamage,
    required this.waves,
    required this.enemies,
    required this.lightning,
    required this.freeze,
    required this.heal,
    required this.baseSize,
    required this.skillButtonSize,
    required this.skillButtonSpacing,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    var enemiesMap = <String, EnemyStats>{};
    json['enemies'].forEach((key, value) {
      enemiesMap[key] = EnemyStats.fromJson(value);
    });

    var wavesList = <Wave>[];
    json['waves'].forEach((waveJson) {
      wavesList.add(Wave.fromJson(waveJson));
    });

    return GameStats(
      baseHP: json['game']['baseHP'],
      explosionRadius: json['game']['explosionRadius'].toDouble(),
      explosionDamage: json['game']['explosionDamage'],
      waves: wavesList,
      enemies: enemiesMap,
      lightning: SkillStats.fromJson(json['skills']['lightning']),
      freeze: SkillStats.fromJson(json['skills']['freeze']),
      heal: SkillStats.fromJson(json['skills']['heal']),
      baseSize: UiSizeStats.fromJson(json['ui']['baseSize']),
      skillButtonSize: json['ui']['skillButtonSize'],
      skillButtonSpacing: json['ui']['skillButtonSpacing'],
    );
  }

  static Future<GameStats> load() async {
    final jsonString =
        await rootBundle.loadString('assets/config/game_stats.json');
    final jsonMap = json.decode(jsonString);
    return GameStats.fromJson(jsonMap);
  }
}

class Wave {
  final double delay;
  final Map<String, int> enemies;

  Wave({required this.delay, required this.enemies});

  factory Wave.fromJson(Map<String, dynamic> json) {
    var enemiesMap = <String, int>{};
    json['enemies'].forEach((key, value) {
      enemiesMap[key] = value;
    });
    return Wave(delay: json['delay'].toDouble(), enemies: enemiesMap);
  }
}

class EnemyStats {
  final int hp;
  final double speed;
  final int damage;
  final int score;
  final Color color;
  final int width;
  final int height;

  EnemyStats({
    required this.hp,
    required this.speed,
    required this.damage,
    required this.score,
    required this.color,
    required this.width,
    required this.height,
  });

  factory EnemyStats.fromJson(Map<String, dynamic> json) {
    return EnemyStats(
      hp: json['hp'],
      speed: json['speed'].toDouble(),
      damage: json['damage'],
      score: json['score'],
      color: Color(int.parse(json['color'])),
      width: json['width'],
      height: json['height'],
    );
  }
}

class SkillStats {
  // General skill properties
  final double initialCooldown;
  final double cooldownReductionPerLevel;
  final int upgradeCost;
  final int maxLevel;

  // Lightning specific
  final int? initialCount;
  final int? countPerLevel;

  // Freeze specific
  final double? initialSpeedMultiplier;
  final double? speedMultiplierPerLevel;
  final double? initialDuration;
  final double? durationPerLevel;

  // Heal specific
  final int? initialAmount;
  final int? amountPerLevel;

  SkillStats({
    required this.initialCooldown,
    required this.cooldownReductionPerLevel,
    required this.upgradeCost,
    required this.maxLevel,
    this.initialCount,
    this.countPerLevel,
    this.initialSpeedMultiplier,
    this.speedMultiplierPerLevel,
    this.initialDuration,
    this.durationPerLevel,
    this.initialAmount,
    this.amountPerLevel,
  });

  factory SkillStats.fromJson(Map<String, dynamic> json) {
    return SkillStats(
      initialCooldown: json['initialCooldown'].toDouble(),
      cooldownReductionPerLevel: json['cooldownReductionPerLevel'].toDouble(),
      upgradeCost: json['upgradeCost'],
      maxLevel: json['maxLevel'],
      initialCount: json['initialCount'],
      countPerLevel: json['countPerLevel'],
      initialSpeedMultiplier: json['initialSpeedMultiplier']?.toDouble(),
      speedMultiplierPerLevel: json['speedMultiplierPerLevel']?.toDouble(),
      initialDuration: json['initialDuration']?.toDouble(),
      durationPerLevel: json['durationPerLevel']?.toDouble(),
      initialAmount: json['initialAmount'],
      amountPerLevel: json['amountPerLevel'],
    );
  }
}

class UiSizeStats {
  final int width;
  final int height;

  UiSizeStats({
    required this.width,
    required this.height,
  });

  factory UiSizeStats.fromJson(Map<String, dynamic> json) {
    return UiSizeStats(
      width: json['width'],
      height: json['height'],
    );
  }
}