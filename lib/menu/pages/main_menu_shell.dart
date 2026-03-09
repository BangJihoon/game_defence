import 'package:flutter/material.dart';
import 'home_page.dart';
import 'shop/presentation/pages/shop_page.dart';
import 'character/presentation/pages/character_page.dart';
import 'inventory_page.dart';
import 'item_page.dart';

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
      const ItemPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '캐릭터'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: '신전'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_fix_high), label: '아이템'),
        ],
      ),
    );
  }
}
