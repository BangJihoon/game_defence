import 'package:flutter/material.dart';
import 'widgets/equipped_items_view.dart';
import 'widgets/inventory_list_view.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: const Text('인벤토리'),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Column(
        children: const [
          Expanded(
            child: EquippedItemsView(),
          ),
          Divider(
            color: Colors.blueGrey,
            height: 4,
            thickness: 2,
          ),
          Expanded(
            child: InventoryListView(),
          ),
        ],
      ),
    );
  }
}
