import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_defence/game/overflow_game.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:game_defence/config/game_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EventBus eventBus;
  late PlayerDataManager playerDataManager;

  setUp(() {
    eventBus = EventBus();
    // Ensure GameStats is initialized for the game
    GameStats.instance = GameStats.forTest();
    playerDataManager = PlayerDataManager(eventBus: eventBus);
  });

  group('OverflowDefenseGame', () {
    testWithGame<OverflowDefenseGame>(
      'loads correctly',
      () => OverflowDefenseGame(
        playerDataManager: playerDataManager,
        eventBus: eventBus,
      ),
      (game) async {
        expect(game.isLoaded, isTrue);
      },
    );
  });
}