// lib/menu/pages/home_page.dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_defence/menu/main_menu.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onStartGame;
  final Locale locale;
  final VoidCallback onToggleLocale;

  const HomePage({
    super.key,
    required this.onStartGame,
    required this.locale,
    required this.onToggleLocale,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MainMenuGame _mainMenuGame;

  @override
  void initState() {
    super.initState();
    _mainMenuGame = MainMenuGame(
      onStartGame: widget.onStartGame,
      locale: widget.locale,
      onToggleLocale: widget.onToggleLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _mainMenuGame);
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
