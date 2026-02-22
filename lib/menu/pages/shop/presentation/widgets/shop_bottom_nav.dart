import 'package:flutter/material.dart';

class ShopBottomNav extends StatelessWidget {
  const ShopBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF3C2F45),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: "상점",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield),
          label: "장비",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_martial_arts),
          label: "전투",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: "도감",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "설정",
        ),
      ],
    );
  }
}