// lib/data/skill_data.dart
import 'package:game_defence/data/character_data.dart';

enum DamageType {
  physical,
  magic,
  none,
}

enum TargetType {
  single,
  area,
  line,
  frontCone,
  chain,
  global,
  allyArea,
}

enum StatusEffectType {
  // Control
  stun,
  silence,
  freeze,
  fear,
  knockup,

  // DOT
  burn,
  poison,
  shock,
  bleed,
  corruption,

  // Debuff
  defenseDown,
  attackDown,
  speedDown,
  resistanceDown,
  healingReduction,

  // Buff
  shield,
  attackUp,
  defenseUp,
  regeneration,
  cooldownReduction,
}

class StatusEffectData {
  final StatusEffectType type;
  final double duration;
  final double value;
  final int maxStack;

  StatusEffectData({
    required this.type,
    required this.duration,
    required this.value,
    this.maxStack = 1,
  });

  factory StatusEffectData.fromJson(Map<String, dynamic> json) {
    return StatusEffectData(
      type: StatusEffectType.values.firstWhere((e) => e.name == json['type']),
      duration: (json['duration'] ?? 0).toDouble(),
      value: (json['value'] ?? 0).toDouble(),
      maxStack: json['maxStack'] ?? 1,
    );
  }
}

class SkillData {
  final String id;
  final String name;
  final String owner;
  final ElementType element;
  final DamageType damageType;
  final TargetType targetType;
  final double range;
  final double cooldown;
  final double multiplier;
  final int hitCount;
  final List<StatusEffectData> effects;

  SkillData({
    required this.id,
    required this.name,
    required this.owner,
    required this.element,
    required this.damageType,
    required this.targetType,
    required this.range,
    required this.cooldown,
    required this.multiplier,
    required this.hitCount,
    required this.effects,
  });

  factory SkillData.fromJson(Map<String, dynamic> json) {
    final String targetTypeStr = json['targetType'] ?? 'SINGLE';
    final TargetType mappedType = {
      "SINGLE": TargetType.single,
      "AREA": TargetType.area,
      "LINE": TargetType.line,
      "FRONT_CONE": TargetType.frontCone,
      "CHAIN": TargetType.chain,
      "GLOBAL": TargetType.global,
      "ALLY_AREA": TargetType.allyArea,
    }[targetTypeStr] ?? TargetType.single;

    return SkillData(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      element: ElementType.values.firstWhere((e) => e.name == json['element'].toLowerCase()),
      damageType: DamageType.values.firstWhere((e) => e.name == json['damageType'].toLowerCase()),
      targetType: mappedType,
      range: (json['range'] ?? 0).toDouble(),
      cooldown: (json['cooldown'] ?? 0).toDouble(),
      multiplier: (json['multiplier'] ?? 0).toDouble(),
      hitCount: json['hitCount'] ?? 1,
      effects: (json['effects'] as List?)?.map((e) => StatusEffectData.fromJson(e)).toList() ?? [],
    );
  }
}

// Keep the old classes for backward compatibility during transition if needed, 
// or remove them if you're sure you can update all references.
// For now, I'll keep them but they are marked for removal.
@Deprecated('Use SkillData instead')
class SkillDefinition {
  final String skillId;
  final String titleLocaleKey;
  final String descriptionLocaleKey;
  final String skillType;
  final double baseCooldown;
  final double baseDamage;
  final double baseRange;
  final int maxLevel;
  final List<SkillVariantDefinition> variants;

  SkillDefinition({
    required this.skillId,
    required this.titleLocaleKey,
    required this.descriptionLocaleKey,
    required this.skillType,
    required this.baseCooldown,
    this.baseDamage = 0.0,
    this.baseRange = 0.0,
    this.maxLevel = 1,
    this.variants = const [],
  });

  factory SkillDefinition.fromJson(Map<String, dynamic> json) {
    var variantsList = <SkillVariantDefinition>[];
    if (json['variants'] != null) {
      json['variants'].forEach((variantJson) {
        variantsList.add(SkillVariantDefinition.fromJson(variantJson));
      });
    }

    return SkillDefinition(
      skillId: json['skillId'],
      titleLocaleKey: json['titleLocaleKey'] ?? '',
      descriptionLocaleKey: json['descriptionLocaleKey'] ?? '',
      skillType: json['skillType'] ?? '',
      baseCooldown: (json['baseCooldown'] ?? 0).toDouble(),
      baseDamage: (json['baseDamage'] ?? 0).toDouble(),
      baseRange: (json['baseRange'] ?? 0).toDouble(),
      maxLevel: json['maxLevel'] ?? 1,
      variants: variantsList,
    );
  }
}

@Deprecated('Use SkillData instead')
class SkillVariantDefinition {
  final String variantId;
  final String titleLocaleKey;
  final String descriptionLocaleKey;
  final Map<String, dynamic> effect;

  SkillVariantDefinition({
    required this.variantId,
    required this.titleLocaleKey,
    required this.descriptionLocaleKey,
    required this.effect,
  });

  factory SkillVariantDefinition.fromJson(Map<String, dynamic> json) {
    return SkillVariantDefinition(
      variantId: json['variantId'],
      titleLocaleKey: json['titleLocaleKey'],
      descriptionLocaleKey: json['descriptionLocaleKey'],
      effect: Map<String, dynamic>.from(json['effect']),
    );
  }
}
