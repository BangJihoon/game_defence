// lib/game/skills/skill_system.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../overflow_game.dart';
import 'package:game_defence/config/game_config.dart';
import '../../data/skill_data.dart';
import '../../data/character_data.dart';
import '../combat/skill_engine.dart';

class SkillState {
  final SkillData data;
  final CharacterDefinition owner;
  double cooldownTimer = 0;
  
  // 밸런스 패치용 배수
  static const double rangeMultiplier = 1.5;
  static const double cooldownMultiplier = 0.5;

  SkillState({required this.data, required this.owner}) {
    // 초기 딜레이도 쿨타임 배수 적용
    cooldownTimer = (1.0 + (owner.id.length % 3).toDouble()) * cooldownMultiplier;
  }

  bool get isReady => cooldownTimer <= 0;

  void update(double dt) {
    if (cooldownTimer > 0) cooldownTimer -= dt;
  }

  void resetCooldown() {
    cooldownTimer = data.cooldown * cooldownMultiplier;
  }
}

class SkillSystem extends Component with HasGameRef<OverflowDefenseGame> {
  final List<SkillState> activeSkills = [];
  late final SkillEngine skillEngine;
  
  final Locale locale;
  final GameStats gameStats; 
  final Map<String, SkillData> skillDefinitions; 
  final int baseAttackPower;

  SkillSystem({
    required this.locale,
    required this.gameStats,
    required this.skillDefinitions,
    required this.baseAttackPower,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    skillEngine = SkillEngine(game);
    _initializeActiveSkills();
  }

  void _initializeActiveSkills() {
    activeSkills.clear();
    final equippedIds = game.playerDataManager.equippedCharacterIds;
    print("DEBUG: Equipped characters: $equippedIds");
    print("DEBUG: Master character list size: ${game.playerDataManager.masterCharacterList.length}");
    print("DEBUG: Skill definitions IDs: ${skillDefinitions.keys.toList()}");

    for (final charId in equippedIds) {
      try {
        final char = game.playerDataManager.masterCharacterList.firstWhere((c) => c.id == charId);
        print("DEBUG: Checking char ${char.id}, baseSkillId: ${char.baseSkillId}");
        
        SkillData? skillData;
        if (skillDefinitions.containsKey(char.baseSkillId)) {
          skillData = skillDefinitions[char.baseSkillId];
        } else {
          final upperId = charId.toUpperCase();
          try {
            skillData = skillDefinitions.values.firstWhere(
              (s) => s.id.toUpperCase() == char.baseSkillId.toUpperCase() || 
                     s.id.startsWith("SK_${upperId}_") || 
                     s.owner.toLowerCase() == charId.toLowerCase()
            );
          } catch (_) {}
        }

        if (skillData != null) {
          print("DEBUG: Assigned skill ${skillData.id} to ${char.id}");
          activeSkills.add(SkillState(data: skillData, owner: char));
        } else {
          print("DEBUG: FAILED to find skill for character: $charId (baseSkillId: ${char.baseSkillId})");
        }
      } catch (e) {
        print("DEBUG: Error initializing skill for $charId: $e");
      }
    }
    print("DEBUG: Total active skills initialized: ${activeSkills.length}");
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) return;

    for (final skill in activeSkills) {
      skill.update(dt);
      if (skill.isReady) {
        _triggerSkill(skill);
      }
    }
  }

  void _triggerSkill(SkillState skill) {
    try {
      final equippedIds = game.playerDataManager.equippedCharacterIds;
      final charIndex = equippedIds.indexOf(skill.owner.id);
      final spawnPos = game.getCharacterPosition(charIndex);

      print("DEBUG: TRIGGERING skill: ${skill.data.id} from ${skill.owner.id} at $spawnPos");
      
      // 밸런스 패치가 적용된 스킬 데이터 임시 생성 (사거리 보정)
      final balancedSkill = SkillData(
        id: skill.data.id,
        name: skill.data.name,
        owner: skill.data.owner,
        element: skill.data.element,
        damageType: skill.data.damageType,
        targetType: skill.data.targetType,
        range: skill.data.range * SkillState.rangeMultiplier,
        cooldown: skill.data.cooldown * SkillState.cooldownMultiplier,
        multiplier: skill.data.multiplier,
        hitCount: skill.data.hitCount,
        effects: skill.data.effects,
        description: skill.data.description,
        nameLocaleKey: skill.data.nameLocaleKey,
        descriptionLocaleKey: skill.data.descriptionLocaleKey,
      );

      final fired = skillEngine.executeSkill(
        caster: skill.owner,
        skill: balancedSkill,
        spawnPosition: spawnPos,
      );
      
      if (fired) {
        skill.resetCooldown();
        
        // 캐릭터 공격 연출 (attack.png 변경 및 반짝임)
        try {
          final charComp = game.altarCharacters.firstWhere((c) => c.character.id == skill.owner.id);
          charComp.playAttackEffect();
        } catch (_) {
          // 캐릭터 컴포넌트를 찾지 못한 경우 무시
        }
      } else {
        // No targets in range, wait a bit before checking again to save CPU
        skill.cooldownTimer = 0.5;
      }
    } catch (e, stack) {
      print("DEBUG: ERROR in _triggerSkill: $e\n$stack");
    }
  }

  void refreshSkills() {
    _initializeActiveSkills();
  }

  void upgradeSkill(String skillId) {}
  void applyVariant(String skillId, String variantId) {}
}
