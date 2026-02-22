// lib/game/ui/wave_display.dart
//
// A HUD component that displays the current wave progress.
// Responsibilities:
// - Showing the current wave number.
// - Displaying a countdown timer when waiting for the next wave to start.
// - Hiding the countdown when a wave is active.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/l10n/app_localizations.dart';

class WaveDisplay extends PositionComponent
    with HasGameRef<OverflowDefenseGame> {
  late TextComponent _waveText;
  late TextComponent _countdownText;
  late TextComponent _waveClearedText;
  final Locale locale;
  late AppLocalizations l10n;
  bool _isShowingWaveCleared = false;

  WaveDisplay({required this.locale});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    l10n = AppLocalizations(locale);

    _waveText = TextComponent(
      text: '${l10n.wave} 1',
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'NanumGothic',
          color: Colors.white,
          fontSize: 24.0,
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
      position: Vector2(gameRef.size.x / 2, 50),
      anchor: Anchor.center,
    );

    _countdownText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'NanumGothic',
          color: Colors.white,
          fontSize: 18.0,
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      position: Vector2(gameRef.size.x / 2, 80),
      anchor: Anchor.center,
    );

    _waveClearedText = TextComponent(
      text: l10n.waveCleared,
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'NanumGothic',
          color: Colors.amber,
          fontSize: 32.0,
          shadows: [
            Shadow(
              blurRadius: 7.0,
              color: Colors.black.withOpacity(0.7),
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
      position: Vector2(gameRef.size.x / 2, 120),
      anchor: Anchor.center,
    );

    add(_waveText);
    add(_countdownText);

    gameRef.eventBus.on<WaveClearedEvent>((event) {
      _waveText.text = '${l10n.wave} ${event.waveNumber}';
      _showWaveCleared();
    });
  }

  void _showWaveCleared() {
    add(_waveClearedText);
    _isShowingWaveCleared = true;
    add(
      TimerComponent(
        period: 2.0,
        onTick: () {
          remove(_waveClearedText);
          _isShowingWaveCleared = false;
        },
        removeOnFinish: true,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final waveManager = gameRef.waveManager;
    _waveText.text = '${l10n.wave} ${waveManager.currentWaveNumber}';

    if (_isShowingWaveCleared) {
      _countdownText.text = '';
      return;
    }

    if (!waveManager.isSpawning && waveManager.currentWaveEnemiesCleared) {
      _countdownText.text =
          '${l10n.nextWaveIn} ${waveManager.nextWaveCountdown.toStringAsFixed(1)}s';
    } else {
      _countdownText.text = '';
    }
  }
}
