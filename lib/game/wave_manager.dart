import 'package:flame/components.dart';
import 'dart:math';

import 'overflow_game.dart';
import 'enemy.dart';

class WaveManager extends Component with HasGameRef<OverflowDefenseGame> {
  int _currentWaveIndex = 0;
  final Random _random = Random();
  double _waveTimer = 0;
  bool _isSpawning = false;

  int get currentWaveNumber => _currentWaveIndex + 1;
  bool get isSpawning => _isSpawning;
  bool get currentWaveEnemiesCleared => !_isSpawning && game.enemySystem.enemies.isEmpty;
  double get nextWaveCountdown {
    if (_currentWaveIndex >= game.gameStats.waves.length) return 0;
    return game.gameStats.waves[_currentWaveIndex].delay - _waveTimer;
  }

  WaveManager() {
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    if (currentWaveEnemiesCleared) {
      if (_currentWaveIndex >= game.gameStats.waves.length) {
        // All waves cleared
        return;
      }
      _waveTimer += dt;
      if (_waveTimer >= game.gameStats.waves[_currentWaveIndex].delay) {
        _startWave();
        _waveTimer = 0;
      }
    }
  }

  void _startWave() {
    _isSpawning = true;
    final wave = game.gameStats.waves[_currentWaveIndex];
    
    final enemiesToSpawn = <EnemyType>[];
    wave.enemies.forEach((enemyTypeName, count) {
      final type = EnemyType.values.firstWhere((e) => e.name == enemyTypeName);
      for (int i = 0; i < count; i++) {
        enemiesToSpawn.add(type);
      }
    });
    enemiesToSpawn.shuffle(_random);

    final spawnInterval = 0.5;
    int spawnedCount = 0;
    
    add(TimerComponent(
      period: spawnInterval,
      repeat: true,
      onTick: () {
        if (spawnedCount < enemiesToSpawn.length) {
          final type = enemiesToSpawn[spawnedCount];
          _spawnEnemy(type);
          spawnedCount++;
        } else {
          _isSpawning = false;
          _currentWaveIndex++;
          remove(children.whereType<TimerComponent>().first);
        }
      },
    ));
  }

  void _spawnEnemy(EnemyType type) {
    final enemyStats = game.gameStats.enemies[type.name]!;
    final randomX = _random.nextDouble() * (game.size.x - enemyStats.width) + (enemyStats.width / 2);
    game.enemySystem.spawnEnemy(Vector2(randomX, -enemyStats.height.toDouble()), type);
  }

  void reset() {
    _currentWaveIndex = 0;
    _waveTimer = 0;
    _isSpawning = false;
    removeAll(children.whereType<TimerComponent>());
  }
}