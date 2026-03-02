import 'package:flutter/material.dart';

enum TempleType { hero, light, darkness }

class Temple {
  final String id;
  final String name;
  final String description;
  final TempleType type;
  int level;
  bool isUnlocked;
  final double baseBonus;

  Temple({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.level = 1,
    this.isUnlocked = false,
    this.baseBonus = 0.05,
  });

  double get currentBonus => baseBonus + (level - 1) * 0.01;
  double get maxBonus => 0.15;

  int get upgradeGoldCost => level * 5000;
  int get upgradeGemCost => (level / 2).ceil() * 50;
}

class Offering {
  final String id;
  final String name;
  final String description;
  final TempleType suitableTemple;
  final IconData icon;
  final Color color;

  Offering({
    required this.id,
    required this.name,
    required this.description,
    required this.suitableTemple,
    required this.icon,
    required this.color,
  });
}

class GameItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int goldCost;

  GameItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.goldCost,
  });
}
