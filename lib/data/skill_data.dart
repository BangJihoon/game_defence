/// Represents a single skill variant definition.
class SkillVariantDefinition {
  final String variantId;
  final String titleLocaleKey;
  final String descriptionLocaleKey;
  final Map<String, dynamic> effect; // Effect specific to this variant

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

/// Represents a single skill definition loaded from JSON.
class SkillDefinition {
  final String skillId;
  final String titleLocaleKey;
  final String descriptionLocaleKey;
  final String skillType; // e.g., "projectile", "aoe", "support"

  // Base stats for the skill
  final double baseCooldown;
  final double baseDamage; // For offensive skills
  final double baseRange; // For range-based skills
  final int maxLevel;

  // List of possible variants for this skill
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
      titleLocaleKey: json['titleLocaleKey'],
      descriptionLocaleKey: json['descriptionLocaleKey'],
      skillType: json['skillType'],
      baseCooldown: json['baseCooldown'].toDouble(),
      baseDamage: json['baseDamage']?.toDouble() ?? 0.0,
      baseRange: json['baseRange']?.toDouble() ?? 0.0,
      maxLevel: json['maxLevel'] ?? 1,
      variants: variantsList,
    );
  }
}
