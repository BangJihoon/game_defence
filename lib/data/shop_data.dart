import 'package:flutter/material.dart';

enum ShopItemType {
  characterCard,
  scroll,
  currency,
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final ShopItemType type;
  final String targetId; // e.g., 'hermes' for character card, 'scroll_atk' for scroll
  final int amount; // How many cards/scrolls/currency to give
  final Map<String, int> cost; // e.g., {'gold': 100, 'gems': 10}

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetId,
    required this.amount,
    required this.cost,
  });
}
