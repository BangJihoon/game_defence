// lib/menu/pages/shop_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/shop_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: const Text('상점'),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Consumer<PlayerDataManager>(
        builder: (context, playerDataManager, child) {
          final currencies = playerDataManager.playerData.currencies;
          final shopItems = playerDataManager.shopItems;

          return Column(
            children: [
              // Currency Display
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.yellow),
                    const SizedBox(width: 4),
                    Text(
                      '${currencies['gold'] ?? 0}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.diamond, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      '${currencies['gems'] ?? 0}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Shop Item List
              Expanded(
                child: ListView.builder(
                  itemCount: shopItems.length,
                  itemBuilder: (context, index) {
                    final item = shopItems[index];
                    return _buildShopItemTile(context, item, playerDataManager);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShopItemTile(
      BuildContext context, ShopItem item, PlayerDataManager playerDataManager) {
    final canAfford = playerDataManager.canAfford(item);
    final costString = item.cost.entries
        .map((e) => '${e.value} ${e.key == 'gems' ? '💎' : 'G'}')
        .join(', ');

    return Card(
      color: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white, size: 40),
        title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(item.description, style: TextStyle(color: Colors.white.withOpacity(0.7))),
        trailing: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(costString, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: canAfford ? () => playerDataManager.purchaseItem(item) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.green.shade700 : Colors.grey.shade800,
                ),
                child: const Text('구매'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
