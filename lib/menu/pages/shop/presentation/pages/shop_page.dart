import 'package:flutter/material.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/special_banner_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/rune_summon_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/gem_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/skillstone_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/stamp_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/character_summon_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/shop_header.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/gold_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/sections/daily_shop_section.dart';
import 'package:game_defence/menu/pages/shop/presentation/widgets/shop_bottom_nav.dart';
import 'package:game_defence/menu/pages/shop/presentation/widgets/section_title.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3B53),
      bottomNavigationBar: const ShopBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ShopHeader(),
              SizedBox(height: 12),
              SpecialBannerSection(),

              SectionTitle("일일 상점"),
              DailyShopSection(),

              SectionTitle("룬 소환"),
              RuneSummonSection(),

              SectionTitle("캐릭터 소환"),
              CharacterSummonSection(),

              SectionTitle("보석"),
              GemSection(),

              SectionTitle("스킬석"),
              SkillStoneSection(),

              SectionTitle("황금 도장"),
              StampSection(),

              SectionTitle("골드"),
              GoldSection(),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
