// lib/features/player/player_animation.dart
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'player_state.dart';
import '../../core/constants/animation_constants.dart';

class PlayerAnimationManager {
  static Future<Map<PlayerState, SpriteAnimation>> loadAnimations({
    required HasGameRef gameRef,
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
      String fileName = state.name; // This will use 'idle', 'run', 'attack', 'hit'
      
      final int frameCount = frames[state] ?? 1;
      
      try {
        final image = await gameRef.images.load('$basePath/$fileName.png');
        
        // Assuming the SpriteSheet is a single row of frames
        // We calculate srcSize based on image width / frameCount if it's unknown
        // For now, let's assume frames are square or fixed size
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
      } catch (e) {
        print('Error loading animation $fileName for $basePath: $e');
      }
    }

    return animations;
  }
}
