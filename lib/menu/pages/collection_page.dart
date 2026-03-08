// lib/menu/pages/collection_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0, // 탭바만 보이도록
          bottom: const TabBar(
            tabs: [
              Tab(text: '룬 (Runes)'),
              Tab(text: '도구 (Items)'),
            ],
            indicatorColor: Colors.amberAccent,
            labelColor: Colors.amberAccent,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            _RuneTab(),
            _ItemTab(),
          ],
        ),
      ),
    );
  }
}

class _RuneTab extends StatelessWidget {
  const _RuneTab();

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    return Column(
      children: [
        // 룬 장착 슬롯
        _buildRuneSlots(pdm),
        const Divider(color: Colors.white10),
        // 룬 목록
        Expanded(child: _buildOfferingsGrid(pdm)),
      ],
    );
  }

  Widget _buildRuneSlots(PlayerDataManager pdm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pdm.runeSlots, (index) {
          final runeId = pdm.equippedRuneIds[index];
          final rune = runeId != null ? pdm.allOfferings.firstWhere((o) => o.id == runeId) : null;
          return Container(
            width: 50, height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: rune != null ? rune.color : Colors.white12, width: 2),
            ),
            child: rune != null ? Icon(rune.icon, color: rune.color, size: 28) : const Icon(Icons.add, color: Colors.white10, size: 20),
          );
        }),
      ),
    );
  }

  Widget _buildOfferingsGrid(PlayerDataManager pdm) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, 
        mainAxisSpacing: 12, 
        crossAxisSpacing: 12
      ),
      itemCount: pdm.allOfferings.length,
      itemBuilder: (context, index) {
        final offering = pdm.allOfferings[index];
        bool isEquippable = offering.suitableTemple == pdm.activeTemple.type;
        
        return GestureDetector(
          onTap: () {
            int emptyIdx = pdm.equippedRuneIds.indexOf(null);
            if (emptyIdx != -1) pdm.equipRune(emptyIdx, offering.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), 
              borderRadius: BorderRadius.circular(12), 
              border: Border.all(color: isEquippable ? offering.color.withOpacity(0.5) : Colors.white10)
            ),
            child: Icon(offering.icon, color: isEquippable ? offering.color : Colors.grey.withOpacity(0.3), size: 24),
          ),
        );
      },
    );
  }
}

class _ItemTab extends StatelessWidget {
  const _ItemTab();

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    return Column(
      children: [
        _buildToolSlotHeader(pdm),
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
    );
  }

  Widget _buildToolSlotHeader(PlayerDataManager pdm) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('전투 장착 슬롯', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              if (pdm.toolSlots < 5)
                GestureDetector(
                  onTap: () => pdm.unlockToolSlot(),
                  child: const Text('슬롯 확장 +', style: TextStyle(color: Colors.amberAccent, fontSize: 11)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(pdm.toolSlots, (index) {
              final toolId = index < pdm.equippedToolIds.length ? pdm.equippedToolIds[index] : null;
              final tool = toolId != null ? pdm.mysticTools.firstWhere((it) => it.id == toolId) : null;
              return Container(
                width: 48, height: 48,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: tool != null ? tool.color : Colors.white10),
                ),
                child: tool != null 
                  ? Icon(tool.icon, color: tool.color, size: 24)
                  : const Icon(Icons.add, color: Colors.white10, size: 18),
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(tool.icon, color: tool.color),
        title: Text(tool.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(tool.description, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        trailing: _buildActionButton(tool, pdm, isOwned, isEquipped),
      ),
    );
  }

  Widget _buildActionButton(GameItem tool, PlayerDataManager pdm, bool isOwned, bool isEquipped) {
    if (!isOwned) {
      return ElevatedButton(
        onPressed: pdm.gold >= tool.goldCost ? () => pdm.buyTool(tool.id) : null,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, minimumSize: const Size(60, 30)),
        child: Text('${tool.goldCost}G', style: const TextStyle(fontSize: 10)),
      );
    } else {
      return OutlinedButton(
        onPressed: isEquipped ? () => pdm.unequipTool(tool.id) : () => pdm.equipTool(tool.id),
        style: OutlinedButton.styleFrom(foregroundColor: isEquipped ? Colors.redAccent : Colors.cyanAccent),
        child: Text(isEquipped ? '해제' : '장착', style: const TextStyle(fontSize: 10)),
      );
    }
  }
}
