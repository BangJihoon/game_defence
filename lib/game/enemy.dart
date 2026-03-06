// lib/game/enemy.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'overflow_game.dart';
import 'player_base.dart';
import '../data/enemy_data.dart';
import '../data/skill_data.dart';
import '../data/character_data.dart';
import 'package:flame/effects.dart';

class StatusEffect {
  final StatusEffectType type;
  final double duration;
  final double value;
  final int maxStack;
  final ElementType element;

  double remainingTime;
  int currentStack;

  StatusEffect({
    required this.type,
    required this.duration,
    required this.value,
    this.maxStack = 1,
    this.element = ElementType.none,
  })  : remainingTime = duration,
        currentStack = 1;

  void refresh() {
    remainingTime = duration;
    if (currentStack < maxStack) {
      currentStack++;
    }
  }
}

class Enemy extends PositionComponent with HasGameRef<OverflowDefenseGame>, HasPaint {
  final EnemyDefinition definition;
  double hp;
  double speed;
  int damage;
  final VoidCallback? onDestroyed;

  bool isDying = false;
  late final PlayerBase base;

  // Status effects
  final List<StatusEffect> statusEffects = [];
  
  // 보스 패턴용 변수
  double _stateTimer = 0;
  bool _isMovingRight = true;
  
  // 빙결 효과용 변수 (Legacy - statusEffects로 통합 가능하나 기존 코드 유지를 위해 남겨둠)
  double _freezeTimer = 0;
  double _originalSpeed = 0;

  Enemy({
    required this.definition,
    required this.base,
    this.onDestroyed,
  })  : hp = definition.hp.toDouble(),
        speed = definition.speed,
        damage = definition.damage * 3;

  bool get isAlive => !isDying && hp > 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(definition.width, definition.height);
    anchor = Anchor.center;
    _originalSpeed = speed;
    
