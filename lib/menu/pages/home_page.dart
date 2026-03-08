// lib/menu/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:game_defence/menu/pages/temple/presentation/widgets/temple_detail_popup.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onStartGame;
  final VoidCallback onToggleLocale;
  final Function(int) onNavigateToTab;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onStartGame,
    required this.onToggleLocale,
    required this.onNavigateToTab,
    required this.locale,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final pdm = Provider.of<PlayerDataManager>(context, listen: false);
    _pageController = PageController(
      viewportFraction: 0.85,
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
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Stack(
        children: [
          // 0. 배경 이미지 (선택된 신전에 따라 동적 변경)
          Positioned.fill(
            child: Image.asset(
              pdm.activeTemple.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  Image.asset('assets/images/fallback.png', fit: BoxFit.cover),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 언어 및 국가 FLAG
                _buildTopBar(),
                
                const SizedBox(height: 20),
                
                // 1. 신전 캐러설 (상단 배치)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pdm.temples.length,
                    onPageChanged: (index) {
                      pdm.setActiveTemple(pdm.temples[index].id);
                    },
                    itemBuilder: (context, index) {
                      final temple = pdm.temples[index];
                      final isActive = pdm.activeTempleId == temple.id;
                      return _buildTempleCard(context, temple, isActive, pdm);
                    },
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 2. 출전 영웅 섹션
                _buildPartySection(pdm),
                
                const Spacer(),
                
                // 3. 시작 버튼
                _buildStartButton(),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: widget.onToggleLocale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Colors.cyanAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.locale.languageCode == 'ko' ? 'ENG' : 'KOR',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              widget.locale.languageCode == 'ko' ? '🇰🇷' : '🇺🇸',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(BuildContext context, Temple temple, bool isActive, PlayerDataManager pdm) {
    return GestureDetector(
      onTap: () => _showTempleDetail(context, temple),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.all(isActive ? 5 : 15),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isActive ? Colors.amberAccent : Colors.white12, width: isActive ? 3 : 1),
          boxShadow: isActive ? [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)] : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                temple.imagePath,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(isActive ? 0.3 : 0.6),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(temple.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 8)])),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMiniBadge('신전', 'Lv.${temple.level}', Colors.cyanAccent),
                      const SizedBox(width: 8),
                      _buildMiniBadge('전쟁', 'Lv.${temple.warLevel}', Colors.amberAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.5))),
      child: Text('$label $value', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPartySection(PlayerDataManager pdm) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('출전 대기 중인 영웅', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(pdm.characterSlots, (index) {
            final charId = index < pdm.equippedCharacterIds.length ? pdm.equippedCharacterIds[index] : null;
            final char = charId != null ? pdm.masterCharacterList.firstWhere((c) => c.id == charId) : null;
            
            return GestureDetector(
              onTap: () => widget.onNavigateToTab(1), // 캐릭터 탭(index 1)으로 이동
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: char != null ? Colors.cyanAccent.withOpacity(0.5) : Colors.white10, width: 2),
                      boxShadow: char != null ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 8)] : null,
                    ),
                    child: char != null 
                      ? ClipOval(child: Image.asset('assets/images/${char.iconAssetPath}', fit: BoxFit.cover))
                      : const Icon(Icons.add, color: Colors.white24, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    char != null ? pdm.masterCharacterList.firstWhere((c) => c.id == charId).name : '비어있음',
                    style: TextStyle(color: char != null ? Colors.white : Colors.white24, fontSize: 11),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: widget.onStartGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          shadowColor: Colors.orangeAccent,
        ),
        child: Text(
          widget.locale.languageCode == 'ko' ? '운명의 전쟁 시작' : 'START THE WAR',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
      pageBuilder: (context, animation, secondaryAnimation) => TempleDetailPopup(temple: temple),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }
}
