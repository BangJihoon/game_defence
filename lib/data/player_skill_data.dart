// lib/data/player_skill_data.dart
//
// Defines the data structure for a skill owned by the player.
// `PlayerSkill` tracks the dynamic state of a skill, such as its current level, rank, and whether it has been unlocked.

/// Represents a skill instance owned by the player.
class PlayerSkill {
  final String skillId;
  int level;
  int rank; // Added rank
  bool isUnlocked;

  PlayerSkill({
    required this.skillId,
    this.level = 0, // Level 0 means locked
    this.rank = 1, // Default rank is 1
    this.isUnlocked = false,
  });
}
