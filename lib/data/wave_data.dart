/// Represents a group of enemies to be spawned within a wave.
class SpawnGroup {
  final String enemyId;
  final int count;
  final double spawnIntervalSec;

  SpawnGroup({
    required this.enemyId,
    required this.count,
    required this.spawnIntervalSec,
  });

  factory SpawnGroup.fromJson(Map<String, dynamic> json) {
    return SpawnGroup(
      enemyId: json['enemyId'],
      count: json['count'],
      spawnIntervalSec: json['spawnIntervalSec']?.toDouble() ?? 0.5,
    );
  }
}

/// Represents a single wave definition loaded from JSON.
class WaveDefinition {
  final int waveNumber;
  final String titleLocaleKey; // Optional: for wave titles/messages
  final String descriptionLocaleKey; // Optional: for wave descriptions/hints
  final List<SpawnGroup> spawnGroups;
  final double
  delayBeforeNextWave; // Time after this wave ends before next starts

  // Optional: events or modifiers that apply to this wave
  final Map<String, dynamic>? waveEvents;
  final Map<String, dynamic>? waveModifiers;

  WaveDefinition({
    required this.waveNumber,
    this.titleLocaleKey = '',
    this.descriptionLocaleKey = '',
    required this.spawnGroups,
    this.delayBeforeNextWave = 0.0,
    this.waveEvents,
    this.waveModifiers,
  });

  factory WaveDefinition.fromJson(Map<String, dynamic> json) {
    var spawnGroupsList = <SpawnGroup>[];
    if (json['spawnGroups'] != null) {
      json['spawnGroups'].forEach((groupJson) {
        spawnGroupsList.add(SpawnGroup.fromJson(groupJson));
      });
    }

    return WaveDefinition(
      waveNumber: json['waveNumber'],
      titleLocaleKey: json['titleLocaleKey'] ?? '',
      descriptionLocaleKey: json['descriptionLocaleKey'] ?? '',
      spawnGroups: spawnGroupsList,
      delayBeforeNextWave: json['delayBeforeNextWave']?.toDouble() ?? 0.0,
      waveEvents: json['waveEvents'] != null
          ? Map<String, dynamic>.from(json['waveEvents'])
          : null,
      waveModifiers: json['waveModifiers'] != null
          ? Map<String, dynamic>.from(json['waveModifiers'])
          : null,
    );
  }
}
