import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

import 'package:game_defence/game/events/event_bus.dart';
import 'l10n/app_localizations.dart';
import 'game/overflow_game.dart';
import 'menu/pages/home_page.dart';
import 'menu/pages/shop_page.dart';
import 'menu/pages/inventory_page.dart';
import 'menu/pages/character_page.dart';
import 'menu/pages/skill_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GameStats.initialize(); // ← 여기서 미리 로딩
  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final PlayerDataManager _playerDataManager;
  late final EventBus _gameEventBus;
  bool _showGame = false;
  int _selectedIndex = 2; // Default to Home
  Locale _locale = const Locale('ko'); // 기본값은 한국어

  @override
  void initState() {
    super.initState();
    _gameEventBus = EventBus();
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
    final pages = [
      const ShopPage(),
      const InventoryPage(),
      HomePage(
        onStartGame: _startGame,
        locale: _locale,
        onToggleLocale: () => setState(() {
          _locale = _locale == const Locale('ko')
              ? const Locale('en')
              : const Locale('ko');
        }),
      ),
      const CharacterPage(),
      const SkillPage(),
    ];

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
            ? GameWidget(
                game: OverflowDefenseGame(
                  locale: _locale,
                  onExit: _returnToMenu,
                  playerDataManager: _playerDataManager,
                  eventBus: _gameEventBus,
                ),
              )
            : Scaffold(
                body: pages[_selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.store),
                      label: '상점',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.inventory),
                      label: '인벤토리',
                    ),
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: '캐릭터',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      label: '스킬',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  unselectedItemColor: Colors.grey,
                  backgroundColor: const Color(0xFF1a1a2e),
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
                ),
              ),
      ),
    );
  }
}
