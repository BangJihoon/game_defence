// lib/game/ui/settings_overlay.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/player/player_data_manager.dart';

class SettingsOverlay extends PositionComponent with HasGameRef<OverflowDefenseGame>, TapCallbacks {
  SettingsOverlay() : super(priority: 1000);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.size;

    // 반투명 배경
    add(RectangleComponent(size: size, paint: Paint()..color = Colors.black.withValues(alpha: 0.8)));

    final center = size / 2;
    const boxWidth = 280.0;
    const boxHeight = 320.0;

    // 설정창 박스
    add(RectangleComponent(
      size: Vector2(boxWidth, boxHeight),
      position: center,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF22223B),
    )..add(RectangleComponent(
      size: Vector2(boxWidth, boxHeight),
      paint: Paint()..color = Colors.cyanAccent.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2,
    )));

    // 타이틀
    add(TextComponent(
      text: '게임 설정',
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      anchor: Anchor.topCenter,
      position: center - Vector2(0, boxHeight / 2 - 20),
    ));

    // --- 설정 항목들 ---
    _buildToggle(center - Vector2(0, 60), '사운드 효과', gameRef.playerDataManager.soundEnabled, () {
      gameRef.playerDataManager.toggleSound();
      _refresh();
    });

    _buildToggle(center - Vector2(0, 0), '진동 피드백', gameRef.playerDataManager.vibrationEnabled, () {
      gameRef.playerDataManager.toggleVibration();
      _refresh();
    });

    // 닫기 버튼
    final closeBtn = RectangleComponent(
      size: Vector2(120, 44),
      position: center + Vector2(0, 100),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.cyan.shade800,
    )..add(TextComponent(
      text: '확인',
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      anchor: Anchor.center,
      position: Vector2(60, 22),
    ));
    add(closeBtn);
  }

  void _buildToggle(Vector2 pos, String label, bool value, VoidCallback onTap) {
    add(TextComponent(
      text: label,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white70, fontSize: 16)),
      anchor: Anchor.centerLeft,
      position: pos - Vector2(100, 0),
    ));

    final toggle = RectangleComponent(
      size: Vector2(60, 30),
      position: pos + Vector2(70, 0),
      anchor: Anchor.center,
      paint: Paint()..color = value ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.5),
    )..add(TextComponent(
      text: value ? 'ON' : 'OFF',
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      anchor: Anchor.center,
      position: Vector2(30, 15),
    ));
    
    // 단순화를 위해 여기에 직접 탭 콜백 연동 대신 Rectangle에 투명 버튼을 얹는 식으로 처리 가능하나 
    // 여기서는 전체 영역 클릭 판정으로 간단히 처리
    add(toggle);
  }

  void _refresh() {
    removeAll(children);
    onLoad();
  }

  @override
  void onMount() { super.onMount(); gameRef.paused = true; }

  @override
  void onTapUp(TapUpEvent event) {
    final center = size / 2;
    // 닫기 버튼 영역 클릭 시
    if (Rect.fromCenter(center: Offset(center.x, center.y + 100), width: 120, height: 44).contains(event.localPosition.toOffset())) {
      gameRef.paused = false;
      removeFromParent();
    }
    // 사운드 토글 영역
    if (Rect.fromCenter(center: Offset(center.x + 70, center.y - 60), width: 60, height: 30).contains(event.localPosition.toOffset())) {
      gameRef.playerDataManager.toggleSound();
      _refresh();
    }
    // 진동 토글 영역
    if (Rect.fromCenter(center: Offset(center.x + 70, center.y), width: 60, height: 30).contains(event.localPosition.toOffset())) {
      gameRef.playerDataManager.toggleVibration();
      _refresh();
    }
  }
}
