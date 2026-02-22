import 'package:flutter/material.dart';
import '../../../../core/widgets/summon_box.dart';

class RuneSummonSection extends StatelessWidget {
  const RuneSummonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SummonBox(
      title: "룬 소환",
      color: Colors.orangeAccent,
    );
  }
}