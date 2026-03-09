import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/game/events/game_events.dart';
import 'package:game_defence/game/events/event_bus.dart';
import 'package:game_defence/config/game_config.dart';

class PlayerDataManager extends ChangeNotifier {
  late final List<Temple> temples;
  late final List<Offering> allOfferings;
  late final List<GameItem> mysticTools;
  late final List<CharacterDefinition> masterCharacterList;
  final Map<String, PlayerCharacter> ownedCharacters = {};
  final Map<String, int> characterCards = {}; // 캐릭터별 보유 카드 수
  
  String activeTempleId = 'athena';
  String activeCharacterId = 'michael';
  int gold = 1000000; // 테스트를 위해 골드 증액
  int gems = 5000;

  bool soundEnabled = true;
  bool vibrationEnabled = true;

  int characterSlots = 3;
  List<String> equippedCharacterIds = ['michael', 'lucifer'];

  int toolSlots = 3;
  List<String> equippedToolIds = ['tsunami', 'meteor_shower', 'ice_age'];
  List<String> ownedToolIds = ['tsunami', 'meteor_shower', 'ice_age', 'thunder_storm', 'black_hole'];

  int runeSlots = 4;
  List<String?> equippedRuneIds = [null, null, null, null];

  int currentTempleIndex = 0;

  PlayerDataManager({required EventBus eventBus}) {
    _initTemples();
    _initOfferings();
    _initMysticTools();
    _initCharacters();
  }

  void _initCharacters() {
    masterCharacterList = GameStats.instance.characterDefinitions.values.toList();
    masterCharacterList.sort((a, b) => a.startingRank.index.compareTo(b.startingRank.index));

    for (var char in masterCharacterList) {
      int startLevel = 1;
      if (char.startingRank == CharacterRank.gold) startLevel = 13;
      else if (char.startingRank == CharacterRank.platinum) startLevel = 25;
      else if (char.startingRank == CharacterRank.diamond) startLevel = 37;

      ownedCharacters[char.id] = PlayerCharacter(
        characterId: char.id, 
        isUnlocked: true,
        rank: char.startingRank,
        level: startLevel,
      );
      characterCards[char.id] = 100;
    }
  }

  void _initTemples() {
    temples = [
      Temple(
        id: 'athena', 
        name: '불가사의 고대신전', 
        description: '고대 거인들이 세운 것으로 알려진 정체불명의 신전입니다. 고대 캐릭터들의 숨겨진 잠재력을 깨웁니다.', 
        type: TempleType.hero, 
        isUnlocked: true
      ),
      Temple(
        id: 'babel_darkness', 
        name: '흑암의 바벨', 
        description: '끝없는 어둠 속에 숨겨진 거대한 금단의 탑입니다. 악마 캐릭터들에게 파괴적인 흑마력을 부여합니다.', 
        type: TempleType.darkness, 
        isUnlocked: true
      ),
      Temple(
        id: 'light_sanctuary', 
        name: '빛의 중앙청', 
        description: '세상의 정의와 빛을 관장하는 천상의 핵심 의사당입니다. 천사 캐릭터들의 신성을 극대화합니다.', 
        type: TempleType.light, 
        isUnlocked: true
      ),
    ];
  }

  void _initOfferings() {
    allOfferings = [];
    final types = [TempleType.hero, TempleType.light, TempleType.darkness];
    final icons = [Icons.star, Icons.shield, Icons.auto_awesome, Icons.bolt, Icons.gavel, Icons.favorite, Icons.ac_unit, Icons.wb_sunny, Icons.nightlight, Icons.psychology];
    
    for (var type in types) {
      for (int i = 0; i < 10; i++) {
        allOfferings.add(Offering(
          id: '${type.name}_$i',
          name: '${_getTypeName(type)} 룬 $i',
          description: '신비로운 힘이 깃든 룬입니다.',
          suitableTemple: type,
          icon: icons[i % icons.length],
          color: _getTypeColor(type),
        ));
      }
    }
  }

