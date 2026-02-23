import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final playerDataManager = Provider.of<PlayerDataManager>(context);
    final inventoryItems = playerDataManager.playerData.inventory;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: inventoryItems.length,
      itemBuilder: (context, index) {
        return _buildInventoryItem(context, playerDataManager, inventoryItems[index]);
      },
    );
  }

  Widget _buildInventoryItem(BuildContext context, PlayerDataManager manager, InventoryItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Icon
          Icon(item.icon, color: Colors.white, size: 40),
          // Name
          Text(
            item.name,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          // Action Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              if (item.equipmentType != null) {
                manager.equipItem(item);
              } else {
                // Handle scroll/use items
                if (item.id.contains('scroll') || item.name.contains('주문서')) {
                  _showUpgradeSlotDialog(context, manager, item);
                } else {
                  print("Used item: ${item.name}");
                }
              }
            },
            child: Text(
              item.equipmentType != null ? '장착' : '사용',
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  void _showUpgradeSlotDialog(BuildContext context, PlayerDataManager manager, InventoryItem scroll) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text('강화할 슬롯 선택', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: EquipmentType.values.map((type) {
              return ListTile(
                title: Text(type.name.toUpperCase(), style: TextStyle(color: Colors.white)),
                onTap: () {
                  manager.upgradeSlot(type, scroll.id);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
