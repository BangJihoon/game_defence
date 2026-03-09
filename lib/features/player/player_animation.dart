// lib/features/player/player_animation.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';
import 'player_state.dart';
import '../../core/constants/animation_constants.dart';
import '../../game/overflow_game.dart';

class PlayerAnimationManager {
  static Future<Map<PlayerState, SpriteAnimation>> loadAnimations({
    required HasGameRef<OverflowDefenseGame> gameRef,
    required String basePath, // e.g., 'characters/michael'
    Map<PlayerState, int>? frameCounts,
  }) async {
    final Map<PlayerState, SpriteAnimation> animations = {};

    // Use provided frame counts or defaults from constants
    final frames = frameCounts ?? {
      PlayerState.idle: AnimationConstants.idleFrames,
      PlayerState.run: AnimationConstants.runFrames,
      PlayerState.attack: AnimationConstants.attackFrames,
      PlayerState.hit: AnimationConstants.hitFrames,
    };

    for (final state in PlayerState.values) {
      List<String> possibleFileNames = [state.name];
      
      if (state == PlayerState.idle) {
        possibleFileNames = ['idle_front', 'front', 'idle'];
      } else if (state == PlayerState.run) {
        possibleFileNames = ['idle_back', 'back', 'run'];
      }

      final int frameCount = frames[state] ?? 1;
      
      bool loaded = false;
      for (final fileName in possibleFileNames) {
        try {
          final image = await gameRef.game.images.load('$basePath/$fileName.png');
          
          final double frameWidth = image.width / frameCount;
          final double frameHeight = image.height.toDouble();

          final SpriteSheet spriteSheet = SpriteSheet(
            image: image,
            srcSize: Vector2(frameWidth, frameHeight),
          );

          animations[state] = spriteSheet.createAnimation(
            row: 0,
            stepTime: AnimationConstants.stepTime,
            to: frameCount,
            loop: state == PlayerState.idle || state == PlayerState.run,
          );
          loaded = true;
          break; // Exit filenames loop once loaded
        } catch (_) {
          // Continue to next possible filename
        }
      }

      if (!loaded) {
        print('Error: Could not load animation for state ${state.name} in $basePath. Using fallback.');
        // Create a simple placeholder animation (single transparent frame or similar)
        // Since we can't easily create an image in memory without a platform, 
        // we'll just skip adding this animation to the map.
        // The Component will need to handle missing animations gracefully.
      }
    }

    return animations;
  }
}
