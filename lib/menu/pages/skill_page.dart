import 'package:flutter/material.dart';
import 'package:game_defence/config/game_config.dart';
import 'package:game_defence/data/player_skill_data.dart';
import 'package:game_defence/data/skill_data.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the master list of all skills
    final allSkills = GameStats.instance.skillDefinitions.values.toList();
    final l10n = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: const Text('스킬'),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Consumer<PlayerDataManager>(
        builder: (context, playerDataManager, child) {
          final playerData = playerDataManager.playerData;
          return Column(
            children: [
              // Player Level Display
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '플레이어 레벨: ${playerData.playerLevel}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: allSkills.length,
                  itemBuilder: (context, index) {
                    final skillDef = allSkills[index];
                    // Find the corresponding player skill data
                    final playerSkill = playerDataManager.playerData.ownedSkills
                        .firstWhere((ps) => ps.skillId == skillDef.skillId,
                            orElse: () => PlayerSkill(skillId: skillDef.skillId));
                    return _buildSkillTile(context, skillDef, playerSkill, l10n, playerDataManager);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkillTile(
    BuildContext context,
    SkillDefinition skillDef,
    PlayerSkill playerSkill,
    AppLocalizations l10n,
    PlayerDataManager playerDataManager,
  ) {
    final bool isUnlocked = playerSkill.isUnlocked;
    final skillName = l10n.translate(skillDef.titleLocaleKey);
    
    // Level Up Logic
    final upgradeCost = playerDataManager.getSkillUpgradeCost(skillDef.skillId);
    final canUpgrade = (playerDataManager.playerData.currencies['gold'] ?? 0) >= upgradeCost && isUnlocked && playerSkill.level < skillDef.maxLevel;

    // Rank Up Logic
    final rankUpCost = playerDataManager.getSkillRankUpCost(skillDef.skillId);
    final canRankUp = (playerDataManager.playerData.currencies['gems'] ?? 0) >= rankUpCost && isUnlocked && rankUpCost > 0;
    
    return Card(
      color: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Skill Icon (placeholder)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(isUnlocked ? 0.3 : 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: isUnlocked ? Colors.blue : Colors.grey, width: 2),
              ),
              child: Icon(Icons.flash_on, color: isUnlocked ? Colors.white : Colors.grey, size: 35),
            ),
            const SizedBox(width: 15),
            // Skill Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillName,
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked ? '레벨: ${playerSkill.level} (랭크: ${playerSkill.rank})' : '잠김',
                    style: TextStyle(color: isUnlocked ? Colors.greenAccent : Colors.redAccent),
                  ),
                ],
              ),
            ),
            // Action Buttons (Upgrade & Rank Up)
            Column(
              children: [
                // Level Up Button
                ElevatedButton(
                  onPressed: canUpgrade
                      ? () {
                          playerDataManager.upgradeSkill(skillDef.skillId);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canUpgrade ? Colors.green.shade700 : Colors.grey.shade800,
                    minimumSize: const Size(80, 30), // Fixed size for consistency
                  ),
                  child: const Text('강화', style: TextStyle(fontSize: 12)),
                ),
                Text(
                  isUnlocked ? '$upgradeCost G' : '-',
                  style: TextStyle(
                    color: canUpgrade ? Colors.yellow.shade600 : Colors.red,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                // Rank Up Button
                ElevatedButton(
                  onPressed: canRankUp
                      ? () {
                          playerDataManager.rankUpSkill(skillDef.skillId);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canRankUp ? Colors.purple.shade700 : Colors.grey.shade800,
                    minimumSize: const Size(80, 30), // Fixed size for consistency
                  ),
                  child: const Text('랭크 업', style: TextStyle(fontSize: 12)),
                ),
                 Text(
                  isUnlocked && playerSkill.rank < 5 ? '$rankUpCost 💎' : '-', // Max rank 5 for now
                  style: TextStyle(
                    color: canRankUp ? Colors.blue.shade300 : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
