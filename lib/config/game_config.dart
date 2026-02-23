// lib/config/game_config.dart
//
// A singleton configuration manager that loads and provides static game data.
// Responsibilities:
// - Loading JSON configuration files (game_stats, cards, enemies, skills, waves) from assets.
// - Parsing JSON into strongly-typed data objects (CardDefinition, EnemyDefinition, etc.).
// - Providing a globally accessible `GameStats.instance` for other systems to access static data.

import 'package:game_defence/data/wave_data.dart';
import 'package:game_defence/data/skill_data.dart';
import 'package:game_defence/data/enemy_data.dart';
import 'package:game_defence/data/card_data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class GameStats {
  static GameStats? _instance;
  static GameStats get instance {
    if (_instance == null) {
      throw Exception(
        "GameStats has not been initialized. Call GameStats.initialize() first.",
      );
    }
    return _instance!;
  }

  @visibleForTesting
  static set instance(GameStats instance) {
    _instance = instance;
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

  @visibleForTesting
  factory GameStats.forTest({
    int baseHP = 100,
    double explosionRadius = 100.0,
    int explosionDamage = 10,
    List<WaveDefinition> waveDefinitions = const [],
    Map<String, EnemyDefinition> enemyDefinitions = const {},
    Map<String, SkillDefinition> skillDefinitions = const {},
    List<CardDefinition> cards = const [],
    UiSizeStats? baseSize,
    int skillButtonSize = 64,
    int skillButtonSpacing = 8,
  }) {
    return GameStats._internal(
      baseHP: baseHP,
      explosionRadius: explosionRadius,
      explosionDamage: explosionDamage,
      waveDefinitions: waveDefinitions,
      enemyDefinitions: enemyDefinitions,
      skillDefinitions: skillDefinitions,
      cards: cards,
      baseSize: baseSize ?? UiSizeStats(width: 100, height: 100),
      skillButtonSize: skillButtonSize,
      skillButtonSpacing: skillButtonSpacing,
    );
  }

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
    // 🔹 1단계: JSON 문자열만 먼저 로드 (UI isolate)
    final gameStatsJsonString = await rootBundle.loadString(
      'assets/config/game_stats.json',
    );
    final cardsJsonString = await rootBundle.loadString(
      'assets/data/cards.json',
    );
    final enemiesJsonString = await rootBundle.loadString(
      'assets/data/enemies.json',
    );
    final skillsJsonString = await rootBundle.loadString(
      'assets/data/skills.json',
    );
    final wavesJsonString = await rootBundle.loadString(
      'assets/data/waves.json',
    );

    // 🔹 2단계: JSON 파싱 + 객체 생성은 isolate에서 실행
    return compute(_parseGameStatsInIsolate, {
      'game': gameStatsJsonString,
      'cards': cardsJsonString,
      'enemies': enemiesJsonString,
      'skills': skillsJsonString,
      'waves': wavesJsonString,
    });
  }

  static GameStats _parseGameStatsInIsolate(Map<String, String> jsonStrings) {
    final gameStatsJsonMap = json.decode(jsonStrings['game']!);

    final List<dynamic> cardsJsonList = json.decode(jsonStrings['cards']!);
    final List<CardDefinition> loadedCards = cardsJsonList
        .map((json) => CardDefinition.fromJson(json))
        .toList();

    final List<dynamic> enemiesJsonList = json.decode(jsonStrings['enemies']!);
    final Map<String, EnemyDefinition> loadedEnemyDefinitions = {
      for (var json in enemiesJsonList)
        json['enemyId'] as String: EnemyDefinition.fromJson(json),
    };

    final List<dynamic> skillsJsonList = json.decode(jsonStrings['skills']!);
    final Map<String, SkillDefinition> loadedSkillDefinitions = {
      for (var json in skillsJsonList)
        json['skillId'] as String: SkillDefinition.fromJson(json),
    };

    final List<dynamic> wavesJsonList = json.decode(jsonStrings['waves']!);
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
