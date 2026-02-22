import 'package:flutter/material.dart';
import '../../../../core/widgets/shop_item_card.dart';

class GemSection extends StatelessWidget {
  const GemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(
            3, (index) => ShopItemCard(title: "보석 상품 ${index + 1}")),
      ),
    );
  }
}