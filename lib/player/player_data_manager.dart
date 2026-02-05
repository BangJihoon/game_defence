// lib/player/player_data_manager.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats for skill definitions
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/data/player_skill_data.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/events/game_events.dart';

// --- Constants ---
const int cardsNeededToUnlock = 50;
const int skillRankUpGemCost = 50; // Example cost for ranking up a skill

// --- Master List of All Characters in the Game ---
const List<Character> masterCharacterList = [
  Character(
    id: 'hermes',
    name: '헤르메스',
    description: '신들의 전령. 빠른 속도를 자랑합니다.',
    tier: CharacterTier.hero,
    icon: Icons.flash_on,
    baseAttack: 10,
    baseHp: 80,
    baseDefense: 5,
  ),
  Character(
    id: 'hercules',
    name: '헤라클레스',
    description: '압도적인 힘을 가진 반신반인 영웅.',
    tier: CharacterTier.hero,
    icon: Icons.fitness_center,
    baseAttack: 15,
    baseHp: 120,
    baseDefense: 8,
  ),
  Character(
    id: 'zeus',
    name: '제우스',
    description: '올림푸스의 왕. 번개를 다스립니다.',
    tier: CharacterTier.celestial,
    icon: Icons.bolt,
    baseAttack: 25,
    baseHp: 100,
    baseDefense: 10,
  ),
];
// ------------------------------------------------

/// A class to hold all data specific to a player.
class PlayerData {
  // Player Progression
  int playerLevel;
  int playerExp;

  Map<String, int> currencies;
  List<InventoryItem> inventory;
  List<EquipmentSlotState> equipmentSlots;

  List<PlayerCharacter> ownedCharacters;
  List<PlayerSkill> ownedSkills;
  int totalAttackPower;
  String activeCharacterId;
  EventBus eventBus;

  PlayerData({
    this.playerLevel = 1,
    this.playerExp = 0,
    required this.currencies,
    required this.inventory,
    required this.equipmentSlots,
    required this.ownedCharacters,
    required this.ownedSkills,
    this.totalAttackPower = 0,
    required this.activeCharacterId,
    required this.eventBus,
  });
}

/// Manages loading, saving, and providing access to player data.
/// For now, it initializes a "test account" with mock data.
class PlayerDataManager extends ChangeNotifier {
  late final PlayerData _playerData;
  PlayerSkill? _skillAwaitingVariantChoice;

  PlayerDataManager({required EventBus eventBus}) {
    // Mock Data
    final inventory = <InventoryItem>[];
    final slots = [
      EquipmentSlotState(type: EquipmentType.weapon, level: 1),
      EquipmentSlotState(type: EquipmentType.armor, level: 1),
      EquipmentSlotState(type: EquipmentType.hat, level: 1),
      EquipmentSlotState(type: EquipmentType.shoe, level: 1),
      EquipmentSlotState(type: EquipmentType.ring, level: 1),
      EquipmentSlotState(type: EquipmentType.necklace, level: 1),
    ];
    final ownedChars = masterCharacterList
        .map(
          (c) => PlayerCharacter(
            characterId: c.id,
            isUnlocked: c.id == 'hermes',
            cardCount: 0,
          ),
        )
        .toList();
    final ownedSkills = GameStats.instance.skillDefinitions.keys
        .map(
          (id) => PlayerSkill(skillId: id, level: 1, rank: 1, isUnlocked: true),
        )
        .toList();

    _playerData = PlayerData(
      playerLevel: 15, // Start at level 15 for testing rank-up
      currencies: {'gold': 999999, 'gems': 9999},
      inventory: inventory,
      equipmentSlots: slots,
      ownedCharacters: ownedChars,
      ownedSkills: ownedSkills,
      totalAttackPower: 10, // Base attack power
      activeCharacterId: 'hermes', // Hermes is active by default
      eventBus: eventBus,
    );

    _recalculateStats();
    // Notify listeners that data has been loaded
    notifyListeners();
  }

