// lib/player/player_data_manager.dart
import 'package:flutter/material.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats for skill definitions
import 'package:game_defence/data/inventory_data.dart'; // Also imports EquipmentType
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/data/player_skill_data.dart';
import 'package:game_defence/data/skill_data.dart'; // Import for SkillVariantDefinition
import 'package:game_defence/data/shop_data.dart'; // Import for ShopItem

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
  Map<EquipmentType, InventoryItem?> equippedItems; // New field for equipped items
  String? activeCharacterId; // New field for currently active character

  PlayerData({
    this.playerLevel = 1,
    this.playerExp = 0,
    required this.currencies,
    required this.inventory,
    required this.equipmentSlots,
    required this.ownedCharacters,
    required this.ownedSkills,
    this.totalAttackPower = 0,
    required this.equippedItems,
    this.activeCharacterId, // Add activeCharacterId to constructor
  });
}

/// Manages loading, saving, and providing access to player data.
/// For now, it initializes a "test account" with mock data.
class PlayerDataManager extends ChangeNotifier {
  late PlayerData _playerData;
  late List<ShopItem> shopItems; // Add shopItems list

  PlayerData get playerData => _playerData;

  // Callback for when a skill rank-up requires variant selection
  Function(String skillId, List<SkillVariantDefinition> variants)? onVariantSelectionRequired;

  PlayerDataManager() {
    _loadTestAccount();
    _initializeShop(); // Initialize shop items
  }

  void _initializeShop() {
    shopItems = [
      const ShopItem(
        id: 'hercules_card_1',
        name: '헤라클레스 카드',
        description: '헤라클레스 캐릭터를 활성화하는 데 필요한 카드입니다.',
        icon: Icons.person,
        type: ShopItemType.characterCard,
        targetId: 'hercules',
        amount: 1,
        cost: {'gold': 100},
      ),
      const ShopItem(
        id: 'zeus_card_1',
        name: '제우스 카드',
        description: '제우스 캐릭터를 활성화하는 데 필요한 카드입니다.',
        icon: Icons.person,
        type: ShopItemType.characterCard,
        targetId: 'zeus',
        amount: 1,
        cost: {'gold': 500},
      ),
      const ShopItem(
        id: 'scroll_atk_pack',
        name: '공격의 주문서 묶음',
        description: '공격의 주문서 5개를 획득합니다.',
        icon: Icons.article,
        type: ShopItemType.scroll,
        targetId: 'scroll_atk',
        amount: 5,
        cost: {'gold': 200},
      ),
      const ShopItem(
        id: 'gold_1000',
        name: '1000 골드',
        description: '1000 골드를 즉시 획득합니다.',
        icon: Icons.attach_money,
        type: ShopItemType.currency,
        targetId: 'gold',
        amount: 1000,
        cost: {'gems': 10},
      ),
    ];
  }

  bool canAfford(ShopItem item) {
    for (var entry in item.cost.entries) {
      if ((_playerData.currencies[entry.key] ?? 0) < entry.value) {
        return false;
      }
    }
    return true;
  }

