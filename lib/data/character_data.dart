// lib/data/character_data.dart
//
// Defines the data structures for characters.
// - `CharacterTier` enum for rarity.
// - `Character` class for static configuration data (stats, name, icon) loaded from the game config.
// - `PlayerCharacter` class for dynamic player-owned state (level, cards collected, unlock status).

import 'package:flutter/material.dart';

/// Rarity tier for characters.
enum CharacterTier {
  mortal, // 인간계
  hero,   // 영웅
  celestial, // 천상계
}

/// Defines a single character available in the game.
class Character {
  final String id;
  final String name;
  final String description;
  final CharacterTier tier;
  final IconData icon; // Placeholder for character asset
  
  // Base stats
  final int baseAttack;
  final int baseHp;
  final int baseDefense;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.icon,
    required this.baseAttack,
    required this.baseHp,
    required this.baseDefense,
  });
}

/// Represents a character instance owned by the player.
class PlayerCharacter {
  final String characterId;
  int level;
  int cardCount;
  bool isUnlocked;

  PlayerCharacter({
    required this.characterId,
    this.level = 1,
    this.cardCount = 0,
    this.isUnlocked = false,
  });
}
