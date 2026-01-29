// lib/player/player_data_manager.dart
import 'package:flutter/material.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats for skill definitions
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/data/player_skill_data.dart';

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

  PlayerData({
    this.playerLevel = 1,
    this.playerExp = 0,
    required this.currencies,
    required this.inventory,
    required this.equipmentSlots,
    required this.ownedCharacters,
    required this.ownedSkills,
    this.totalAttackPower = 0,
  });
}

/// Manages loading, saving, and providing access to player data.
/// For now, it initializes a "test account" with mock data.
class PlayerDataManager extends ChangeNotifier {
  late PlayerData _playerData;

  PlayerData get playerData => _playerData;

  PlayerDataManager() {
    _loadTestAccount();
  }

  void _loadTestAccount() {
    debugPrint("Loading test account with generous items, currency, and characters...");

    // Initialize equipment slots
    final slots = EquipmentType.values
        .map((type) => EquipmentSlotState(type: type, level: 1))
        .toList();

    // Create a variety of mock inventory items
    final inventory = [
      InventoryItem(
        id: 'weapon_1',
        name: '초보자의 검',
        description: '날이 무딘 기본적인 검입니다.',
        icon: Icons.shield,
        equipmentType: EquipmentType.weapon,
      ),
      InventoryItem(
        id: 'hat_1',
        name: '가죽 모자',
        description: '기본적인 방어력을 제공합니다.',
        icon: Icons.ac_unit, // Placeholder icon
        equipmentType: EquipmentType.hat,
      ),
      ...List.generate(5, (i) => InventoryItem(
        id: 'scroll_atk_${i+1}',
        name: '공격의 주문서',
        description: '무기 슬롯에 장착하여 공격력을 올립니다.',
        icon: Icons.article,
      )),
      ...List.generate(5, (i) => InventoryItem(
        id: 'scroll_def_${i+1}',
        name: '방어의 주문서',
        description: '방어구 슬롯에 장착하여 방어력을 올립니다.',
        icon: Icons.article_outlined,
      )),
      ...List.generate(20, (i) => InventoryItem(
        id: 'item_$i',
        name: '기타 아이템 $i',
        description: '설명 $i',
        icon: Icons.widgets_outlined,
      )),
    ];
    
    // Initialize owned characters
    final ownedChars = masterCharacterList.map((char) {
      if (char.id == 'hermes') {
        // Player starts with Hermes unlocked
        return PlayerCharacter(characterId: char.id, isUnlocked: true, cardCount: 1);
      }
      if (char.id == 'hercules') {
        // Give some cards for Hercules to test the unlock system
        return PlayerCharacter(characterId: char.id, cardCount: cardsNeededToUnlock);
      }
      return PlayerCharacter(characterId: char.id);
    }).toList();

    // Initialize owned skills
    // In a real app, this list would be built from a master skill list
    final ownedSkills = [
      PlayerSkill(skillId: 'fireball', isUnlocked: true, level: 1, rank: 1), // Rank 1
      PlayerSkill(skillId: 'chain_lightning', isUnlocked: false, level: 0, rank: 1),
      PlayerSkill(skillId: 'ice_wall', isUnlocked: false, level: 0, rank: 1),
      PlayerSkill(skillId: 'frost_nova', isUnlocked: false, level: 0, rank: 1),
      PlayerSkill(skillId: 'arcane_missile', isUnlocked: false, level: 0, rank: 1),
    ];

    _playerData = PlayerData(
      playerLevel: 15, // Start at level 15 for testing rank-up
      currencies: {
        'gold': 999999,
        'gems': 9999,
      },
      inventory: inventory,
      equipmentSlots: slots,
      ownedCharacters: ownedChars,
      ownedSkills: ownedSkills,
      totalAttackPower: 10, // Base attack power
    );

    // Notify listeners that data has been loaded
    notifyListeners();
  }

  void unlockCharacter(String characterId) {
    try {
      final playerCharacter = _playerData.ownedCharacters
          .firstWhere((pc) => pc.characterId == characterId);

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
        debugPrint("Not enough cards to unlock $characterId. Needs $cardsNeededToUnlock, has ${playerCharacter.cardCount}.");
      }
    } catch (e) {
      debugPrint("Error unlocking character $characterId: $e");
    }
  }

  int getSkillUpgradeCost(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere((s) => s.skillId == skillId);
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null || playerSkill.level >= skillDef.maxLevel) {
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
      final playerSkill = _playerData.ownedSkills.firstWhere((s) => s.skillId == skillId);
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null) {
        debugPrint("Cannot upgrade skill $skillId: Not unlocked or definition not found.");
        return;
      }
      if (playerSkill.level >= skillDef.maxLevel) {
        debugPrint("Skill $skillId is already at max level for its current rank (${playerSkill.level}/${skillDef.maxLevel}).");
        return;
      }

      final cost = getSkillUpgradeCost(skillId);
      if (cost == 0) return; // Should not happen if above checks pass

      if ((_playerData.currencies['gold'] ?? 0) >= cost) {
        _playerData.currencies['gold'] = (_playerData.currencies['gold'] ?? 0) - cost;
        playerSkill.level++;
        debugPrint("Upgraded skill $skillId to level ${playerSkill.level}.");
        notifyListeners();
      } else {
        debugPrint("Not enough gold to upgrade $skillId. Needs $cost, has ${_playerData.currencies['gold']}.");
      }
    } catch (e) {
      debugPrint("Error upgrading skill $skillId: $e");
    }
  }

  int getSkillRankUpCost(String skillId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere((s) => s.skillId == skillId);
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null || playerSkill.rank >= 5) { // Max 5 ranks for now
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
      final playerSkill = _playerData.ownedSkills.firstWhere((s) => s.skillId == skillId);
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (!playerSkill.isUnlocked || skillDef == null) {
        debugPrint("Cannot rank up skill $skillId: Not unlocked or definition not found.");
        return;
      }
      if (playerSkill.rank >= 5) { // Max 5 ranks
        debugPrint("Skill $skillId is already at max rank (${playerSkill.rank}).");
        return;
      }
      if (playerSkill.level < skillDef.maxLevel) {
        debugPrint("Skill $skillId must be at max level (${skillDef.maxLevel}) to rank up.");
        return;
      }
      if (_playerData.playerLevel < playerSkill.rank * 10) {
        debugPrint("Player level ${_playerData.playerLevel} is too low to rank up $skillId. Requires player level ${playerSkill.rank * 10}.");
        return;
      }

      final cost = getSkillRankUpCost(skillId);
      if (cost == 0) return;

      if ((_playerData.currencies['gems'] ?? 0) >= cost) {
        _playerData.currencies['gems'] = (_playerData.currencies['gems'] ?? 0) - cost;
        playerSkill.rank++;
        playerSkill.level = 1; // Reset level after rank up
        debugPrint("Ranked up skill $skillId to rank ${playerSkill.rank}. Level reset to 1.");
        // TODO: Apply variant logic here if a variant should be chosen/applied on rank up
        notifyListeners();
      } else {
        debugPrint("Not enough gems to rank up $skillId. Needs $cost, has ${_playerData.currencies['gems']}.");
      }
    } catch (e) {
      debugPrint("Error ranking up skill $skillId: $e");
    }
  }
}
