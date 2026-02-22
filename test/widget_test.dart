import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/player/player_data_manager.dart';

class MockPlayerDataManager extends PlayerDataManager {
  MockPlayerDataManager({required super.eventBus});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('OverflowDefenseGame', () {
    late OverflowDefenseGame game;

    setUp(() async {
      await GameStats.initialize();
      final eventBus = EventBus();
      final playerDataManager = MockPlayerDataManager(eventBus: eventBus);
      game = OverflowDefenseGame(
          eventBus: eventBus, playerDataManager: playerDataManager);
    });

    testWidgets('loads correctly', (WidgetTester tester) async {
      final flameGame = FlameGame();
      await flameGame.add(game);
      await flameGame.ready();
      expect(game.isLoaded, isTrue);
    });
  });
}