  PlayerData get playerData => _playerData;
  PlayerSkill? get skillAwaitingVariantChoice => _skillAwaitingVariantChoice;

  void unlockCharacter(String characterId) {
    try {
      final playerCharacter = _playerData.ownedCharacters.firstWhere(
        (pc) => pc.characterId == characterId,
      );

      if (playerCharacter.isUnlocked) {
        debugPrint("Character $characterId is already unlocked.");
        return;
      }

      if (playerCharacter.cardCount >= cardsNeededToUnlock) {
        playerCharacter.cardCount -= cardsNeededToUnlock;
        playerCharacter.isUnlocked = true;
        debugPrint("Character $characterId unlocked!");
        notifyListeners();
      } else {
        debugPrint(
          "Not enough cards to unlock $characterId. Needs $cardsNeededToUnlock, has ${playerCharacter.cardCount}.",
        );
      }
    } catch (e) {
      debugPrint("Error unlocking character $characterId: $e");
    }
  }

  void setActiveCharacter(String characterId) {
    try {
      final playerCharacter = _playerData.ownedCharacters.firstWhere(
        (pc) => pc.characterId == characterId,
      );

      if (playerCharacter.isUnlocked) {
        if (_playerData.activeCharacterId != characterId) {
          _playerData.activeCharacterId = characterId;
          debugPrint("Active character set to $characterId.");
          notifyListeners();
        }
      } else {
        debugPrint(
          "Cannot set active character to $characterId: Character is not unlocked.",
        );
      }
    } catch (e) {
      debugPrint("Error setting active character $characterId: $e");
    }
  }

  void equipItem(InventoryItem itemToEquip) {
    if (itemToEquip.equipmentType == null) {
      debugPrint(
        "Attempted to equip an item with no equipment type: ${itemToEquip.name}",
      );
      return;
    }

    // Find the slot for the item's type
    final slot = _playerData.equipmentSlots.firstWhere(
      (s) => s.type == itemToEquip.equipmentType,
    );
    final previouslyEquippedItem = slot.equippedItem;

    // Remove the new item from inventory first to handle swapping identical items
    _playerData.inventory.removeWhere((item) => item.id == itemToEquip.id);

    // If an item was already in the slot, add it back to inventory
    if (previouslyEquippedItem != null) {
      _playerData.inventory.add(previouslyEquippedItem);
    }

    // Equip the new item
    slot.equippedItem = itemToEquip;

    debugPrint("Equipped ${itemToEquip.name} in ${slot.type}.");
    _recalculateStats();
    notifyListeners();
  }

  void unequipItem(EquipmentType slotType) {
    // Find the slot
    final slot = _playerData.equipmentSlots.firstWhere(
      (s) => s.type == slotType,
    );

    // If there's an item to unequip
    if (slot.equippedItem != null) {
      debugPrint("Unequipping ${slot.equippedItem!.name} from ${slot.type}.");
      _playerData.inventory.add(slot.equippedItem!);
      slot.equippedItem = null;
      _recalculateStats();
      notifyListeners();
    }
  }

  void _recalculateStats() {
    double totalAttack = 0;
    // In the future, add other stats like HP, defense etc.

    for (final slot in _playerData.equipmentSlots) {
      if (slot.equippedItem != null && slot.equippedItem!.stats != null) {
        totalAttack += slot.equippedItem!.stats!['baseAttack'] ?? 0;
      }
    }
    _playerData.totalAttackPower = totalAttack.toInt();
    debugPrint(
      "Recalculated stats. Total Attack Power: ${_playerData.totalAttackPower}",
    );
  }

