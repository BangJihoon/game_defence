import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

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
  await GameStats.initialize(); // Preload game stats
  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final PlayerDataManager _playerDataManager;
  bool _showGame = false;
  int _selectedIndex = 2; // Default to Home
  Locale _locale = const Locale('ko'); // 기본값은 한국어

  @override
  void initState() {
    super.initState();
    _playerDataManager = PlayerDataManager();
  }

  @override
  void dispose() {
    _playerDataManager.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _showGame = true;
    });
  }

  void _returnToMenu() {
    setState(() {
      _showGame = false;
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ko' 
          ? const Locale('en') 
          : const Locale('ko');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ShopPage(),
      const InventoryPage(),
      HomePage(
        onStartGame: _startGame,
        locale: _locale,
        onToggleLocale: _toggleLocale,
      ),
      const CharacterPage(),
      const SkillPage(),
    ];

    return ChangeNotifierProvider.value(
      value: _playerDataManager,
      child: MaterialApp(
        title: 'Defense Game',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: _showGame
            ? GameWidget(
                game: OverflowDefenseGame(locale: _locale, playerDataManager: _playerDataManager),
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
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '홈',
                    ),
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