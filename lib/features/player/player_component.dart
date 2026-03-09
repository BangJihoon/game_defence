// lib/features/player/player_component.dart
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'player_animation.dart';
import 'player_state.dart';

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState> with HasGameRef {
  final String characterPath;
  final Map<PlayerState, int>? frameCounts;
  
  PlayerComponent({
    required this.characterPath,
    this.frameCounts,
    Vector2? position,
    Vector2? size,
  }) : super(
    position: position,
    size: size ?? Vector2.all(64),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load animations using the animation manager
    animations = await PlayerAnimationManager.loadAnimations(
      gameRef: gameRef,
      basePath: characterPath,
      frameCounts: frameCounts,
    );
    
    // Set initial state
    current = PlayerState.idle;
  }

  void updateState(PlayerState newState) {
    if (current == newState) return;
    
    // Logic for state transitions if needed
    current = newState;
    
    // If it's a non-looping animation, we return to idle after it finishes
    if (newState == PlayerState.attack || newState == PlayerState.hit) {
      final animation = animations?[newState];
      if (animation != null) {
        animation.onComplete = () {
          if (current == newState) {
            current = PlayerState.idle;
            // Reset animation to start frame for next time
            animation.reset();
          }
        };
      }
    }
  }

  // Trigger attack
  void attack() {
    updateState(PlayerState.attack);
  }

  // Take damage
  void hit() {
    updateState(PlayerState.hit);
    // Visual feedback (shake)
    add(MoveByEffect(
      Vector2(5, 0),
      EffectController(duration: 0.05, alternate: true, repeatCount: 2),
    ));
  }

  // Move command (example)
  void move() {
    updateState(PlayerState.run);
  }

  void stopMoving() {
    updateState(PlayerState.idle);
  }
}
