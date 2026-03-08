// lib/config/game_config.dart
//
// A singleton configuration manager that loads and provides static game data.
// Responsibilities:
// - Loading JSON configuration files (game_stats, cards, enemies, skills, waves, shop) from assets.
// - Parsing JSON into strongly-typed data objects (CardDefinition, EnemyDefinition, etc.).
// - Providing a globally accessible `GameStats.instance` for other systems to access static data.

import 'package:game_defence/data/wave_data.dart';
import 'package:game_defence/data/skill_data.dart';
import 'package:game_defence/data/enemy_data.dart';
import 'package:game_defence/data/card_data.dart';
import 'package:game_defence/data/character_data.dart';
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
  final Map<String, SkillData> skillDefinitions;

  // All Card Definitions
  final List<CardDefinition> cards;

  // All Character Definitions
  final Map<String, CharacterDefinition> characterDefinitions;

  // Shop Data
  final Map<String, dynamic> shopData;

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
    required this.characterDefinitions,
    required this.shopData,
    required this.baseSize,
    required this.skillButtonSize,
    required this.skillButtonSpacing,
  });

  factory GameStats._fromJson(
    Map<String, dynamic> json,
    List<CardDefinition> loadedCards,
    Map<String, EnemyDefinition> loadedEnemyDefinitions,
    Map<String, SkillData> loadedSkillDefinitions,
    List<WaveDefinition> loadedWaveDefinitions,
    Map<String, CharacterDefinition> loadedCharacterDefinitions,
    Map<String, dynamic> loadedShopData,
  ) {
    return GameStats._internal(
      baseHP: json['game']['baseHP'],
      explosionRadius: json['game']['explosionRadius'].toDouble(),
      explosionDamage: json['game']['explosionDamage'],
      waveDefinitions: loadedWaveDefinitions,
      enemyDefinitions: loadedEnemyDefinitions,
      skillDefinitions: loadedSkillDefinitions,
      cards: loadedCards,
      characterDefinitions: loadedCharacterDefinitions,
      shopData: loadedShopData,
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
    final Map<String, dynamic> skillsJsonMap = json.decode(skillsJsonString);
    final List<dynamic> skillsJsonList = skillsJsonMap['skills'];
    final Map<String, SkillData> loadedSkillDefinitions = {};
    for (var json in skillsJsonList) {
      try {
        loadedSkillDefinitions[json['id'] as String] = SkillData.fromJson(json);
      } catch (e) {
        print('Error loading skill ${json['id']}: $e');
      }
    }

    final wavesJsonString = await rootBundle.loadString(
      'assets/data/waves.json',
    );
    final List<dynamic> wavesJsonList = json.decode(wavesJsonString);
    final List<WaveDefinition> loadedWaveDefinitions = wavesJsonList
        .map((json) => WaveDefinition.fromJson(json))
        .toList();

    final shopJsonString = await rootBundle.loadString('assets/data/shop_data.json');
    final Map<String, dynamic> loadedShopData = json.decode(shopJsonString);

    final List<String> characterIds = [
      'michael', 'raphael', 'uriel', 'gabriel', 'metatron', 'seraphim',
      'lucifer', 'asmodeus', 'baal', 'leviathan', 'beelzebub', 'abaddon',
      'enoch', 'samael', 'lilith', 'azazel', 'gaia', 'apophis'
    ];

    final Map<String, CharacterDefinition> loadedCharacterDefinitions = {};
    for (final id in characterIds) {
      try {
        final charJsonString = await rootBundle.loadString('assets/images/characters/$id/character.json');
        final charJson = json.decode(charJsonString);
        loadedCharacterDefinitions[id] = CharacterDefinition.fromJson(charJson);
      } catch (e) {
        print('Error loading character $id: $e');
      }
    }

    return GameStats._fromJson(
      gameStatsJsonMap,
      loadedCards,
      loadedEnemyDefinitions,
      loadedSkillDefinitions,
      loadedWaveDefinitions,
      loadedCharacterDefinitions,
      loadedShopData,
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
