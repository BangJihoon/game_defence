import 'package:flutter/material.dart';
import '../../../shop/presentation/widgets/character_card.dart';

class CharacterTabSection extends StatelessWidget {
  const CharacterTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: const [
          TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: "전체"),
              Tab(text: "영웅"),
              Tab(text: "천사"),
              Tab(text: "악마"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _Grid(type: "전체"),
                _Grid(type: "영웅"),
                _Grid(type: "천사"),
                _Grid(type: "악마"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final String type;
  const _Grid({required this.type});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 12,
      itemBuilder: (_, index) =>
          CharacterCard(name: "$type ${index + 1}"),
    );
  }
}