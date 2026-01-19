import 'package:flame/components.dart';
import 'dart:ui';
import 'enemy.dart';
import 'player_base.dart';
import 'overflow_game.dart';
import '../config/game_config.dart';

class EnemySystem extends Component with HasGameRef<OverflowDefenseGame> {
  final PlayerBase base;
  final List<Enemy> enemies = [];
  final void Function(int score) onEnemyKilled;

  EnemySystem(this.base, {required this.onEnemyKilled});

  void spawnEnemy(Vector2 position, EnemyType type) {
    final enemyStats = _getStatsForType(type);
    if (enemyStats == null) {
      print('Error: Could not find stats for enemy type $type');
      return;
    }

    late Enemy enemy;
    enemy = Enemy(
      base: base,
      stats: enemyStats,
      onDestroyed: () => _onEnemyDestroyed(enemy),
    )..position = position;

    enemies.add(enemy);
    add(enemy);
  }

  EnemyStats? _getStatsForType(EnemyType type) {
    switch (type) {
      case EnemyType.normal:
        return game.gameStats.enemies['normal'];
      case EnemyType.fast:
        return game.gameStats.enemies['fast'];
      case EnemyType.tank:
        return game.gameStats.enemies['tank'];
      default:
        return null;
    }
  }

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