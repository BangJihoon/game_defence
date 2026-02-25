import 'package:flutter/material.dart';
import 'home_page.dart';
import 'shop/presentation/pages/shop_page.dart';
import 'character/presentation/pages/character_page.dart';
import 'inventory_page.dart';
import 'skill_page.dart';

class MainMenuShell extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final VoidCallback onStartGame;
  final VoidCallback onToggleLocale;
  final Locale locale;

  const MainMenuShell({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.onStartGame,
    required this.onToggleLocale,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ShopPage(),
      const CharacterPage(),
      HomePage(
        onStartGame: onStartGame,
        locale: locale,
        onToggleLocale: onToggleLocale,
      ),
      const InventoryPage(),
      const SkillPage(),
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1a1a2e),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: '상점'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: '캐릭터'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '인벤토리'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '스킬'),
        ],
      ),
    );
  }
}