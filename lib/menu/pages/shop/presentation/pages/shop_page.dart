import 'package:flutter/material.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/menu/pages/widgets/top_currency_bar.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ShopSectionTitle("오늘의 제안"),
              _TodayOffersScroll(),
              SizedBox(height: 20),
              _ShopSectionTitle("캐릭터 상점"),
              _CharacterShopTabs(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopSectionTitle extends StatelessWidget {
  final String title;
  const _ShopSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TodayOffersScroll extends StatelessWidget {
  const _TodayOffersScroll();

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    final shopData = GameStats.instance.shopData;
    final dailyDeals = shopData['daily_deals'] as List;
    final deal = dailyDeals[pdm.todayDealIndex];

    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // 1. 오늘의 할인
          _OfferCard(
            title: "오늘의 할인",
            subtitle: "${deal['item']} x${deal['amount']}",
            price: "₩${deal['price_krw']}",
            color: Colors.orangeAccent,
            onTap: () {
              // 구매 로직 구현
            },
          ),
          // 2. 구독 상품
          _OfferCard(
            title: "VIP 멤버십",
            subtitle: pdm.isVipYearly ? "연간 구독 중" : "구독하고 매일 보석 획득",
            price: "상세보기",
            color: Colors.blueAccent,
            onTap: () => _showSubscriptionDialog(context),
          ),
          // 3. VIP Zone
          _OfferCard(
            title: "VIP ZONE",
            subtitle: "매일 무료 조각 획득",
            price: "입장",
            color: Colors.purpleAccent,
            onTap: () => _showVipZone(context),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("VIP 구독", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubOption(title: "월간 VIP", price: "₩4,900", gems: "매일 2,000젬", onBuy: () => Provider.of<PlayerDataManager>(context, listen: false).subscribeVip(false)),
            const SizedBox(height: 10),
            _SubOption(title: "연간 VIP", price: "₩49,000", gems: "매일 3,000젬", onBuy: () => Provider.of<PlayerDataManager>(context, listen: false).subscribeVip(true)),
          ],
        ),
      ),
    );
  }

  void _showVipZone(BuildContext context) {
    // VIP 전용 팝업
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const VipZonePopup(),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final Color color;
  final VoidCallback onTap;

  const _OfferCard({required this.title, required this.subtitle, required this.price, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.3), Colors.black45]),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              child: Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubOption extends StatelessWidget {
  final String title;
  final String price;
  final String gems;
  final VoidCallback onBuy;

  const _SubOption({required this.title, required this.price, required this.gems, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(gems, style: const TextStyle(color: Colors.cyanAccent, fontSize: 10)),
          ]),
          const Spacer(),
          ElevatedButton(onPressed: onBuy, child: Text(price)),
        ],
      ),
    );
  }
}

class VipZonePopup extends StatelessWidget {
  const VipZonePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("VIP ZONE", style: TextStyle(color: Colors.purpleAccent, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (pdm.isVipMonthly || pdm.isVipYearly) ? () => pdm.claimVipDailyReward() : null,
            child: const Text("일일 보상 수령"),
          ),
          const SizedBox(height: 20),
          const Text("VIP 전용 젬 팩", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          _VipGemPack(gems: 10000, price: "₩30,000"),
          _VipGemPack(gems: 50000, price: "₩99,000"),
        ],
      ),
    );
  }
}

class _VipGemPack extends StatelessWidget {
  final int gems;
  final String price;
  const _VipGemPack({required this.gems, required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.diamond, color: Colors.cyanAccent),
      title: Text("보석 $gems개", style: const TextStyle(color: Colors.white)),
      trailing: ElevatedButton(onPressed: () {}, child: Text(price)),
    );
  }
}

class _CharacterShopTabs extends StatelessWidget {
  const _CharacterShopTabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [Tab(text: '실버'), Tab(text: '골드'), Tab(text: '플래티넘')],
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildRankGrid(context, CharacterRank.silver),
                _buildRankGrid(context, CharacterRank.gold),
                _buildRankGrid(context, CharacterRank.platinum),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankGrid(BuildContext context, CharacterRank rank) {
    final pdm = Provider.of<PlayerDataManager>(context);
    final chars = pdm.masterCharacterList.where((c) => c.startingRank == rank).toList();
    
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: chars.length + 1, // 무료 보상 칸 추가
      itemBuilder: (context, index) {
        if (index == 0 && rank == CharacterRank.silver) {
          return _FreeAdCard();
        }
        final charIndex = rank == CharacterRank.silver ? index - 1 : index - 1;
        if (charIndex < 0 || charIndex >= chars.length) return const SizedBox();
        
        final char = chars[charIndex];
        return _CharacterCard(char: char);
      },
    );
  }
}

class _FreeAdCard extends StatelessWidget {
  const _FreeAdCard();

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    return GestureDetector(
      onTap: () => pdm.claimFreeCardByAd(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.video_library, color: Colors.greenAccent, size: 30),
            SizedBox(height: 8),
            Text("무료 카드", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("광고 시청", style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final CharacterDefinition char;
  const _CharacterCard({required this.char});

  @override
  Widget build(BuildContext context) {
    final pdm = Provider.of<PlayerDataManager>(context);
    int price = char.startingRank == CharacterRank.silver ? 100 : (char.startingRank == CharacterRank.gold ? 500 : 2500);

    return GestureDetector(
      onTap: () => pdm.purchaseCharacterCard(char.id, char.startingRank),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset('assets/images/${char.iconAssetPath}'))),
            Text(char.name, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.diamond, size: 12, color: Colors.cyanAccent),
                Text(price.toString(), style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
