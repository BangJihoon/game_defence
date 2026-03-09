// lib/menu/pages/inventory_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:game_defence/menu/pages/temple/presentation/widgets/temple_detail_popup.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final pdm = Provider.of<PlayerDataManager>(context, listen: false);
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: pdm.currentTempleIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          title: const Text('신전과 룬', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            _buildCurrencyInfo(Icons.monetization_on, pdm.gold.toString(), Colors.yellow),
            _buildCurrencyInfo(Icons.diamond, pdm.gems.toString(), Colors.cyanAccent),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            // 1. 장착된 캐릭터 (기둥 컨셉과 연동)
            _buildEquippedCharacters(pdm),

            // 2. 신전 캐러설
            SizedBox(
              height: 250, // 높이 약간 증가
              child: PageView.builder(
                controller: _pageController,
                itemCount: pdm.temples.length,
                onPageChanged: (index) => pdm.updateTempleIndex(index),
                itemBuilder: (context, index) {
                  final temple = pdm.temples[index];
                  final isActive = pdm.activeTempleId == temple.id;
                  return _buildTempleCard(temple, isActive, pdm);
                },
              ),
            ),

            // 3. 룬 장착 슬롯 (신전 상단 배치 컨셉)
            _buildRuneSlots(pdm),

            // 4. 탭바 (제물 종류)
            const TabBar(
              tabs: [Tab(text: '전체'), Tab(text: '영웅'), Tab(text: '빛'), Tab(text: '어둠')],
              labelColor: Colors.amberAccent,
              indicatorColor: Colors.amberAccent,
              dividerColor: Colors.transparent,
            ),

            // 5. 룬 목록
            Expanded(
              child: TabBarView(
                children: [
                  _buildOfferingsGrid(pdm, null),
                  _buildOfferingsGrid(pdm, TempleType.hero),
                  _buildOfferingsGrid(pdm, TempleType.light),
                  _buildOfferingsGrid(pdm, TempleType.darkness),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquippedCharacters(PlayerDataManager pdm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pdm.equippedCharacterIds.map((id) {
          final char = pdm.masterCharacterList.firstWhere((c) => c.id == id);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
            ),
            child: Icon(char.icon, color: Colors.white, size: 20),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRuneSlots(PlayerDataManager pdm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pdm.runeSlots, (index) {
          final runeId = pdm.equippedRuneIds[index];
          final rune = runeId != null ? pdm.allOfferings.firstWhere((o) => o.id == runeId) : null;
          return Container(
            width: 45, height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: rune != null ? rune.color : Colors.white12),
            ),
            child: rune != null ? Icon(rune.icon, color: rune.color, size: 24) : const Icon(Icons.add, color: Colors.white10, size: 18),
          );
        }),
      ),
    );
  }

  Widget _buildTempleCard(Temple temple, bool isActive, PlayerDataManager pdm) {
    return GestureDetector(
      onTap: () => _showTempleDetail(context, temple),
      child: Container(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? Colors.amberAccent : Colors.white24, width: 2),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                temple.imagePath,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.5),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(temple.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                  const SizedBox(height: 4),
                  Text('Lv.${temple.level}', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.amber.withOpacity(0.8) : Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(isActive ? '현재 제단' : '자세히 보기', style: const TextStyle(color: Colors.white, fontSize: 11)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTempleDetail(BuildContext context, Temple temple) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Temple Detail',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return TempleDetailPopup(temple: temple);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  Widget _buildOfferingsGrid(PlayerDataManager pdm, TempleType? filterType) {
    final filtered = filterType == null ? pdm.allOfferings : pdm.allOfferings.where((o) => o.suitableTemple == filterType).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final offering = filtered[index];
        return GestureDetector(
          onTap: () {
            // 빈 슬롯에 자동 장착 데모
            int emptyIdx = pdm.equippedRuneIds.indexOf(null);
            if (emptyIdx != -1) pdm.equipRune(emptyIdx, offering.id);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white12)),
            child: Icon(offering.icon, color: offering.suitableTemple == pdm.activeTemple.type ? offering.color : Colors.grey, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyInfo(IconData icon, String value, Color color) {
    return Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(width: 12)]);
  }
}
