import 'package:flutter/material.dart';

class CharacterSummonSection extends StatelessWidget {
  const CharacterSummonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SummonBox(
      title: "캐릭터 소환",
      color: Colors.purple.shade300,
    );
  }
}

class _SummonBox extends StatelessWidget {
  final String title;
  final Color color;

  const _SummonBox({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ElevatedButton(onPressed: null, child: Text("1회")),
              ElevatedButton(onPressed: null, child: Text("10회")),
            ],
          )
        ],
      ),
    );
  }
}