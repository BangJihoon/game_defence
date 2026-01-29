import 'package:flame/components.dart';
import 'enemy.dart';
import 'player_base.dart';
import 'overflow_game.dart';
import '../data/enemy_data.dart'; // Import the new EnemyDefinition
import 'package:game_defence/game/events/event_bus.dart'; // Import EventBus
import 'package:game_defence/game/events/game_events.dart'; // Import GameEvent

class EnemySystem extends Component with HasGameRef<OverflowDefenseGame> {
  final PlayerBase base;
  final List<Enemy> enemies = [];
  final Map<String, EnemyDefinition> enemyDefinitions;
  final EventBus _eventBus; // Add EventBus instance

  EnemySystem(this.base, this.enemyDefinitions, {required EventBus eventBus})
      : _eventBus = eventBus; // Initialize EventBus

  void spawnEnemy(Vector2 position, String enemyId) {
    final enemyDefinition = enemyDefinitions[enemyId];
    if (enemyDefinition == null) {
      print('Error: Could not find definition for enemy ID $enemyId');
      return;
    }

    late Enemy enemy;
    enemy = Enemy(
      base: base,
      definition: enemyDefinition,
      onDestroyed: () => _onEnemyDestroyed(enemy),
    )..position = position;

    enemies.add(enemy);
    add(enemy);
  }

  void _onEnemyDestroyed(Enemy enemy) {
    if (enemies.contains(enemy)) {
      final wasKilledByPlayer = enemy.hp <= 0;
      enemies.remove(enemy);

      if (wasKilledByPlayer) {
        _eventBus.fire(EnemyKilledEvent(enemy.score)); // Fire event
      }
    }
  }

  void damageEnemies(int damage) {
    for (final enemy in List<Enemy>.from(enemies)) {
      enemy.takeDamage(damage);
    }
  }

  void damageInRadius(Vector2 center, double radius, int damage) {
    final targets = List<Enemy>.from(enemies);

    for (final enemy in targets) {
      final distance = enemy.position.distanceTo(center);
      if (distance <= radius) {
        enemy.takeDamage(damage);
      }
    }
  }

  void freezeEnemies(double multiplier, double duration) {
    for (final enemy in List<Enemy>.from(enemies)) {
      enemy.applyFreeze(multiplier, duration);
    }
  }

  void clearEnemies() {
    for (final enemy in List<Enemy>.from(enemies)) {
      enemy.removeFromParent();
    }
    enemies.clear();
  }
}

