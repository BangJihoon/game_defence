import 'package:flutter/material.dart';
import 'package:game_defence/l10n/app_localizations.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: Text(l10n.translate('skills')),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Consumer<PlayerDataManager>(
        builder: (context, playerDataManager, child) {
          return const Center(
            child: Text(
              '스킬 페이지 준비 중입니다.\n(Skill Page Under Construction)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
