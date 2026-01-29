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
        return _buildInventoryItem(context, inventoryItems[index], playerDataManager);
      },
    );
  }

  Widget _buildInventoryItem(BuildContext context, InventoryItem item, PlayerDataManager playerDataManager) {
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
                playerDataManager.equipItem(item.id);
              } else {
                // For non-equippable items (scrolls), show a dialog to select target slot
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('${item.name}을(를) 사용할 슬롯 선택'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: EquipmentType.values.length,
                          itemBuilder: (BuildContext context, int index) {
                            final type = EquipmentType.values[index];
                            String typeName = type.name;
                            switch(type) {
                              case EquipmentType.hat: typeName = '모자'; break;
                              case EquipmentType.armor: typeName = '갑옷'; break;
                              case EquipmentType.weapon: typeName = '무기'; break;
                              case EquipmentType.necklace: typeName = '목걸이'; break;
                              case EquipmentType.ring: typeName = '반지'; break;
                              case EquipmentType.shoe: typeName = '신발'; break;
                            }
                            return ListTile(
                              title: Text(typeName),
                              onTap: () {
                                playerDataManager.useScroll(item.id, type);
                                Navigator.of(dialogContext).pop(); // Close the dialog
                              },
                            );
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('취소'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
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
}
