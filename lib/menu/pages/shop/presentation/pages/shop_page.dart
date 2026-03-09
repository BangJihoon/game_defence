// lib/menu/pages/shop/presentation/pages/shop_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/shop_header.dart';
import 'package:game_defence/menu/pages/shop/presentation/widgets/section_title.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const ShopHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SectionTitle("오늘의 특별 제안"),
                    const DailyDealsGrid(),
                    const SizedBox(height: 20),
                    const CategorizedShopTabs(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyDealsGrid extends StatelessWidget {
  const DailyDealsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dailyItems = [
      {'title': '할인', 'icon': Icons.local_offer, 'color': Colors.orangeAccent},
      {'title': '구독', 'icon': Icons.calendar_month, 'color': Colors.blueAccent},
      {'title': 'VIP', 'icon': Icons.workspace_premium, 'color': Colors.purpleAccent},
      {'title': '무료', 'icon': Icons.ads_click, 'color': Colors.greenAccent},
      {'title': '보석', 'icon': Icons.diamond, 'color': Colors.cyanAccent},
      {'title': '골드', 'icon': Icons.monetization_on, 'color': Colors.yellowAccent},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3열 유지하되 크기 조절
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1, 
        ),
        itemCount: dailyItems.length,
        itemBuilder: (context, index) {
          final item = dailyItems[index];
          return ShopItemTile(
            title: item['title'],
            icon: item['icon'],
            color: item['color'],
            isSmall: true,
          );
        },
      ),
    );
  }
}

class ShopItemTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSmall;
  final bool isAd;
  final String price;

  const ShopItemTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.isSmall = false,
    this.isAd = false,
    this.price = '100',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), Colors.black45],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isSmall ? 24 : 32),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: isSmall ? 11 : 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          if (!isSmall && !isAd) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.diamond, size: 12, color: Colors.cyanAccent),
                const SizedBox(width: 4),
                Text(price, style: const TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ],
          if (isAd) 
            const Text('FREE', style: TextStyle(fontSize: 10, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class CategorizedShopTabs extends StatelessWidget {
  const CategorizedShopTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [Tab(text: '캐릭터'), Tab(text: '재물'), Tab(text: '스킬')],
            labelColor: Colors.amberAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.amberAccent,
            dividerColor: Colors.transparent,
          ),
          SizedBox(
            height: 350,
            child: TabBarView(
              children: [
                _buildTabContent('캐릭터', Icons.person, Colors.blueAccent),
                _buildTabContent('재물', Icons.account_balance, Colors.orangeAccent),
                _buildTabContent('스킬', Icons.bolt, Colors.purpleAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String type, IconData icon, Color color) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ShopItemTile(title: '무료 획득', icon: Icons.video_library, color: Colors.greenAccent, isAd: true);
        }
        return ShopItemTile(title: '$type $index', icon: icon, color: color);
      },
    );
  }
}
