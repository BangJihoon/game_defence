// lib/data/player_skill_data.dart

/// Represents a skill instance owned by the player.
class PlayerSkill {
  final String skillId;
  int level;
  int rank; // Added rank
  bool isUnlocked;
  String? selectedVariantId; // New field to store selected variant ID

  PlayerSkill({
    required this.skillId,
    this.level = 0, // Level 0 means locked
    this.rank = 1, // Default rank is 1
    this.isUnlocked = false,
    this.selectedVariantId,
  });
}
