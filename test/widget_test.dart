import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/player/player_data_manager.dart';

// Mock classes
class MockPlayerDataManager extends PlayerDataManager {
  MockPlayerDataManager() : super();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('OverflowDefenseGame', () {
    final flameGame = FlameGame();

    testWithGame<OverflowDefenseGame>(
      'loads correctly',
      () => OverflowDefenseGame(playerDataManager: MockPlayerDataManager()),
      (game) async {
        await flameGame.add(game);
        await flameGame.ready();
        expect(game.isLoaded, isTrue);
      },
    );
  });
}