    // 기본 색상 설정
    paint.color = Color(int.parse(definition.colorHex));
  }

  @override
  void update(double dt) {
    try {
      super.update(dt);
      if (isDying || gameRef.isGameOver) return;

      _tickStatusEffects(dt);

      // 빙결 타이머 처리 (Legacy)
      if (_freezeTimer > 0) {
        _freezeTimer -= dt;
        if (_freezeTimer <= 0) {
          speed = _originalSpeed;
          paint.color = Color(int.parse(definition.colorHex));
        }
      }

      if (definition.type == 'boss') {
        _updateBossPattern(dt);
      } else {
        _updateNormalPattern(dt);
      }

      // 성벽 충돌 체크
      if (position.y + size.y / 2 >= base.position.y) {
        base.takeDamage(damage);
        _destroy();
      }
    } catch (e, stack) {
      print("Error in Enemy update: $e\n$stack");
    }
  }

  void _tickStatusEffects(double dt) {
    if (statusEffects.isEmpty) return;

    final toRemove = <StatusEffect>[];
    
    // Calculate speed modifiers from status effects
    double speedMultiplier = 1.0;
    bool isStunned = false;

    for (final effect in statusEffects) {
      effect.remainingTime -= dt;
      if (effect.remainingTime <= 0) {
        toRemove.add(effect);
        continue;
      }

      // Apply effect logic
      switch (effect.type) {
        case StatusEffectType.burn:
        case StatusEffectType.poison:
        case StatusEffectType.shock:
        case StatusEffectType.bleed:
        case StatusEffectType.corruption:
          // DOT Damage - use a safe version that doesn't trigger complex logic during tick
          final dotDamage = effect.value * effect.currentStack * dt * 10; // Scaling for tick
          hp -= dotDamage;
          if (hp <= 0) _die();
          break;
        case StatusEffectType.stun:
        case StatusEffectType.freeze:
          isStunned = true;
          break;
        case StatusEffectType.speedDown:
          speedMultiplier *= (1.0 - effect.value);
          break;
        default:
          break;
      }
    }

    for (final effect in toRemove) {
      statusEffects.remove(effect);
    }

    if (isStunned) {
      speed = 0;
    } else if (_freezeTimer <= 0) { // Legacy check
      speed = _originalSpeed * speedMultiplier;
    }
  }

  void applyStatus(StatusEffectData data, ElementType element) {
    try {
      final existing = statusEffects.where((e) => e.type == data.type).toList();
      if (existing.isNotEmpty) {
        existing.first.refresh();
      } else {
        statusEffects.add(StatusEffect(
          type: data.type,
          duration: data.duration,
          value: data.value,
          maxStack: data.maxStack,
          element: element,
        ));
      }

      // Visual feedback for status
      if (data.type == StatusEffectType.stun || data.type == StatusEffectType.freeze) {
        paint.color = Colors.cyan;
      } else if (data.type == StatusEffectType.burn) {
        paint.color = Colors.orange;
      } else if (data.type == StatusEffectType.poison) {
        paint.color = Colors.green;
      }
    } catch (e) {
      print("Error applying status: $e");
    }
  }

  void _updateNormalPattern(double dt) {
    position.y += speed * dt;
  }

  void _updateBossPattern(double dt) {
    if (position.y < base.position.y - 250) {
      position.y += speed * dt;
    } else {
      _stateTimer += dt;
      if (_isMovingRight) {
        position.x += speed * 0.8 * dt;
        if (position.x > gameRef.size.x - 40) _isMovingRight = false;
      } else {
        position.x -= speed * 0.8 * dt;
        if (position.x < 40) _isMovingRight = true;
      }

      if (_stateTimer >= 3.0) {
        _shootProjectile();
        _stateTimer = 0;
      }
    }
  }

  void _shootProjectile() {
    gameRef.add(BossProjectile(
      startPos: position.clone(),
      damage: (damage / 2).toInt(),
    ));
  }

  void applyFreeze(double multiplier, double duration) {
    _freezeTimer = duration;
    speed = _originalSpeed * multiplier;
    paint.color = Colors.cyan;
  }

  void takeDamage(int dmg) {
    if (!isMounted) return;
    hp -= dmg;
    if (hp <= 0) {
      _die();
    } else {
      add(
        ColorEffect(
          Colors.white,
          EffectController(duration: 0.1, reverseDuration: 0.1),
        )
      );
    }
  }

  void _die() {
    if (isDying) return;
    isDying = true;
    onDestroyed?.call();
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.2)),
        RemoveEffect(),
      ]),
    );
  }

  void _destroy() {
    if (isDying) return;
    isDying = true;
    onDestroyed?.call();
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    if (definition.type == 'boss') {
      _drawBossShape(canvas, paint);
    } else {
      canvas.drawRect(size.toRect(), paint);
    }

    final hpPercent = (hp / definition.hp).clamp(0.0, 1.0);
    final bgP = Paint()..color = Colors.black54;
    final fgP = Paint()..color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(0, -10, size.x, 4), bgP);
    canvas.drawRect(Rect.fromLTWH(0, -10, size.x * hpPercent, 4), fgP);
  }

  void _drawBossShape(Canvas canvas, Paint p) {
    final path = Path();
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;
    for (int i = 0; i < 6; i++) {
      double angle = i * math.pi / 3;
      double x = center.dx + radius * math.cos(angle);
      double y = center.dy + radius * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.5)..style = PaintingStyle.stroke..strokeWidth = 2);
  }
}

class BossProjectile extends PositionComponent with HasGameRef<OverflowDefenseGame> {
  final Vector2 startPos;
  final int damage;
  final double speed = 150;
  BossProjectile({required this.startPos, required this.damage}) : super(position: startPos, size: Vector2.all(12), anchor: Anchor.center);
  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y >= gameRef.playerBase.position.y) {
      gameRef.playerBase.takeDamage(damage);
      removeFromParent();
    }
  }
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(size.x/2, size.y/2), size.x/2, Paint()..color = Colors.purpleAccent);
    canvas.drawCircle(Offset(size.x/2, size.y/2), size.x/3, Paint()..color = Colors.white);
  }
}
