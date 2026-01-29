// lib/menu/pages/shop_page.dart
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상점'),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Container(
        color: const Color(0xFF16213e),
        child: const Center(
          child: Text(
            '상점 페이지',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
