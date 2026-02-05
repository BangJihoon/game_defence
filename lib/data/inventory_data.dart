// lib/data/inventory_data.dart
//
// Defines the data structures for the inventory and equipment system.
// - `EquipmentType`: Enum for the different gear slots.
// - `Scroll`: Socketable items that provide stat bonuses.
// - `EquipmentSlotState`: Represents a specific equipment slot on the player, tracking its level, equipped item, and sockets.
// - `InventoryItem`: Represents any item that can be stored in the player's inventory, including equipment and consumables.

import 'package:flutter/material.dart';

/// The 6 types of equipment slots available.
enum EquipmentType { hat, armor, weapon, necklace, ring, shoe }

/// Represents a scroll that can be socketed into an equipment slot.
class Scroll {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Map<String, double>
  effects; // e.g., {'attack_power': 5.0, 'cooldown_reduction': 0.01}

  Scroll({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.effects,
  });
}

/// Represents the state of a single equipment slot on the character.
class EquipmentSlotState {
  final EquipmentType type;
  int level;
  InventoryItem? equippedItem; // The item currently in this slot
  final List<Scroll?> sockets; // A list of 10, can contain nulls if empty

  EquipmentSlotState({
    required this.type,
    this.level = 1,
    this.equippedItem,
    List<Scroll?>? sockets,
  }) : sockets = sockets ?? List.generate(10, (_) => null);

  int get maxSockets =>
      (level / 10).floor() + 1 > 10 ? 10 : (level / 10).floor() + 1;
}

/// Represents a generic item that can be in the player's inventory.
/// This could be an equippable item, a scroll, or a currency.
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final EquipmentType? equipmentType; // if this item is equippable
  final Map<String, double>? stats; // e.g., {'baseHp': 50.0, 'baseAttack': 5.0}

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.equipmentType,
    this.stats,
  });
}
