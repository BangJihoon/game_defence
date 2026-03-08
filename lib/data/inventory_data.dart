import 'package:flutter/material.dart';
import 'package:game_defence/data/character_data.dart';

enum TempleType { hero, light, darkness }

class Temple {
  final String id;
  final String name;
  final String description;
  final TempleType type;
  int level;
  bool isUnlocked;

  Temple({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.level = 1,
    this.isUnlocked = false,
  });

  Faction get supportedFaction {
    switch (type) {
      case TempleType.hero: return Faction.ancient;
      case TempleType.light: return Faction.angel;
      case TempleType.darkness: return Faction.demon;
    }
  }

  double get baseBonus => 0.05;
  double get currentBonus => baseBonus + (level - 1) * 0.01;
  double get maxBonus => 0.15;

  int get upgradeGoldCost => level * 5000;
  int get upgradeGemCost => (level / 2).ceil() * 50;

  String get imagePath {
    switch (id) {
      case 'athena':
        return 'assets/temple/temple1.png';
      case 'babel_darkness':
        return 'assets/temple/temple2.png';
      case 'light_sanctuary':
        return 'assets/temple/temple3.png';
      default:
        return 'assets/temple/temple1.png';
    }
  }
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