  void _initMysticTools() {
    mysticTools = [
      GameItem(id: 'tsunami', name: '심연의 쓰나미', description: '모든 적을 뒤로 밀어냅니다.', icon: Icons.tsunami, color: Colors.blueAccent, goldCost: 5000),
      GameItem(id: 'meteor_shower', name: '종말의 유성우', description: '하늘에서 불타는 돌이 떨어집니다.', icon: Icons.auto_awesome, color: Colors.deepOrangeAccent, goldCost: 8000),
      GameItem(id: 'ice_age', name: '절대영도 빙하기', description: '전장을 2초간 동결시킵니다.', icon: Icons.ac_unit, color: Colors.cyanAccent, goldCost: 6000),
      GameItem(id: 'thunder_storm', name: '천벌의 뇌우', description: '번개들이 적들을 연쇄 타격합니다.', icon: Icons.bolt, color: Colors.yellowAccent, goldCost: 7000),
      GameItem(id: 'black_hole', name: '차원의 블랙홀', description: '모든 적을 중심부로 끌어당깁니다.', icon: Icons.vignette, color: Colors.deepPurpleAccent, goldCost: 12000),
    ];
  }

  String _getTypeName(TempleType type) {
    if (type == TempleType.hero) return '영웅';
    if (type == TempleType.light) return '빛';
    return '어둠';
  }

  Color _getTypeColor(TempleType type) {
    if (type == TempleType.hero) return Colors.blueAccent;
    if (type == TempleType.light) return Colors.orangeAccent;
    return Colors.deepPurpleAccent;
  }

  Temple get activeTemple => temples.firstWhere((t) => t.id == activeTempleId);

  void toggleSound() { soundEnabled = !soundEnabled; notifyListeners(); }
  void toggleVibration() { vibrationEnabled = !vibrationEnabled; notifyListeners(); }

  void toggleCharacterSelection(String id) {
    if (equippedCharacterIds.contains(id)) {
      if (equippedCharacterIds.length > 1) equippedCharacterIds.remove(id);
    } else {
      if (equippedCharacterIds.length < characterSlots) equippedCharacterIds.add(id);
    }
    notifyListeners();
  }

  void equipRune(int slotIndex, String runeId) { equippedRuneIds[slotIndex] = runeId; notifyListeners(); }
  void updateTempleIndex(int index) { currentTempleIndex = index; notifyListeners(); }
  void setActiveTemple(String id) { 
    activeTempleId = id; 
    currentTempleIndex = temples.indexWhere((t) => t.id == id);
    notifyListeners(); 
  }
  void upgradeTemple(String id) {
    final index = temples.indexWhere((t) => t.id == id);
    if (index != -1) {
      final temple = temples[index];
      if (gold >= temple.upgradeGoldCost && gems >= temple.upgradeGemCost) {
        gold -= temple.upgradeGoldCost;
        gems -= temple.upgradeGemCost;
        temple.level++;
        notifyListeners();
      }
    }
  }

  void levelUpCharacter(String charId) {
    final pc = ownedCharacters[charId];
    if (pc == null) return;

    int cardCost = 12;
    int goldCost = pc.level * 5000;

    if ((characterCards[charId] ?? 0) >= cardCost && gold >= goldCost) {
      characterCards[charId] = characterCards[charId]! - cardCost;
      gold -= goldCost;
      pc.level++;

      if ((pc.level - 1) % 12 == 0 && (pc.level > 1)) {
        if (pc.rank == CharacterRank.silver) pc.rank = CharacterRank.gold;
        else if (pc.rank == CharacterRank.gold) pc.rank = CharacterRank.platinum;
        else if (pc.rank == CharacterRank.platinum) pc.rank = CharacterRank.diamond;
      }
      
      notifyListeners();
    }
  }

  void buyTool(String id) { /* 구현 생략 */ }
  void equipTool(String id) { /* 구현 생략 */ }
  void unequipTool(String id) { equippedToolIds.remove(id); notifyListeners(); }
  void unlockToolSlot() { if (toolSlots < 5) toolSlots++; notifyListeners(); }

  dynamic get playerData => this; 
  int get totalAttackPower => 10; 
  int get totalHpBonus => 0;
  void updateEventBus(dynamic bus) {}
}
