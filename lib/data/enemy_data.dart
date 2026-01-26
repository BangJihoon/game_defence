
import 'package:flutter/material.dart';

/// Represents a single enemy type definition loaded from JSON.
class EnemyDefinition {
  final String enemyId;
  final String type; // e.g., "normal", "fast", "tank", "splitter"
  final int hp;
  final double speed;
  final int damage;
  final int coinReward;
  final String colorHex; // Stored as a hex string (e.g., "0xFF4CAF50")
  final double width;
  final double height;
  final List<String> abilities; // e.g., ["split_on_death"]

  EnemyDefinition({
    required this.enemyId,
    required this.type,
    required this.hp,
    required this.speed,
    required this.damage,
    required this.coinReward,
    required this.colorHex,
    required this.width,
    required this.height,
    this.abilities = const [],
  });

  factory EnemyDefinition.fromJson(Map<String, dynamic> json) {
    return EnemyDefinition(
      enemyId: json['enemyId'],
      type: json['type'],
      hp: json['hp'],
      speed: json['speed'].toDouble(),
      damage: json['damage'],
      coinReward: json['coinReward'],
      colorHex: json['colorHex'],
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      abilities: List<String>.from(json['abilities'] ?? []),
    );
  }

  Color get color => Color(int.parse(colorHex));
}
