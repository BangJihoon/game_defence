import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../effects/explosion_effect.dart';
import '../overflow_game.dart';

class TapInputLayer extends Component
    with TapCallbacks, HasGameRef<OverflowDefenseGame> {
  @override
  void onTapDown(TapDownEvent event) {
    // 게임 오버 상태면 입력 무시
    if (game.isGameOver) return;

    // 월드 좌표로 변환
    final pos = event.localPosition;

    // 폭발 이펙트
    game.add(ExplosionEffect(pos));

    // 적 데미지
    game.enemySystem.damageInRadius(pos, game.gameStats.explosionRadius, game.gameStats.explosionDamage);

    // 폭발 사운드 재생
    game.playExplosionSound();
  }
}
