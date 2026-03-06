// lib/data/character_data.dart
//
// Defines the data structures for characters based on the Character System Specification.

import 'package:flutter/material.dart';

/// Element types available in the game.
enum ElementType {
  fire,
  water,
  nature,
  electric,
  light,
  dark,
  ice,
  none,
}

/// Factions for characters.
enum Faction {
  angel,
  demon,
  ancient,
}

/// Roles for characters.
enum CharacterRole {
  burstDps,
  healer,
  crowdControl,
  silence,
  cooldownManipulation,
  burnDps,
  riskBurst,
  poisonDps,
  aoeBurst,
  shieldBreaker,
  healingReduction,
  execution,
  scalingDps,
  executionSpecialist,
  chaosDebuff,
  comboBurst,
  sustainDefender,
  resistanceBreaker,
}

/// Base stats for a character.
class BaseStats {
  final double hp;
  final double attack;
  final double attackSpeed;
  final double critChance;
  final double critDamage;
  final double defense;
  final double cooldownReduction;
  final double movementSpeed;

  const BaseStats({
    required this.hp,
    required this.attack,
    required this.attackSpeed,
    required this.critChance,
    required this.critDamage,
    required this.defense,
    required this.cooldownReduction,
    required this.movementSpeed,
  });

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    return BaseStats(
      hp: (json['hp'] ?? 0).toDouble(),
      attack: (json['attack'] ?? 0).toDouble(),
      attackSpeed: (json['attackSpeed'] ?? 0).toDouble(),
      critChance: (json['critChance'] ?? 0).toDouble(),
      critDamage: (json['critDamage'] ?? 0).toDouble(),
      defense: (json['defense'] ?? 0).toDouble(),
      cooldownReduction: (json['cooldownReduction'] ?? 0).toDouble(),
      movementSpeed: (json['movementSpeed'] ?? 0).toDouble(),
    );
  }
}

/// Defines a single character available in the game.
class CharacterDefinition {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final Faction faction;
  final ElementType primaryElement;
  final ElementType secondaryElement;
  final CharacterRole role;
  final BaseStats baseStats;
  final String passive;
  final String trait;
  final String baseSkillId;
  // TODO: Add awakeningBranches and transcendenceT5

  const CharacterDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.faction,
    required this.primaryElement,
    required this.secondaryElement,
    required this.role,
    required this.baseStats,
    required this.passive,
    required this.trait,
    required this.baseSkillId,
  });

  factory CharacterDefinition.fromJson(Map<String, dynamic> json) {
    return CharacterDefinition(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
      faction: Faction.values.firstWhere((e) => e.name == json['faction'].toLowerCase()),
      primaryElement: ElementType.values.firstWhere((e) => e.name == json['primaryElement'].toLowerCase()),
      secondaryElement: ElementType.values.firstWhere((e) => e.name == (json['secondaryElement']?.toLowerCase() ?? 'none')),
      role: CharacterRole.values.firstWhere((e) => e.name == json['role']), // Assuming camelCase in JSON
      baseStats: BaseStats.fromJson(json['baseStats']),
      passive: json['passive'] ?? '',
      trait: json['trait'] ?? '',
      baseSkillId: json['baseSkillId'] ?? '',
    );
  }

  IconData get icon {
    switch (iconName) {
      case 'directions_run': return Icons.directions_run;
      case 'security': return Icons.security;
      case 'bolt': return Icons.bolt;
      case 'colorize': return Icons.colorize;
      case 'waves': return Icons.waves;
      case 'brightness_3': return Icons.brightness_3;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'healing': return Icons.healing;
      case 'visibility_off': return Icons.visibility_off;
      case 'volume_off': return Icons.volume_off;
      case 'history': return Icons.history;
      case 'pest_control': return Icons.pest_control;
      case 'bug_report': return Icons.bug_report;
      case 'dangerous': return Icons.dangerous;
      case 'trending_up': return Icons.trending_up;
      case 'content_cut': return Icons.content_cut;
      case 'psychology': return Icons.psychology;
      case 'electric_bolt': return Icons.electric_bolt;
      case 'terrain': return Icons.terrain;
      case 'shield_moon': return Icons.shield_moon;
      default: return Icons.help_outline;
    }
  }

  String get iconAssetPath {
    final targetId = id == 'michael' ? 'michael' : 'michael';
    return 'characters/$targetId/icon.png';
  }

  String get idleFrontAssetPath {
    final targetId = id == 'michael' ? 'michael' : 'michael';
    return 'characters/$targetId/idle_front.png';
  }

  String get idleBackAssetPath {
    final targetId = id == 'michael' ? 'michael' : 'michael';
    return 'characters/$targetId/idle_back.png';
  }
}


/// Divinity Stages (Growth Stages)
enum DivinityStage {
  none,
  awakening,
  ascension,
  transcendence,
  divineForm,
}

/// Utility for element damage calculations.
class ElementSystem {
  static double getMultiplier(ElementType attacker, ElementType defender) {
    if (attacker == ElementType.none || defender == ElementType.none) return 1.0;

    const double strong = 1.3;
    const double weak = 0.75;
    const double neutral = 1.0;

    switch (attacker) {
      case ElementType.fire:
        if (defender == ElementType.nature || defender == ElementType.ice) return strong;
        if (defender == ElementType.water) return weak;
        break;
      case ElementType.water:
        if (defender == ElementType.fire) return strong;
        if (defender == ElementType.nature || defender == ElementType.electric) return weak;
        break;
      case ElementType.nature:
        if (defender == ElementType.water) return strong;
        if (defender == ElementType.fire) return weak;
        break;
      case ElementType.electric:
        if (defender == ElementType.water) return strong;
        break;
      case ElementType.light:
        if (defender == ElementType.dark) return strong;
        break;
      case ElementType.dark:
        if (defender == ElementType.light) return strong;
        break;
      case ElementType.ice:
        if (defender == ElementType.fire) return strong;
        break;
      default:
        break;
    }
    return neutral;
  }
}

/// Represents a character instance owned by the player.
class PlayerCharacter {
  final String characterId;
  int level;
  DivinityStage divinityStage;
  bool isUnlocked;

  PlayerCharacter({
    required this.characterId,
    this.level = 1,
    this.divinityStage = DivinityStage.none,
    this.isUnlocked = false,
  });
}