  int getSkillUpgradeCost(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere(
        (s) => s.skillId == skillId,
      );
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked ||
          skillDef == null ||
          playerSkill.level >= skillDef.maxLevel) {
        return 0; // Cannot upgrade
      }
      // Simple cost formula: level * 100 * rank
      return (playerSkill.level + 1) * 100 * playerSkill.rank;
    } catch (e) {
      return 0;
    }
  }

  void upgradeSkill(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere(
        (s) => s.skillId == skillId,
      );
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null) {
        debugPrint(
          "Cannot upgrade skill $skillId: Not unlocked or definition not found.",
        );
        return;
      }
      if (playerSkill.level >= skillDef.maxLevel) {
        debugPrint(
          "Skill $skillId is already at max level for its current rank (${playerSkill.level}/${skillDef.maxLevel}).",
        );
        return;
      }

      final cost = getSkillUpgradeCost(skillId);
      if (cost == 0) return; // Should not happen if above checks pass

      if ((_playerData.currencies['gold'] ?? 0) >= cost) {
        _playerData.currencies['gold'] =
            (_playerData.currencies['gold'] ?? 0) - cost;
        playerSkill.level++;
        debugPrint("Upgraded skill $skillId to level ${playerSkill.level}.");
        notifyListeners();
      } else {
        debugPrint(
          "Not enough gold to upgrade $skillId. Needs $cost, has ${_playerData.currencies['gold']}.",
        );
      }
    } catch (e) {
      debugPrint("Error upgrading skill $skillId: $e");
    }
  }

  int getSkillRankUpCost(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere(
        (s) => s.skillId == skillId,
      );
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked ||
          skillDef == null ||
          playerSkill.rank >= 5) {
        // Max 5 ranks for now
        return 0; // Cannot rank up
      }

      // Must be at max level for current rank
      if (playerSkill.level < skillDef.maxLevel) {
        return 0;
      }

      // Player level requirement (e.g., player level >= current rank * 10)
      if (_playerData.playerLevel < playerSkill.rank * 10) {
        return 0;
      }

      return skillRankUpGemCost * playerSkill.rank; // Cost scales with rank
    } catch (e) {
      return 0;
    }
  }

  void rankUpSkill(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere(
        (s) => s.skillId == skillId,
      );
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null) {
        debugPrint(
          "Cannot rank up skill $skillId: Not unlocked or definition not found.",
        );
        return;
      }
      if (playerSkill.rank >= 5) {
        // Max 5 ranks
        debugPrint(
          "Skill $skillId is already at max rank (${playerSkill.rank}).",
        );
        return;
      }
      if (playerSkill.level < skillDef.maxLevel) {
        debugPrint(
          "Skill $skillId must be at max level (${skillDef.maxLevel}) to rank up.",
        );
        return;
      }
      if (_playerData.playerLevel < playerSkill.rank * 10) {
        debugPrint(
          "Player level ${_playerData.playerLevel} is too low to rank up $skillId. Requires player level ${playerSkill.rank * 10}.",
        );
        return;
      }

      final cost = getSkillRankUpCost(skillId);
      if (cost == 0) return;

      if ((_playerData.currencies['gems'] ?? 0) >= cost) {
        _playerData.currencies['gems'] =
            (_playerData.currencies['gems'] ?? 0) - cost;
        playerSkill.rank++;
        playerSkill.level = 1; // Reset level after rank up
        debugPrint(
          "Ranked up skill $skillId to rank ${playerSkill.rank}. Level reset to 1.",
        );

        final skillDef = GameStats.instance.skillDefinitions[skillId];
        if (skillDef != null && skillDef.variants.isNotEmpty) {
          _skillAwaitingVariantChoice = playerSkill;
        }

        notifyListeners();
      } else {
        debugPrint(
          "Not enough gems to rank up $skillId. Needs $cost, has ${_playerData.currencies['gems']}.",
        );
      }
    } catch (e) {
      debugPrint("Error ranking up skill $skillId: $e");
    }
  }

  void selectSkillVariant(String skillId, String variantId) {
    _skillAwaitingVariantChoice = null;
    _playerData.eventBus.fire(
      SkillVariantAppliedEvent(skillId: skillId, variantId: variantId),
    );
    notifyListeners();
  }
}
