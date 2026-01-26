import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_defence/config/game_config.dart'; // Import GameStats

import 'l10n/app_localizations.dart';
import 'game/overflow_game.dart';
import 'menu/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameStats.load(); // Preload game stats
  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  OverflowDefenseGame? game;
  bool showMenu = true;
  Locale _locale = const Locale('ko'); // 기본값은 한국어

  void startGame() {
    setState(() {
      game = OverflowDefenseGame(locale: _locale);
      showMenu = false;
    });
  }

  void returnToMenu() {
    setState(() {
      game = null;
      showMenu = true;
    });
  }

  void toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ko' 
          ? const Locale('en') 
          : const Locale('ko');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: showMenu
          ? GameWidget(
              game: MainMenuGame(
                onStartGame: startGame,
                locale: _locale,
                onToggleLocale: toggleLocale,
              ),
            )
          : GameWidget(
              game: game!,
            ),
    );
  }
}

class MainMenuGame extends FlameGame {
  final VoidCallback onStartGame;
  final Locale locale;
  final VoidCallback onToggleLocale;

  MainMenuGame({
    required this.onStartGame,
    required this.locale,
    required this.onToggleLocale,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(MainMenu(
      onStartGame: onStartGame,
      locale: locale,
      onToggleLocale: onToggleLocale,
    ));
  }
}