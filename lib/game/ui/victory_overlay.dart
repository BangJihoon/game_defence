import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class VictoryOverlay extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  final int score;
  final Locale locale;
  final VoidCallback onExit;

  VictoryOverlay({
    required this.score,
    required this.locale,
    required this.onExit,
  }) : super(priority: 500); // 가장 위에 표시

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;
    final l10n = AppLocalizations(locale);

    // 1. 반투명 배경 (애니메이션 느낌을 위해 약간 투명하게)
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withValues(alpha: 0.85),
    ));

    final center = size / 2;

    // 2. 승리 타이틀 (금색)
    add(TextComponent(
      text: 'VICTORY!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.amber,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
          shadows: [
            Shadow(color: Colors.orangeAccent, blurRadius: 20, offset: Offset(0, 4)),
            Shadow(color: Colors.black, blurRadius: 10)
          ],
        ),
      ),
      anchor: Anchor.center,
      position: center - Vector2(0, 140),
    ));

    // 3. 보상 정보 박스
    final infoBox = RectangleComponent(
      size: Vector2(300, 160),
      position: center - Vector2(0, 10),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.white.withValues(alpha: 0.1),
    )..add(RectangleComponent(
      size: Vector2(300, 160),
      paint: Paint()..color = Colors.amber.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2,
    ));
    add(infoBox);

    // 4. 점수 및 보상 텍스트
    add(TextComponent(
      text: '모든 웨이브 클리어 성공!\n\n최종 점수: $score\n획득 코인: ${score ~/ 10}\n보너스 보석: 5개',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 22, 
          height: 1.6,
          fontWeight: FontWeight.w500
        ),
      ),
      anchor: Anchor.center,
      position: center - Vector2(0, 10),
    ));

    // 5. [종료 및 메뉴로] 버튼
    final exitButton = RectangleComponent(
      size: Vector2(240, 64),
      position: center + Vector2(0, 150),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.blueAccent,
    )..add(TextComponent(
        text: '메뉴로 돌아가기',
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
        ),
        anchor: Anchor.center,
        position: Vector2(120, 32),
      ));
    
    add(exitButton);
  }

  @override
  void onMount() {
    super.onMount();
    // 팝업이 뜨면 게임 일시정지
    gameRef.paused = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final center = size / 2;
    // 버튼 영역 클릭 판정 (버튼 크기와 위치에 맞춤)
    final buttonRect = Rect.fromCenter(
      center: Offset(center.x, center.y + 150), 
      width: 240, 
      height: 64
    );
    
    if (buttonRect.contains(event.localPosition.toOffset())) {
      gameRef.paused = false; // 일시정지 해제
      onExit(); // 메인 메뉴로 이동
    }
  }
}
