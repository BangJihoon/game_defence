
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class PoisonCloudComponent extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  final int damage;
  final double radius;
  final double duration;

  double _damageTimer = 0;

  PoisonCloudComponent({
    required this.damage,
    required this.radius,
    required this.duration,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;

    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 50, // Number of particles per second
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          speed: (Vector2(game.random.nextDouble(), game.random.nextDouble()) - Vector2.all(0.5)) * 50, // Random initial speed
          acceleration: (Vector2(game.random.nextDouble(), game.random.nextDouble()) - Vector2.all(0.5)) * 20, // Random acceleration
          child: CircleParticle(
            radius: game.random.nextDouble() * 3 + 1,
            paint: Paint()..color = Colors.green.withOpacity(0.3),
          ),
        ),
      ),
    );

    add(particle);

    add(TimerComponent(
        period: duration, onTick: removeFromParent, removeOnFinish: true));
  }

  @override
  void update(double dt) {
    super.update(dt);

    _damageTimer -= dt;
    if (_damageTimer <= 0) {
      _damageTimer = 1.0; // Damage every 1 second
      final enemies = game.enemySystem.enemies.toList().where(
        (enemy) => enemy.position.distanceTo(position) < radius,
      );
      for (final enemy in enemies) {
        enemy.takeDamage(damage);
      }
    }
  }
}
