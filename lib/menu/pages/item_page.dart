// lib/menu/pages/item_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('신비 도구 저장소', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildCurrencyInfo(Icons.monetization_on, pdm.gold.toString(), Colors.yellow),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // 1. 장착 현황 요약 (슬롯 디자인)
          _buildToolSlotHeader(pdm),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('도구 목록', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          // 2. 도구 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pdm.mysticTools.length,
              itemBuilder: (context, index) {
                final tool = pdm.mysticTools[index];
                return _buildToolListTile(tool, pdm);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyInfo(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildToolSlotHeader(PlayerDataManager pdm) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withOpacity(0.15), Colors.black26],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('전투 장착 슬롯', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              if (pdm.toolSlots < 5)
                GestureDetector(
                  onTap: () => pdm.unlockToolSlot(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Text('슬롯 확장 +', style: TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(pdm.toolSlots, (index) {
              final toolId = index < pdm.equippedToolIds.length ? pdm.equippedToolIds[index] : null;
              final tool = toolId != null ? pdm.mysticTools.firstWhere((it) => it.id == toolId) : null;
              
              return Container(
                width: 54,
                height: 54,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tool != null ? tool.color : Colors.white10, width: 1.5),
                  boxShadow: tool != null ? [BoxShadow(color: tool.color.withOpacity(0.2), blurRadius: 8)] : [],
                ),
                child: tool != null 
                  ? IconButton(
                      icon: Icon(tool.icon, color: tool.color, size: 24),
                      onPressed: () => pdm.unequipTool(tool.id),
                    )
                  : const Icon(Icons.add, color: Colors.white10, size: 20),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToolListTile(GameItem tool, PlayerDataManager pdm) {
    final isOwned = pdm.ownedToolIds.contains(tool.id);
    final isEquipped = pdm.equippedToolIds.contains(tool.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isEquipped ? tool.color.withOpacity(0.5) : Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: tool.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tool.icon, color: tool.color, size: 28),
        ),
        title: Text(tool.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(tool.description, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        trailing: _buildActionButton(tool, pdm, isOwned, isEquipped),
      ),
    );
  }

  Widget _buildActionButton(GameItem tool, PlayerDataManager pdm, bool isOwned, bool isEquipped) {
    if (!isOwned) {
      return ElevatedButton(
        onPressed: pdm.gold >= tool.goldCost ? () => pdm.buyTool(tool.id) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade800,
          minimumSize: const Size(70, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text('${tool.goldCost}G', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    } else {
      return OutlinedButton(
        onPressed: isEquipped ? () => pdm.unequipTool(tool.id) : () => pdm.equipTool(tool.id),
        style: OutlinedButton.styleFrom(
          foregroundColor: isEquipped ? Colors.redAccent : Colors.cyanAccent,
          side: BorderSide(color: isEquipped ? Colors.redAccent : Colors.cyanAccent),
          minimumSize: const Size(70, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(isEquipped ? '해제' : '장착', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }
  }
}
