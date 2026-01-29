import 'package:flutter/material.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/player/player_data_manager.dart';
import 'package:provider/provider.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Consumer to react to changes in PlayerDataManager
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      appBar: AppBar(
        title: const Text('캐릭터'),
        backgroundColor: const Color(0xFF1a1a2e),
      ),
      body: Consumer<PlayerDataManager>(
        builder: (context, playerDataManager, child) {
          return ListView.builder(
            itemCount: masterCharacterList.length,
            itemBuilder: (context, index) {
              final character = masterCharacterList[index];
              // Find the corresponding player character data
              final playerCharacter = playerDataManager.playerData.ownedCharacters
                  .firstWhere((pc) => pc.characterId == character.id);
              return _buildCharacterTile(context, character, playerCharacter);
            },
          );
        },
      ),
    );
  }

  Widget _buildCharacterTile(
    BuildContext context,
    Character character,
    PlayerCharacter playerCharacter,
  ) {
    final bool canUnlock = playerCharacter.cardCount >= cardsNeededToUnlock;

    String tierText;
    Color tierColor;
    switch (character.tier) {
      case CharacterTier.celestial:
        tierText = '천상계';
        tierColor = Colors.yellow.shade700;
        break;
      case CharacterTier.hero:
        tierText = '영웅';
        tierColor = Colors.purple.shade300;
        break;
      case CharacterTier.mortal:
      default:
        tierText = '인간계';
        tierColor = Colors.blue.shade300;
        break;
    }

    return Card(
      color: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Character Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: tierColor.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: tierColor, width: 2),
              ),
              child: Icon(character.icon, color: Colors.white, size: 35),
            ),
            const SizedBox(width: 15),
            // Character Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tierText,
                    style: TextStyle(color: tierColor, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  if (playerCharacter.isUnlocked)
                    const Text('보유 중', style: TextStyle(color: Colors.greenAccent))
                  else
                    Text(
                      '카드: ${playerCharacter.cardCount} / $cardsNeededToUnlock',
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),
            // Action Button
            if (playerCharacter.isUnlocked)
              ElevatedButton(
                onPressed: () {}, // TODO: Implement character selection
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('선택됨'),
              )
            else
              ElevatedButton(
                onPressed: canUnlock 
                    ? () {
                        // Call the unlock method from the provider
                        Provider.of<PlayerDataManager>(context, listen: false)
                            .unlockCharacter(character.id);
                      }
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
                child: const Text('활성화'),
              )
          ],
        ),
      ),
    );
  }
}
