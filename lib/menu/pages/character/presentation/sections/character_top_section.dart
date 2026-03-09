import 'package:flutter/material.dart';

class CharacterTopSection extends StatelessWidget {
  const CharacterTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.pets, size: 40),
              ),
              SizedBox(width: 16),
              Text(
                "울프가르 Lv.2\n공격력 16.5% 증가",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: null,
                  child: Text("강화하기"),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: null,
                  child: Text("장착 효과"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}