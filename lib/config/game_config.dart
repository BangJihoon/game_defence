import 'package:game_defence/data/wave_data.dart';
import 'package:game_defence/data/skill_data.dart';
import 'package:game_defence/data/enemy_data.dart';
import 'package:game_defence/data/card_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class GameStats {
  static GameStats? _instance;
  static GameStats get instance {
    if (_instance == null) {
      throw Exception("GameStats has not been initialized. Call GameStats.initialize() first.");
    }
    return _instance!;
  }

  // Game base stats
  final int baseHP;
  final double explosionRadius;
  final int explosionDamage;

  // Wave definitions
  final List<WaveDefinition> waveDefinitions;

  // Enemy definitions
  final Map<String, EnemyDefinition> enemyDefinitions;

  // All Skill Definitions
  final Map<String, SkillDefinition> skillDefinitions;

  // All Card Definitions
  final List<CardDefinition> cards;

  // UI stats
  final UiSizeStats baseSize;
  final int skillButtonSize;
  final int skillButtonSpacing;

  GameStats._internal({
    required this.baseHP,
    required this.explosionRadius,
    required this.explosionDamage,
    required this.waveDefinitions,
    required this.enemyDefinitions,
    required this.skillDefinitions,
    required this.cards,
    required this.baseSize,
    required this.skillButtonSize,
    required this.skillButtonSpacing,
  });

  factory GameStats._fromJson(
    Map<String, dynamic> json,
    List<CardDefinition> loadedCards,
    Map<String, EnemyDefinition> loadedEnemyDefinitions,
    Map<String, SkillDefinition> loadedSkillDefinitions,
    List<WaveDefinition> loadedWaveDefinitions,
  ) {
    return GameStats._internal(
      baseHP: json['game']['baseHP'],
      explosionRadius: json['game']['explosionRadius'].toDouble(),
      explosionDamage: json['game']['explosionDamage'],
      waveDefinitions: loadedWaveDefinitions,
      enemyDefinitions: loadedEnemyDefinitions,
      skillDefinitions: loadedSkillDefinitions,
      cards: loadedCards,
      baseSize: UiSizeStats.fromJson(json['ui']['baseSize']),
      skillButtonSize: json['ui']['skillButtonSize'],
      skillButtonSpacing: json['ui']['skillButtonSpacing'],
    );
  }

  static Future<void> initialize() async {
    if (_instance != null) {
      // Already initialized
      return;
    }
    _instance = await _load();
  }

  static Future<GameStats> _load() async {
    final gameStatsJsonString = await rootBundle.loadString(
      'assets/config/game_stats.json',
    );
    final gameStatsJsonMap = json.decode(gameStatsJsonString);

    final cardsJsonString = await rootBundle.loadString(
      'assets/data/cards.json',
    );
    final List<dynamic> cardsJsonList = json.decode(cardsJsonString);
    final List<CardDefinition> loadedCards = cardsJsonList
        .map((json) => CardDefinition.fromJson(json))
        .toList();

    final enemiesJsonString = await rootBundle.loadString(
      'assets/data/enemies.json',
    );
    final List<dynamic> enemiesJsonList = json.decode(enemiesJsonString);
    final Map<String, EnemyDefinition> loadedEnemyDefinitions = {
      for (var json in enemiesJsonList)
        json['enemyId'] as String: EnemyDefinition.fromJson(json),
    };

    final skillsJsonString = await rootBundle.loadString(
      'assets/data/skills.json',
    );
    final List<dynamic> skillsJsonList = json.decode(skillsJsonString);
    final Map<String, SkillDefinition> loadedSkillDefinitions = {
      for (var json in skillsJsonList)
        json['skillId'] as String: SkillDefinition.fromJson(json),
    };

    final wavesJsonString = await rootBundle.loadString(
      'assets/data/waves.json',
    );
    final List<dynamic> wavesJsonList = json.decode(wavesJsonString);
    final List<WaveDefinition> loadedWaveDefinitions = wavesJsonList
        .map((json) => WaveDefinition.fromJson(json))
        .toList();

    return GameStats._fromJson(
      gameStatsJsonMap,
      loadedCards,
      loadedEnemyDefinitions,
      loadedSkillDefinitions,
      loadedWaveDefinitions,
    );
  }
}

class UiSizeStats {
  final int width;
  final int height;

  UiSizeStats({required this.width, required this.height});

  factory UiSizeStats.fromJson(Map<String, dynamic> json) {
    return UiSizeStats(width: json['width'], height: json['height']);
  }
}
