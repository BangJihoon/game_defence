import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';

class GameBackground extends PositionComponent with HasGameReference<OverflowDefenseGame> {
  Sprite? _roadSprite;

  GameBackground() : super(priority: -100); // 아주 낮게 설정

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 초기 크기 설정
    size = game.size;
    
    final roadPath = game.playerDataManager.activeTemple.roadAssetPath;
    try {
      _roadSprite = await game.loadSprite(roadPath);
    } catch (e) {
      // 로드 실패 시 에러 출력 및 폴백으로 진행
      debugPrint("GameBackground Error: Failed to load $roadPath. Using fallback gradient. $e");
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    // 1. 도로 이미지 또는 폴백 그라데이션 그리기
    if (_roadSprite != null) {
      _roadSprite!.render(
        canvas,
        size: size,
      );
      // 가독성을 위해 살짝 어둡게 (0.3 -> 0.2로 조정하여 더 밝게 보이게 함)
      canvas.drawRect(size.toRect(), Paint()..color = Colors.black.withValues(alpha: 0.2));
    } else {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0f1419),
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
          ],
        ).createShader(size.toRect());
      canvas.drawRect(size.toRect(), gradientPaint);
    }

    // 2. 별 효과 추가
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    for (int i = 0; i < 20; i++) {
      final x = (i * 53.7) % size.x;
      final y = (i * 19.3) % (size.y * 0.5);
      canvas.drawCircle(Offset(x, y), 1.0, starPaint);
    }
  }
}
