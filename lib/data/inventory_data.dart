// lib/data/inventory_data.dart
import 'package:flutter/material.dart';

/// The 6 types of equipment slots available.
enum EquipmentType {
  hat,
  armor,
  weapon,
  necklace,
  ring,
  shoe,
}

/// Represents a scroll that can be socketed into an equipment slot.
class Scroll {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Map<String, double> effects; // e.g., {'attack_power': 5.0, 'cooldown_reduction': 0.01}

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
  final List<Scroll?> sockets; // A list of 10, can contain nulls if empty

  EquipmentSlotState({required this.type, this.level = 1})
      : sockets = List.generate(10, (_) => null);

  int get maxSockets => (level / 10).floor() + 1 > 10 ? 10 : (level / 10).floor() + 1;
}

/// Represents a generic item that can be in the player's inventory.
/// This could be an equippable item, a scroll, or a currency.
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final EquipmentType? equipmentType; // if this item is equippable

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.equipmentType,
  });
}
