// lib/menu/pages/widgets/inventory_list_view.dart
import 'package:flutter/material.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Inventory WIP',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
