import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/game/overflow_game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('OverflowDefenseGame', () {
    final flameGame = FlameGame();

    testWithGame<OverflowDefenseGame>(
      'loads correctly',
      () => OverflowDefenseGame(),
      (game) async {
        await flameGame.add(game);
        await flameGame.ready();
        expect(game.isLoaded, isTrue);
      },
    );
  });
}
