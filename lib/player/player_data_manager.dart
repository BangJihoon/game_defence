// lib/player/player_data_manager.dart
import 'package:flutter/material.dart';
import 'package:game_defence/data/inventory_data.dart';
import 'package:game_defence/data/character_data.dart';
import 'package:game_defence/game/events/event_bus.dart';

class PlayerDataManager extends ChangeNotifier {
  late final List<Temple> temples;
  late final List<Offering> allOfferings;
  late final List<GameItem> mysticTools;
  late final List<Character> masterCharacterList;
  
  String activeTempleId = 'athena';
  String activeCharacterId = 'hermes';
  int gold = 500000;
  int gems = 5000;

  bool soundEnabled = true;
  bool vibrationEnabled = true;

  int characterSlots = 3;
  List<String> equippedCharacterIds = ['hermes', 'athena', 'zeus'];

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
    masterCharacterList = [
      const Character(id: 'hermes', name: '헤르메스', description: '전령', tier: CharacterTier.hero, icon: Icons.directions_run, skillId: 'arcane_missile', baseAttack: 25, baseHp: 500, baseDefense: 5),
      const Character(id: 'athena', name: '아테나', description: '지혜', tier: CharacterTier.hero, icon: Icons.security, skillId: 'frost_nova', baseAttack: 30, baseHp: 600, baseDefense: 10),
      const Character(id: 'zeus', name: '제우스', description: '올림포스의 왕', tier: CharacterTier.celestial, icon: Icons.bolt, skillId: 'chain_lightning', baseAttack: 40, baseHp: 700, baseDefense: 15),
      const Character(id: 'ares', name: '아레스', description: '전쟁', tier: CharacterTier.hero, icon: Icons.colorize, skillId: 'fireball', baseAttack: 50, baseHp: 700, baseDefense: 15),
      const Character(id: 'poseidon', name: '포세이돈', description: '바다', tier: CharacterTier.hero, icon: Icons.waves, skillId: 'frost_nova', baseAttack: 38, baseHp: 750, baseDefense: 12),
      const Character(id: 'lucifer', name: '루시퍼', description: '타락', tier: CharacterTier.mortal, icon: Icons.brightness_3, skillId: 'poison_cloud', baseAttack: 65, baseHp: 1200, baseDefense: 20),
      const Character(id: 'michael', name: '미카엘', description: '대천사', tier: CharacterTier.celestial, icon: Icons.auto_awesome, skillId: 'chain_lightning', baseAttack: 55, baseHp: 1000, baseDefense: 30),
      const Character(id: 'satan', name: '사탄', description: '분노', tier: CharacterTier.mortal, icon: Icons.local_fire_department, skillId: 'fireball', baseAttack: 75, baseHp: 1100, baseDefense: 10),
      const Character(id: 'raphael', name: '라파엘', description: '치유', tier: CharacterTier.celestial, icon: Icons.healing, skillId: 'healing_aura', baseAttack: 20, baseHp: 1200, baseDefense: 40),
      const Character(id: 'hades', name: '하데스', description: '지하', tier: CharacterTier.hero, icon: Icons.visibility_off, skillId: 'poison_cloud', baseAttack: 42, baseHp: 650, baseDefense: 10),
    ];
  }

  void _initTemples() {
    temples = [
      Temple(id: 'athena', name: '아테네 신전', description: '영웅과 신화 캐릭터 공격력 보너스', type: TempleType.hero, isUnlocked: true),
      Temple(id: 'light_sanctuary', name: '빛의 성전', description: '천사 캐릭터 공격력 보너스', type: TempleType.light, isUnlocked: true),
      Temple(id: 'babel_darkness', name: '어둠의 바벨', description: '악마 캐릭터 공격력 보너스', type: TempleType.darkness, isUnlocked: true),
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
  void upgradeTemple(String id) { /* 구현 생략 */ }
  void buyTool(String id) { /* 구현 생략 */ }
  void equipTool(String id) { /* 구현 생략 */ }
  void unequipTool(String id) { equippedToolIds.remove(id); notifyListeners(); }
  void unlockToolSlot() { if (toolSlots < 5) toolSlots++; notifyListeners(); }

  dynamic get playerData => this; 
  int get totalAttackPower => 10; 
  int get totalHpBonus => 0;
  void updateEventBus(dynamic bus) {}
}
