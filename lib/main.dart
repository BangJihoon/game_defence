import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_defence/config/game_config.dart'; 
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

import 'package:game_defence/game/events/event_bus.dart';
import 'l10n/app_localizations.dart';
import 'game/overflow_game.dart';
import 'package:game_defence/menu/pages/main_menu_shell.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GameStats.initialize();
  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final PlayerDataManager _playerDataManager;
  EventBus _gameEventBus = EventBus();
  bool _showGame = false;
  int _selectedIndex = 2; 
  Locale _locale = const Locale('ko'); 

  @override
  void initState() {
    super.initState();
    _playerDataManager = PlayerDataManager(eventBus: _gameEventBus);
  }

  @override
  void dispose() {
    _playerDataManager.dispose();
    _gameEventBus.dispose();
    super.dispose();
  }

  void _returnToMenu() {
    setState(() {
      _showGame = false;
      _gameEventBus.dispose(); 
      _gameEventBus = EventBus(); 
      _playerDataManager.updateEventBus(_gameEventBus);
    });
  }

  void _startGame() {
    setState(() {
      _showGame = true;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: _playerDataManager)],
      child: MaterialApp(
        title: 'Overflow Defense',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ko')],
        locale: _locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NanumGothic',
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: _showGame
            ? Material(
                color: Colors.black,
                child: GameWidget(
                  key: UniqueKey(),
                  game: OverflowDefenseGame(
                    locale: _locale,
                    onExit: _returnToMenu,
                    playerDataManager: _playerDataManager,
                    eventBus: _gameEventBus,
                  ),
                ),
              )
            : MainMenuShell(
                selectedIndex: _selectedIndex,
                onTabChanged: _onItemTapped,
                locale: _locale,
                onStartGame: _startGame,
                onToggleLocale: () {
                  setState(() {
                    _locale = _locale == const Locale('ko')
                        ? const Locale('en')
                        : const Locale('ko');
                  });
                },
              ),
      ),
    );
  }
}
