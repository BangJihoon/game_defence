import 'package:flame/components.dart';
import 'overflow_game.dart';
// Import the new WaveDefinition

class WaveManager extends Component with HasGameRef<OverflowDefenseGame> {
  int _currentWaveIndex = 0;
  double _waveTimer = 0;
  bool _isSpawning = false;

  int get currentWaveNumber => _currentWaveIndex + 1;
  bool get isSpawning => _isSpawning;
  bool get currentWaveEnemiesCleared =>
      !_isSpawning && game.enemySystem.enemies.isEmpty;

  double get nextWaveCountdown {
    if (_currentWaveIndex >= game.gameStats.waveDefinitions.length) return 0;
    return game
            .gameStats
            .waveDefinitions[_currentWaveIndex]
            .delayBeforeNextWave -
        _waveTimer;
  }

  WaveManager();

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    if (currentWaveEnemiesCleared) {
      if (_currentWaveIndex >= game.gameStats.waveDefinitions.length) {
        // All waves cleared
        return;
      }
      _waveTimer += dt;
      if (_waveTimer >=
          game
              .gameStats
              .waveDefinitions[_currentWaveIndex]
              .delayBeforeNextWave) {
        _startWave();
        _waveTimer = 0;
      }
    }
  }

  void _startWave() {
    _isSpawning = true;
    final wave = game.gameStats.waveDefinitions[_currentWaveIndex];

    // Use a single TimerComponent for the entire wave's spawning
    double spawnDelayAccumulator = 0;

    for (final spawnGroup in wave.spawnGroups) {
      for (int i = 0; i < spawnGroup.count; i++) {
        add(
          TimerComponent(
            period: spawnDelayAccumulator,
            onTick: () => _spawnEnemy(spawnGroup.enemyId),
            removeOnFinish: true,
          ),
        );
        spawnDelayAccumulator += spawnGroup.spawnIntervalSec;
      }
    }

    // Set a timer for when all enemies from this wave should have spawned
    add(
      TimerComponent(
        period:
            spawnDelayAccumulator, // Total time for all enemies in this wave to spawn
        onTick: () {
          _isSpawning = false; // All enemies for this wave are now released
          _currentWaveIndex++;
        },
        removeOnFinish: true,
      ),
    );
  }

  void _spawnEnemy(String enemyId) {
    // Changed to String enemyId
    final enemyDefinition = game.gameStats.enemyDefinitions[enemyId];
    if (enemyDefinition == null) {
      print('Error: Could not find definition for enemy ID $enemyId');
      return;
    }

    final randomX =
        game.random.nextDouble() * (game.size.x - enemyDefinition.width) +
        (enemyDefinition.width / 2);
    game.enemySystem.spawnEnemy(
      Vector2(randomX, -enemyDefinition.height),
      enemyId,
    ); // Pass enemyId
  }

  void reset() {
    _currentWaveIndex = 0;
    _waveTimer = 0;
    _isSpawning = false;
    removeAll(children.whereType<TimerComponent>());
  }
}
