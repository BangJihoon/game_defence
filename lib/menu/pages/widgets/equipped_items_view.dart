import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class EquippedItemsView extends StatelessWidget {
  const EquippedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final playerDataManager = Provider.of<PlayerDataManager>(context);
    final equipmentSlots = playerDataManager.playerData.equipmentSlots;

    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        final radius = math.min(constraints.maxWidth, constraints.maxHeight) * 0.35;

        return Stack(
          alignment: Alignment.center,
          children: [
            // 1. Character Placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.pink.shade200,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(child: Text('캐릭터', style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            
            // 2. Equipment Slots
            ...equipmentSlots.asMap().entries.map((entry) {
              final index = entry.key;
              final slot = entry.value;
              final equippedItem = playerDataManager.playerData.equippedItems[slot.type]; // Get equipped item
              final angle = (2 * math.pi / equipmentSlots.length) * index - (math.pi / 2);
              final x = center.dx + radius * math.cos(angle) - constraints.maxWidth / 2;
              final y = center.dy + radius * math.sin(angle) - constraints.maxHeight / 2;

              return Transform.translate(
                offset: Offset(x, y),
                child: _buildEquipmentSlot(slot, equippedItem, playerDataManager),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildEquipmentSlot(
      EquipmentSlotState slot, InventoryItem? equippedItem, PlayerDataManager playerDataManager) {
    String name = slot.type.name;
    switch(slot.type) {
      case EquipmentType.hat: name = '모자'; break;
      case EquipmentType.armor: name = '갑옷'; break;
      case EquipmentType.weapon: name = '무기'; break;
      case EquipmentType.necklace: name = '목걸이'; break;
      case EquipmentType.ring: name = '반지'; break;
      case EquipmentType.shoe: name = '신발'; break;
    }

    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Item Icon or Slot Name
          if (equippedItem != null)
            Icon(equippedItem.icon, color: Colors.amber, size: 40)
          else
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          
          // Item Name or Slot Level
          if (equippedItem != null)
            Text(
              equippedItem.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          else
            Text(
              '(Lv. ${slot.level})',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          
          // Unequip Button or Socket Info
          if (equippedItem != null)
            ElevatedButton(
              onPressed: () {
                playerDataManager.unequipItem(slot.type);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '해제',
                style: TextStyle(fontSize: 10),
              ),
            )
          else
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(slot.maxSockets, (index) {
                final bool isSocketed = slot.sockets[index] != null;
                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isSocketed ? Colors.purple.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: isSocketed ? Colors.purple : Colors.grey.shade700),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
