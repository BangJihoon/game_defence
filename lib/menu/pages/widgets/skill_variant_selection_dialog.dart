import 'package:flutter/material.dart';
import 'package:game_defence/data/skill_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class SkillVariantSelectionDialog extends StatelessWidget {
  final String skillId;
  final List<SkillVariantDefinition> variants;

  const SkillVariantSelectionDialog({
    super.key,
    required this.skillId,
    required this.variants,
  });

  @override
  Widget build(BuildContext context) {
    final playerDataManager = Provider.of<PlayerDataManager>(context, listen: false);

    return AlertDialog(
      title: const Text('스킬 변형 선택'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: variants.length,
          itemBuilder: (context, index) {
            final variant = variants[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.grey.shade800,
              child: ListTile(
                title: Text(
                  variant.titleLocaleKey, // Assuming this is the display name for now
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  variant.descriptionLocaleKey, // Assuming this is the display description
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                onTap: () {
                  playerDataManager.chooseSkillVariant(skillId, variant.variantId);
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Allow closing without selection, though typically a selection is mandatory
          },
          child: const Text('취소'),
        ),
      ],
    );
  }
}
