import 'package:flame/components.dart';
import 'dart:ui';
import 'enemy.dart';
import 'player_base.dart';
import 'overflow_game.dart';
import '../config/game_config.dart';
import '../data/enemy_data.dart'; // Import the new EnemyDefinition

class EnemySystem extends Component with HasGameRef<OverflowDefenseGame> {
  final PlayerBase base;
  final List<Enemy> enemies = [];
  final void Function(int score) onEnemyKilled;
  final Map<String, EnemyDefinition> enemyDefinitions; // The new map of enemy definitions

  EnemySystem(this.base, this.enemyDefinitions, {required this.onEnemyKilled});

  void spawnEnemy(Vector2 position, String enemyId) { // Changed EnemyType to String enemyId
    final enemyDefinition = enemyDefinitions[enemyId];
    if (enemyDefinition == null) {
      print('Error: Could not find definition for enemy ID $enemyId');
      return;
    }

    late Enemy enemy;
    enemy = Enemy(
      base: base,
      definition: enemyDefinition, // Pass the new definition
      onDestroyed: () => _onEnemyDestroyed(enemy),
    )..position = position;

    enemies.add(enemy);
    add(enemy);
  }

  // _getStatsForType method is no longer needed as we use enemyDefinitions directly
  // EnemyType enum is also no longer needed, will be removed from enemy.dart

  void _onEnemyDestroyed(Enemy enemy) {
    if (enemies.contains(enemy)) {
      final wasKilledByPlayer = enemy.hp <= 0;
      enemies.remove(enemy);
      
      if (wasKilledByPlayer) {
        onEnemyKilled(enemy.score);
      }
    }
  }

  void damageEnemies(int damage) {
    for (final enemy in enemies) {
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
    for (final enemy in enemies) {
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