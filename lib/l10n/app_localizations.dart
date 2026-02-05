import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // 메인 메뉴
  String get gameTitle => _localizedValues[locale.languageCode]?['gameTitle'] ?? 'Defense Game';
  String get startGame => _localizedValues[locale.languageCode]?['startGame'] ?? 'Start Game';
  String get gameDescription => _localizedValues[locale.languageCode]?['gameDescription'] ?? 'Tap to defeat enemies!';

  // 게임 UI
  String score(int score) => (_localizedValues[locale.languageCode]?['score'] ?? 'Score: {score}').replaceAll('{score}', score.toString());
  String get gameOver => _localizedValues[locale.languageCode]?['gameOver'] ?? 'Game Over!';
  String get tapToRestart => _localizedValues[locale.languageCode]?['tapToRestart'] ?? 'Tap to restart';
  String get restartGame => _localizedValues[locale.languageCode]?['restartGame'] ?? 'Restart Game';
  String get returnToMenu => _localizedValues[locale.languageCode]?['returnToMenu'] ?? 'Return to Menu';

  // 스킬 이름
  String get lightningSkill => _localizedValues[locale.languageCode]?['lightningSkill'] ?? 'Lightning';
  String get freezeSkill => _localizedValues[locale.languageCode]?['freezeSkill'] ?? 'Freeze';
  String get healSkill => _localizedValues[locale.languageCode]?['healSkill'] ?? 'Heal';

  // 스킬 설명
  String get lightningSkillDesc => _localizedValues[locale.languageCode]?['lightningSkillDesc'] ?? 'Full screen damage';
  String get freezeSkillDesc => _localizedValues[locale.languageCode]?['freezeSkillDesc'] ?? 'Reduce enemy speed by 50%';
  String get healSkillDesc => _localizedValues[locale.languageCode]?['healSkillDesc'] ?? 'Restore 30 HP';
  String get wave => _localizedValues[locale.languageCode]?['wave'] ?? 'Wave';
  String get nextWaveIn => _localizedValues[locale.languageCode]?['nextWaveIn'] ?? 'Next Wave In';

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'gameTitle': 'Defense Game',
      'startGame': 'Start Game',
      'gameDescription': 'Tap to defeat enemies!',
      'score': 'Score: {score}',
      'gameOver': 'Game Over!',
      'tapToRestart': 'Tap to restart',
      'restartGame': 'Restart Game',
      'returnToMenu': 'Return to Menu',
      'lightningSkill': 'Lightning',
      'freezeSkill': 'Freeze',
      'healSkill': 'Heal',
      'lightningSkillDesc': 'Strikes 5 random enemies',
      'freezeSkillDesc': 'Reduce enemy speed by 50%',
      'healSkillDesc': 'Restore 30 HP',
      'wave': 'Wave',
      'nextWaveIn': 'Next Wave In',
      'skill.fireball.title': 'Fireball',
      'skill.chain_lightning.title': 'Chain Lightning',
      'skill.ice_wall.title': 'Ice Wall',
      'skill.arcane_missile.title': 'Arcane Missile',
      'skill.frost_nova.title': 'Frost Nova',
      'skill.poison_cloud.title': 'Poison Cloud',
      'skill.healing_aura.title': 'Healing Aura',
      'skill.shield_barrier.title': 'Shield Barrier',
      'skill.berserk_rage.title': 'Berserk Rage',

      // Skill Descriptions
      'skill.fireball.desc': 'Shoots a fiery projectile.',
      'skill.chain_lightning.desc': 'Lightning that jumps between enemies.',
      'skill.ice_wall.desc': 'Creates a wall of ice to block enemies.',
      'skill.arcane_missile.desc': 'Shoots a magic missile.',
      'skill.frost_nova.desc': 'Damages and slows enemies in an area.',
      'skill.poison_cloud.desc': 'Creates a cloud that damages enemies over time.',
      'skill.healing_aura.desc': 'Heals the player base for a certain amount.',
      'skill.shield_barrier.desc': 'Grants a temporary shield to the player base.',
      'skill.berserk_rage.desc': 'Temporarily increases damage and reduces cooldowns.',

      // Variant Titles
      'variant.fireball_meteor.title': 'Meteor',
      'variant.chain_lightning_static_field.title': 'Static Field',
      'variant.ice_wall_shatter.title': 'Shatter',
      'variant.arcane_missile_homing.title': 'Homing Missile',
      'variant.frost_nova_expanding.title': 'Expanding Nova',
      'variant.berserk_rage_unleashed.title': 'Unleashed Rage',

      // Variant Descriptions
      'variant.fireball_meteor.desc': 'Fireball becomes a powerful meteor.',
      'variant.chain_lightning_static_field.desc': 'Chain Lightning leaves a damaging field.',
      'variant.ice_wall_shatter.desc': 'Ice Wall shatters on expiration, damaging enemies.',
      'variant.arcane_missile_homing.desc': 'Arcane Missile now homes in on enemies.',
      'variant.frost_nova_expanding.desc': 'Frost Nova expands over time',
      'variant.berserk_rage_unleashed.desc': 'Massively increased damage and reduced cooldowns.',

      // Card Titles
      'card.stat_global_dmg_1.title': 'Attack Up',
      'card.stat_global_cd_1.title': 'Cooldown Down',
      'card.stat_wall_hp_1.title': 'Fortify Wall',
      'card.stat_coin_gain_1.title': 'Coin Magnet',
      'card.upg_fireball_dmg_1.title': 'Bigger Fireball',
      'card.upg_fireball_cd_1.title': 'Faster Fireball',
      'card.upg_chain_lightning_dmg_1.title': 'Charged Lightning',
      'card.upg_chain_lightning_chains_1.title': 'Supercharged Lightning',
      'card.upg_ice_wall_hp_1.title': 'Thicker Ice Wall',
      'card.upg_ice_wall_duration_1.title': 'Longer Ice Wall',
      'card.var_fireball_meteor.title': 'Meteor',
      'card.util_wall_repair_1.title': 'Quick Repair',
      'card.util_shield_1.title': 'Shield',
      'card.util_reroll_1.title': 'Reroll',
      'card.rule_sixth_slot.title': 'Sixth Sense',
      'card.cursed_glass_cannon_1.title': 'Glass Cannon',
      'card.cursed_overcharge_1.title': 'Overcharge',
      'card.stat_projectile_speed_1.title': 'Swift Projectiles',
      'card.stat_projectile_size_1.title': 'Bigger Projectiles',
      'card.stat_area_of_effect_1.title': 'Wider Area',
      'card.upg_frost_nova_cd_1.title': 'Faster Frost Nova',
      'card.upg_frost_nova_radius_1.title': 'Wider Frost Nova',
      'card.upg_arcane_missile_dmg_1.title': 'Sharper Missiles',
      'card.upg_arcane_missile_count_1.title': 'Missile Barrage',
      'card.var_chain_lightning_stun.title': 'Stunning Lightning',
      'card.var_ice_wall_spikes.title': 'Spiked Wall',
      'card.util_wall_repair_2.title': 'Major Repair',
      'card.util_shield_2.title': 'Major Shield',
      'card.util_reroll_2.title': 'Extra Rerolls',
      'card.cursed_berserker_1.title': 'Berserker',
      'card.cursed_no_cooldown.title': 'No Cooldown',
      'card.stat_global_dmg_2.title': 'Attack Up II',
      'card.stat_global_cd_2.title': 'Cooldown Down II',
      'card.stat_wall_hp_2.title': 'Fortify Wall II',
      'card.stat_coin_gain_2.title': 'Coin Magnet II',
      'card.upg_fireball_dmg_2.title': 'Bigger Fireball II',
      'card.upg_chain_lightning_chains_2.title': 'Supercharged Lightning II',
      'card.upg_ice_wall_hp_2.title': 'Thicker Ice Wall II',
      'card.rule_seventh_slot.title': 'Seventh Sense',

      // Card Descriptions
      'card.stat_global_dmg_1.desc': '+5% global damage',
      'card.stat_global_cd_1.desc': '-3% global cooldown',
      'card.stat_wall_hp_1.desc': '+10% wall max HP',
      'card.stat_coin_gain_1.desc': '+10% coin gain',
      'card.upg_fireball_dmg_1.desc': '+20% Fireball damage',
      'card.upg_fireball_cd_1.desc': '-10% Fireball cooldown',
      'card.upg_chain_lightning_dmg_1.desc': '+25% Chain Lightning damage',
      'card.upg_chain_lightning_chains_1.desc': '+1 Chain Lightning chains',
      'card.upg_ice_wall_hp_1.desc': '+30% Ice Wall HP',
      'card.upg_ice_wall_duration_1.desc': '+2s Ice Wall duration',
      'card.var_fireball_meteor.desc': 'Fireball becomes a Meteor',
      'card.util_wall_repair_1.desc': 'Heal wall for 20% of max HP',
      'card.util_shield_1.desc': 'Gain a shield for 25% of max HP',
      'card.util_reroll_1.desc': '+1 reroll',
      'card.rule_sixth_slot.desc': 'Unlock a 6th skill slot',
      'card.cursed_glass_cannon_1.desc': '+80% global damage, -40% wall max HP',
      'card.cursed_overcharge_1.desc': '-40% global cooldown, disable coin gain',
      'card.stat_projectile_speed_1.desc': '+15% projectile speed',
      'card.stat_projectile_size_1.desc': '+10% projectile size',
      'card.stat_area_of_effect_1.desc': '+15% area of effect',
      'card.upg_frost_nova_cd_1.desc': '-15% Frost Nova cooldown',
      'card.upg_frost_nova_radius_1.desc': '+20% Frost Nova radius',
      'card.upg_arcane_missile_dmg_1.desc': '+15% Arcane Missile damage',
      'card.upg_arcane_missile_count_1.desc': '+1 Arcane Missile count',
      'card.var_chain_lightning_stun.desc': 'Chain Lightning now stuns enemies',
      'card.var_ice_wall_spikes.desc': 'Ice Wall damages enemies that touch it',
      'card.util_wall_repair_2.desc': 'Major Repair',
      'card.util_shield_2.desc': 'Major Shield',
      'card.util_reroll_2.desc': 'Extra Rerolls',
      'card.cursed_berserker_1.desc': '+150% global damage, -75% wall max HP',
      'card.cursed_no_cooldown.desc': '-80% global cooldown, -50% global damage',
      'card.stat_global_dmg_2.desc': '+10% global damage',
      'card.stat_global_cd_2.desc': '-5% global cooldown',
      'card.stat_wall_hp_2.desc': '+20% wall max HP',
      'card.stat_coin_gain_2.desc': '+20% coin gain',
      'card.upg_fireball_dmg_2.desc': '+40% Fireball damage',
      'card.upg_chain_lightning_chains_2.desc': '+2 Chain Lightning chains',
      'card.upg_ice_wall_hp_2.desc': '+60% Ice Wall HP',
      'card.rule_seventh_slot.desc': 'Unlock a 7th skill slot',
    },
    'ko': {
      'gameTitle': '디펜스 게임',
      'startGame': '게임 시작',
      'gameDescription': '화면을 터치하여 적을 처치하세요!',
      'score': '점수: {score}',
      'gameOver': '게임 오버!',
      'tapToRestart': '탭하여 재시작',
      'restartGame': '다시 시작',
      'returnToMenu': '메뉴로 돌아가기',
      'lightningSkill': '번개',
      'freezeSkill': '얼음',
      'healSkill': '힐',
      'lightningSkillDesc': '무작위 적 5명 타격',
      'freezeSkillDesc': '적 이동 속도 50% 감소',
      'healSkillDesc': '기지 HP 30 회복',
      'wave': '웨이브',
      'nextWaveIn': '다음 웨이브까지',
      'skill.fireball.title': '화염구',
      'skill.chain_lightning.title': '연쇄 번개',
      'skill.ice_wall.title': '얼음 벽',
      'skill.arcane_missile.title': '신비한 미사일',
      'skill.frost_nova.title': '서리 고리',
      'skill.poison_cloud.title': '독 구름',
      'skill.healing_aura.title': '치유의 오라',
      'skill.shield_barrier.title': '보호막 장벽',
      'skill.berserk_rage.title': '광폭화',

      // Skill Descriptions
      'skill.fireball.desc': '화염 투사체를 발사합니다.',
      'skill.chain_lightning.desc': '적들 사이를 오가는 번개를 발사합니다.',
      'skill.ice_wall.desc': '적을 막는 얼음 벽을 생성합니다.',
      'skill.arcane_missile.desc': '마법 미사일을 발사합니다.',
      'skill.frost_nova.desc': '주변의 적들에게 피해를 주고 느리게 만듭니다.',
      'skill.poison_cloud.desc': '지속적으로 피해를 주는 독 구름을 생성합니다.',
      'skill.healing_aura.desc': '기지 HP를 일정량 회복시킵니다.',
      'skill.shield_barrier.desc': '기지에 임시 보호막을 부여합니다.',
      'skill.berserk_rage.desc': '일시적으로 공격력을 증가시키고 재사용 대기시간을 감소시킵니다.',

      // Variant Titles
      'variant.fireball_meteor.title': '유성',
      'variant.chain_lightning_static_field.title': '정전기장',
      'variant.ice_wall_shatter.title': '파편',
      'variant.arcane_missile_homing.title': '유도 미사일',
      'variant.frost_nova_expanding.title': '확장하는 서리 고리',
      'variant.berserk_rage_unleashed.title': '해방된 광기',

      // Variant Descriptions
      'variant.fireball_meteor.desc': '화염구가 강력한 유성이 됩니다.',
      'variant.chain_lightning_static_field.desc': '연쇄 번개가 피해를 주는 정전기장을 남깁니다.',
      'variant.ice_wall_shatter.desc': '얼음 벽이 만료될 때 산산조각나며 적들에게 피해를 줍니다.',
      'variant.arcane_missile_homing.desc': '신비한 미사일이 이제 적을 추적합니다.',
      'variant.frost_nova_expanding.desc': '서리 고리가 시간이 지남에 따라 확장됩니다.',
      'variant.berserk_rage_unleashed.desc': '공격력 대폭 증가 및 재사용 대기시간 대폭 감소.',

      'card.cursed_glass_cannon_1.title': '유리 대포',
      'card.cursed_glass_cannon_1.desc': '+80% 모든 공격력, -40% 기지 체력',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}