  void purchaseItem(ShopItem item) {
    if (!canAfford(item)) {
      debugPrint("Not enough currency to purchase ${item.name}.");
      return;
    }

    // Deduct cost
    item.cost.forEach((currency, amount) {
      _playerData.currencies[currency] = (_playerData.currencies[currency] ?? 0) - amount;
    });

    // Add item
    switch (item.type) {
      case ShopItemType.characterCard:
        final playerChar = _playerData.ownedCharacters.firstWhere((c) => c.characterId == item.targetId);
        playerChar.cardCount += item.amount;
        debugPrint("Purchased ${item.amount} of ${item.name}. New count: ${playerChar.cardCount}");
        break;
      case ShopItemType.scroll:
        for (int i = 0; i < item.amount; i++) {
          _playerData.inventory.add(InventoryItem(
            id: '${item.targetId}_${DateTime.now().millisecondsSinceEpoch}_$i',
            name: item.name,
            description: item.description,
            icon: item.icon,
          ));
        }
        debugPrint("Purchased ${item.amount} of ${item.name}.");
        break;
      case ShopItemType.currency:
        _playerData.currencies[item.targetId] = (_playerData.currencies[item.targetId] ?? 0) + item.amount;
        debugPrint("Purchased ${item.amount} of ${item.targetId}.");
        break;
    }

    notifyListeners();
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
      equippedItems: {}, // Initialize as empty map
      activeCharacterId: ownedChars.firstWhere((char) => char.isUnlocked).characterId, // Set initial active character
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
        
        if (skillDef.variants.isNotEmpty) {
          debugPrint("Skill $skillId has variants. Player needs to choose one.");
          onVariantSelectionRequired?.call(skillId, skillDef.variants); // Trigger callback
        }
        notifyListeners();
      } else {
        debugPrint("Not enough gems to rank up $skillId. Needs $cost, has ${_playerData.currencies['gems']}.");
      }
    } catch (e) {
      debugPrint("Error ranking up skill $skillId: $e");
    }
  }

  void chooseSkillVariant(String skillId, String variantId) {
    try {
      final playerSkill = _playerData.ownedSkills.firstWhere((s) => s.skillId == skillId);
      final skillDef = GameStats.instance.skillDefinitions[skillId];

      if (skillDef == null) {
        debugPrint("Skill definition for $skillId not found.");
        return;
      }

      final variantExists = skillDef.variants.any((v) => v.variantId == variantId);
      if (!variantExists) {
        debugPrint("Variant $variantId not found for skill $skillId.");
        return;
      }

      playerSkill.selectedVariantId = variantId;
      debugPrint("Chosen variant $variantId for skill $skillId.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error choosing variant $variantId for skill $skillId: $e");
    }
  }

  void setActiveCharacter(String characterId) {
    try {
      final character = _playerData.ownedCharacters.firstWhere((c) => c.characterId == characterId);
      if (!character.isUnlocked) {
        debugPrint("Character $characterId is not unlocked and cannot be set as active.");
        return;
      }
      _playerData.activeCharacterId = characterId;
      debugPrint("Active character set to $characterId.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error setting active character $characterId: $e");
    }
  }

  void equipItem(String itemId) {
    try {
      final itemIndex = _playerData.inventory.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) {
        debugPrint("Item with ID $itemId not found in inventory.");
        return;
      }

      final itemToEquip = _playerData.inventory[itemIndex];

      if (itemToEquip.equipmentType == null) {
        debugPrint("Item $itemId cannot be equipped as it is not an equipment type.");
        return;
      }

      final equipmentType = itemToEquip.equipmentType!;

      // If there's already an item equipped in this slot, unequip it first
      if (_playerData.equippedItems.containsKey(equipmentType) &&
          _playerData.equippedItems[equipmentType] != null) {
        final currentlyEquippedItem = _playerData.equippedItems[equipmentType]!;
        _playerData.inventory.add(currentlyEquippedItem); // Move to inventory
        debugPrint("Unequipped ${currentlyEquippedItem.name} from ${equipmentType.name} slot.");
      }

      // Equip the new item
      _playerData.equippedItems[equipmentType] = itemToEquip;
      _playerData.inventory.removeAt(itemIndex); // Remove from inventory
      debugPrint("Equipped ${itemToEquip.name} into ${equipmentType.name} slot.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error equipping item $itemId: $e");
    }
  }

  void unequipItem(EquipmentType slotType) {
    try {
      if (!_playerData.equippedItems.containsKey(slotType) ||
          _playerData.equippedItems[slotType] == null) {
        debugPrint("No item equipped in ${slotType.name} slot to unequip.");
        return;
      }

      final itemToUnequip = _playerData.equippedItems[slotType]!;
      _playerData.inventory.add(itemToUnequip); // Move back to inventory
      _playerData.equippedItems[slotType] = null; // Clear the slot
      debugPrint("Unequipped ${itemToUnequip.name} from ${slotType.name} slot and moved to inventory.");
      notifyListeners();
    } catch (e) {
      debugPrint("Error unequipping item from ${slotType.name} slot: $e");
    }
  }

  void useScroll(String itemId, EquipmentType targetSlotType) {
    try {
      final itemIndex = _playerData.inventory.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) {
        debugPrint("Scroll with ID $itemId not found in inventory.");
        return;
      }

      final scrollItem = _playerData.inventory[itemIndex];

      // Assuming scrolls do not have an equipmentType, or have a specific ID pattern
      // For now, we'll just check if it's not equippable
      if (scrollItem.equipmentType != null) {
        debugPrint("Item $itemId is an equippable item, not a scroll.");
        return;
      }

      final targetSlot = _playerData.equipmentSlots.firstWhere(
            (slot) => slot.type == targetSlotType,
        orElse: () => throw Exception("Target equipment slot $targetSlotType not found."),
      );

      // Apply scroll effect: increase slot level
      targetSlot.level++;
      debugPrint("Applied scroll ${scrollItem.name} to ${targetSlotType.name} slot. New level: ${targetSlot.level}");

      // Remove scroll from inventory
      _playerData.inventory.removeAt(itemIndex);
      notifyListeners();
    } catch (e) {
      debugPrint("Error using scroll $itemId on slot $targetSlotType: $e");
    }
  }
}
