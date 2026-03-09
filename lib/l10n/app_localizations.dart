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
  String get waveCleared => _localizedValues[locale.languageCode]?['waveCleared'] ?? 'Wave Cleared!';

  String translate(String key) {
    if (key.isEmpty) return "";
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
      'waveCleared': 'Wave Cleared!',

      // --- UI ---
      'ui.equipped': 'Equipped',
      'tab.all': 'ALL',
      'faction.angel': 'ANGEL',
      'faction.demon': 'DEMON',
      'faction.ancient': 'ANCIENT',

      // --- Characters ---
      'char.michael.name': 'Michael',
      'char.michael.desc': 'Archangel of Judgment',
      'char.michael.passive': 'Light Damage +15%',
      'char.michael.trait': 'Bonus damage vs DARK',
      
      'char.raphael.name': 'Raphael',
      'char.raphael.desc': 'Guardian of Restoration',
      'char.raphael.passive': 'Heal +20%',
      'char.raphael.trait': 'Auto shield below 30% HP',

      'char.uriel.name': 'Uriel',
      'char.uriel.desc': 'Thunder Executor',
      'char.uriel.passive': 'Stun Chance Increase',
      'char.uriel.trait': 'Stunned enemies receive +30% damage',

      'char.gabriel.name': 'Gabriel',
      'char.gabriel.desc': 'Herald of Silence',
      'char.gabriel.passive': 'Debuff duration reduction',
      'char.gabriel.trait': 'Enemy attack -10% at wave start',

      'char.metatron.name': 'Metatron',
      'char.metatron.desc': 'Keeper of Records',
      'char.metatron.passive': 'Cooldown -15%',
      'char.metatron.trait': 'Chance to reset cooldown',

      'char.seraphim.name': 'Seraphim',
      'char.seraphim.desc': 'Flame of Purification',
      'char.seraphim.passive': 'Burn Stack +2',
      'char.seraphim.trait': 'Bonus damage vs Burned enemies',

      'char.lucifer.name': 'Lucifer',
      'char.lucifer.desc': 'Fallen Sovereign',
      'char.lucifer.passive': 'Low HP -> Attack Increase',
      'char.lucifer.trait': 'Crit restores HP',

      'char.asmodeus.name': 'Asmodeus',
      'char.asmodeus.desc': 'Plague Monarch',
      'char.asmodeus.passive': 'Poison Damage +30%',
      'char.asmodeus.trait': 'Poison spreads on kill',

      'char.baal.name': 'Baal',
      'char.baal.desc': 'Storm Tyrant',
      'char.baal.passive': 'Electric Damage +20%',
      'char.baal.trait': 'Bonus damage vs Stunned',

      'char.leviathan.name': 'Leviathan',
      'char.leviathan.desc': 'Abyss Leviathan',
      'char.leviathan.passive': 'Defense Ignore',
      'char.leviathan.trait': 'Bonus vs Shielded enemies',

      'char.beelzebub.name': 'Beelzebub',
      'char.beelzebub.desc': 'Lord of Decay',
      'char.beelzebub.passive': 'Healing Reduction 40%',
      'char.beelzebub.trait': 'Poison duration +3s',

      'char.abaddon.name': 'Abaddon',
      'char.abaddon.desc': 'Abyss Executioner',
      'char.abaddon.passive': 'Bonus vs Low HP',
      'char.abaddon.trait': 'Kill triggers explosion',

      'char.enoch.name': 'Enoch',
      'char.enoch.desc': 'Eternal Ascendant',
      'char.enoch.passive': 'Damage increases over time',
      'char.enoch.trait': 'Scaling bonus per wave',

      'char.samael.name': 'Samael',
      'char.samael.desc': 'Death Arbiter',
      'char.samael.passive': 'Execute below 20% HP',
      'char.samael.trait': 'Bonus single-target damage',

      'char.lilith.name': 'Lilith',
      'char.lilith.desc': 'Queen of Chaos',
      'char.lilith.passive': 'Damage increased per debuff',
      'char.lilith.trait': 'Applies random debuffs',

      'char.azazel.name': 'Azazel',
      'char.azazel.desc': 'Lightning Apostle',
      'char.azazel.passive': 'Crit triggers lightning',
      'char.azazel.trait': 'Multi-hit combo bonus',

      'char.gaia.name': 'Gaia',
      'char.gaia.desc': 'Earth Mother',
      'char.gaia.passive': 'HP Regen over time',
      'char.gaia.trait': 'Periodic shield generation',

      'char.apophis.name': 'Apophis',
      'char.apophis.desc': 'Devourer of Light',
      'char.apophis.passive': 'Reduce Light resistance',
      'char.apophis.trait': 'Dark damage amplification',

      // --- Skills ---
      'skill.SK_MICHAEL_JUDGMENT.name': 'Judgment Blade',
      'skill.SK_MICHAEL_JUDGMENT.desc': 'AoE Light + Fire damage, reduces Defense',
      
      'skill.SK_RAPHAEL_SANCTUARY.name': 'Divine Sanctuary',
      'skill.SK_RAPHAEL_SANCTUARY.desc': 'Applies a powerful holy shield to all allies',

      'skill.SK_URIEL_THUNDER.name': 'Heavenly Thunder',
      'skill.SK_URIEL_THUNDER.desc': 'AoE Electric damage and stun enemies',

      'skill.SK_GABRIEL_TRUMPET.name': 'Final Trumpet',
      'skill.SK_GABRIEL_TRUMPET.desc': 'AoE silence and magic damage to all enemies',

      'skill.SK_SERAPHIM_INFERNO.name': 'Sacred Inferno',
      'skill.SK_SERAPHIM_INFERNO.desc': 'Applies stacking burn in a targeted area',

      'skill.SK_METATRON_CHRONO.name': 'Chrono Archive',
      'skill.SK_METATRON_CHRONO.desc': 'Reduces cooldowns of all allies',

      'skill.SK_LUCIFER_CATACLYSM.name': 'Fallen Cataclysm',
      'skill.SK_LUCIFER_CATACLYSM.desc': 'Massive Dark explosion with life steal',

      'skill.SK_ASMODEUS_CORRUPTION.name': 'Corruption Bloom',
      'skill.SK_ASMODEUS_CORRUPTION.desc': 'Applies poison and defense down',

      'skill.BAAL_STORM.name': 'Thunder Dominion',
      'skill.BAAL_STORM.desc': 'Chain lightning that shocks multiple enemies',

      'skill.SK_LEVIATHAN_ABYSS.name': 'Abyss Collapse',
      'skill.SK_LEVIATHAN_ABYSS.desc': 'Ignores armor and destroys enemy shields',

      'skill.SK_BEELZEBUB_PLAGUE.name': 'Plague Swarm',
      'skill.SK_BEELZEBUB_PLAGUE.desc': 'Spreads infection and reduces healing',

      'skill.SK_ABADDON_EXECUTE.name': 'Abyss Execution',
      'skill.SK_ABADDON_EXECUTE.desc': 'Executes low HP targets with high physical damage',

      'skill.SK_ENOCH_ASCENSION.name': 'Ascension Protocol',
      'skill.SK_ENOCH_ASCENSION.desc': 'Increases own damage through stacking buffs',

      'skill.SK_SAMAEL_MARK.name': 'Death Mark',
      'skill.SK_SAMAEL_MARK.desc': 'Marks a single target for massive damage amplification',

      'skill.SK_LILITH_CHAOS.name': 'Queen\'s Temptation',
      'skill.SK_LILITH_CHAOS.desc': 'Applies confusion and random debuffs',

      'skill.SK_AZAZEL_CRITICAL.name': 'Fallen Lightning Rush',
      'skill.SK_AZAZEL_CRITICAL.desc': 'Fast multi-hit combo with crit boost',

      'skill.SK_GAIA_GUARDIAN.name': 'Earth Mother Embrace',
      'skill.SK_GAIA_GUARDIAN.desc': 'Reduces damage taken for all allies',

      'skill.SK_APOPHIS_VOID.name': 'Solar Devourer',
      'skill.SK_APOPHIS_VOID.desc': 'Dark beam attack with high penetration',

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
      'card.lvl_fireball.title': 'Fireball Level Up',
      'card.lvl_chain_lightning.title': 'Chain Lightning Level Up',
      'card.lvl_ice_wall.title': 'Ice Wall Level Up',
      'card.lvl_arcane_missile.title': 'Arcane Missile Level Up',
      'card.lvl_frost_nova.title': 'Frost Nova Level Up',
      'card.lvl_poison_cloud.title': 'Poison Cloud Level Up',
      'card.lvl_healing_aura.title': 'Healing Aura Level Up',
      'card.lvl_shield_barrier.title': 'Shield Barrier Level Up',
      'card.lvl_berserk_rage.title': 'Berserk Rage Level Up',
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
      'card.lvl_fireball.desc': 'Increase Fireball level by 1',
      'card.lvl_chain_lightning.desc': 'Increase Chain Lightning level by 1',
      'card.lvl_ice_wall.desc': 'Increase Ice Wall level by 1',
      'card.lvl_arcane_missile.desc': 'Increase Arcane Missile level by 1',
      'card.lvl_frost_nova.desc': 'Increase Frost Nova level by 1',
      'card.lvl_poison_cloud.desc': 'Increase Poison Cloud level by 1',
      'card.lvl_healing_aura.desc': 'Increase Healing Aura level by 1',
      'card.lvl_shield_barrier.desc': 'Increase Shield Barrier level by 1',
      'card.lvl_berserk_rage.desc': 'Increase Berserk Rage level by 1',
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
      'waveCleared': '웨이브 클리어!',

      // --- UI ---
      'ui.equipped': '출전 중',
      'tab.all': '전체',
      'faction.angel': '천사',
      'faction.demon': '악마',
      'faction.ancient': '고대',

      // --- Characters ---
      'char.michael.name': '미카엘',
      'char.michael.desc': '심판의 대천사',
      'char.michael.passive': '빛 속성 피해 +15%',
      'char.michael.trait': '어둠 속성 적에게 추가 피해',

      'char.raphael.name': '라파엘',
      'char.raphael.desc': '회복의 수호자',
      'char.raphael.passive': '치유 효과 +20%',
      'char.raphael.trait': '체력 30% 이하 시 자동 보호막 생성',

      'char.uriel.name': '우리엘',
      'char.uriel.desc': '천벌의 집행자',
      'char.uriel.passive': '기절 확률 증가',
      'char.uriel.trait': '기절한 적에게 +30% 추가 피해',

      'char.gabriel.name': '가브리엘',
      'char.gabriel.desc': '침묵의 전령',
      'char.gabriel.passive': '자신에게 걸린 디버프 지속 시간 감소',
      'char.gabriel.trait': '웨이브 시작 시 적 공격력 -10% (5초)',

      'char.metatron.name': '메타트론',
      'char.metatron.desc': '기록의 보관자',
      'char.metatron.passive': '스킬 재사용 대기시간 -15%',
      'char.metatron.trait': '스킬 사용 시 낮은 확률로 쿨타임 초기화',

      'char.seraphim.name': '세라핌',
      'char.seraphim.desc': '정화의 불꽃',
      'char.seraphim.passive': '화상 중첩 한도 +2',
      'char.seraphim.trait': '화상 상태인 적에게 추가 피해',

      'char.lucifer.name': '루시퍼',
      'char.lucifer.desc': '타락한 군주',
      'char.lucifer.passive': '낮은 체력에서 공격력 증가',
      'char.lucifer.trait': '치명타 발생 시 체력 회복',

      'char.asmodeus.name': '아스모데우스',
      'char.asmodeus.desc': '역병의 군주',
      'char.asmodeus.passive': '독 피해 +30%',
      'char.asmodeus.trait': '처치 시 주변 적에게 독 전염',

      'char.baal.name': '바알',
      'char.baal.desc': '폭풍의 폭군',
      'char.baal.passive': '번개 피해 +20%',
      'char.baal.trait': '기절한 적에게 추가 피해',

      'char.leviathan.name': '레비아탄',
      'char.leviathan.desc': '심연의 레비아탄',
      'char.leviathan.passive': '방어력 관통',
      'char.leviathan.trait': '보호막이 있는 적에게 추가 피해',

      'char.beelzebub.name': '바알세불',
      'char.beelzebub.desc': '부패의 주인',
      'char.beelzebub.passive': '치유 감소 40%',
      'char.beelzebub.trait': '독 지속 시간 +3초',

      'char.abaddon.name': '아바돈',
      'char.abaddon.desc': '심연의 처형자',
      'char.abaddon.passive': '낮은 체력의 적에게 추가 피해',
      'char.abaddon.trait': '처치 시 폭발 발생',

      'char.enoch.name': '에녹',
      'char.enoch.desc': '영원한 승천자',
      'char.enoch.passive': '시간이 지남에 따라 피해량 증가',
      'char.enoch.trait': '웨이브마다 성장 보너스 중첩',

      'char.samael.name': '사마엘',
      'char.samael.desc': '죽음의 중재자',
      'char.samael.passive': '체력 20% 이하 적 즉사 (확률)',
      'char.samael.trait': '단일 대상 추가 피해',

      'char.lilith.name': '릴리스',
      'char.lilith.desc': '혼돈의 여왕',
      'char.lilith.passive': '대상의 디버프 개수당 피해량 증가',
      'char.lilith.trait': '무작위 디버프 부여',

      'char.azazel.name': '아자젤',
      'char.azazel.desc': '번개의 사도',
      'char.azazel.passive': '치명타 발생 시 번개 타격',
      'char.azazel.trait': '다단 히트 콤보 보너스',

      'char.gaia.name': '가이아',
      'char.gaia.desc': '대지의 어머니',
      'char.gaia.passive': '지속적인 체력 재생',
      'char.gaia.trait': '주기적으로 보호막 생성',

      'char.apophis.name': '아포피스',
      'char.apophis.desc': '빛을 삼키는 자',
      'char.apophis.passive': '빛 저항력 감소',
      'char.apophis.trait': '어둠 속성 피해 증폭',

      // --- Skills ---
      'skill.SK_MICHAEL_JUDGMENT.name': '심판의 칼날',
      'skill.SK_MICHAEL_JUDGMENT.desc': '빛과 불꽃의 광역 피해를 입히고 방어력을 감소시킵니다',
      
      'skill.SK_RAPHAEL_SANCTUARY.name': '신성한 성역',
      'skill.SK_RAPHAEL_SANCTUARY.desc': '모든 아군에게 강력한 신성 보호막을 부여합니다',

      'skill.SK_URIEL_THUNDER.name': '천상의 번개',
      'skill.SK_URIEL_THUNDER.desc': '광역 번개 피해를 입히고 적들을 기절시킵니다',

      'skill.SK_GABRIEL_TRUMPET.name': '최후의 나팔',
      'skill.SK_GABRIEL_TRUMPET.desc': '모든 적에게 침묵 효과와 마법 피해를 입힙니다',

      'skill.SK_SERAPHIM_INFERNO.name': '성스러운 인페르노',
      'skill.SK_SERAPHIM_INFERNO.desc': '지정된 범위 내에 중첩되는 화상 효과를 부여합니다',

      'skill.SK_METATRON_CHRONO.name': '크로노 아카이브',
      'skill.SK_METATRON_CHRONO.desc': '모든 아군의 스킬 재사용 대기시간을 감소시킵니다',

      'skill.SK_LUCIFER_CATACLYSM.name': '타락한 대재앙',
      'skill.SK_LUCIFER_CATACLYSM.desc': '생명력 흡수 효과가 있는 거대한 어둠 폭발을 일으킵니다',

      'skill.SK_ASMODEUS_CORRUPTION.name': '부패의 꽃',
      'skill.SK_ASMODEUS_CORRUPTION.desc': '독 피해를 입히고 적의 방어력을 감소시킵니다',

      'skill.BAAL_STORM.name': '번개의 지배',
      'skill.BAAL_STORM.desc': '여러 적을 감전시키는 연쇄 번개를 발사합니다',

      'skill.SK_LEVIATHAN_ABYSS.name': '심연의 붕괴',
      'skill.SK_LEVIATHAN_ABYSS.desc': '방어력을 무시하고 적의 보호막을 파괴합니다',

      'skill.SK_BEELZEBUB_PLAGUE.name': '역병 무리',
      'skill.SK_BEELZEBUB_PLAGUE.desc': '감염을 퍼뜨리고 적의 치유 효과를 감소시킵니다',

      'skill.SK_ABADDON_EXECUTE.name': '심연의 처형',
      'skill.SK_ABADDON_EXECUTE.desc': '낮은 체력의 적에게 강력한 물리 피해로 처형을 시도합니다',

      'skill.SK_ENOCH_ASCENSION.name': '승천 프로토콜',
      'skill.SK_ENOCH_ASCENSION.desc': '중첩되는 버프를 통해 자신의 피해량을 증가시킵니다',

      'skill.SK_SAMAEL_MARK.name': '죽음의 표식',
      'skill.SK_SAMAEL_MARK.desc': '단일 대상에게 받는 피해를 대폭 증폭시키는 표식을 남깁니다',

      'skill.SK_LILITH_CHAOS.name': '여왕의 유혹',
      'skill.SK_LILITH_CHAOS.desc': '적들에게 혼란 효과와 무작위 디버프를 부여합니다',

      'skill.SK_AZAZEL_CRITICAL.name': '타락한 뇌광 돌진',
      'skill.SK_AZAZEL_CRITICAL.desc': '치명타 확률이 증가하는 빠른 연타 콤보를 시전합니다',

      'skill.SK_GAIA_GUARDIAN.name': '대지의 어머니의 포옹',
      'skill.SK_GAIA_GUARDIAN.desc': '모든 아군이 받는 피해를 감소시킵니다',

      'skill.SK_APOPHIS_VOID.name': '태양을 삼키는 자',
      'skill.SK_APOPHIS_VOID.desc': '관통력이 높은 어둠의 광선을 발사합니다',

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

      // Card Titles
      'card.stat_global_dmg_1.title': '공격력 강화',
      'card.stat_global_cd_1.title': '재사용 대기시간 감소',
      'card.stat_wall_hp_1.title': '성벽 보강',
      'card.stat_coin_gain_1.title': '코인 자석',
      'card.lvl_fireball.title': '화염구 레벨 업',
      'card.lvl_chain_lightning.title': '연쇄 번개 레벨 업',
      'card.lvl_ice_wall.title': '얼음 벽 레벨 업',
      'card.lvl_arcane_missile.title': '신비한 미사일 레벨 업',
      'card.lvl_frost_nova.title': '서리 고리 레벨 업',
      'card.lvl_poison_cloud.title': '독 구름 레벨 업',
      'card.lvl_healing_aura.title': '치유의 오라 레벨 업',
      'card.lvl_shield_barrier.title': '보호막 장벽 레벨 업',
      'card.lvl_berserk_rage.title': '광폭화 레벨 업',
      'card.upg_fireball_dmg_1.title': '강력한 화염구',
      'card.upg_fireball_cd_1.title': '신속한 화염구',
      'card.upg_chain_lightning_dmg_1.title': '전류 강화',
      'card.upg_chain_lightning_chains_1.title': '과충전 번개',
      'card.upg_ice_wall_hp_1.title': '두꺼운 얼음 벽',
      'card.upg_ice_wall_duration_1.title': '견고한 얼음 벽',
      'card.var_fireball_meteor.title': '유성 낙하',
      'card.util_wall_repair_1.title': '긴급 수리',
      'card.util_shield_1.title': '보호막',
      'card.util_reroll_1.title': '다시 뽑기',
      'card.rule_sixth_slot.title': '육감',
      'card.cursed_glass_cannon_1.title': '유리 대포',
      'card.cursed_overcharge_1.title': '오버차지',
      'card.stat_projectile_speed_1.title': '신속한 투사체',
      'card.stat_projectile_size_1.title': '거대 투사체',
      'card.stat_area_of_effect_1.title': '광역 강화',
      'card.upg_frost_nova_cd_1.title': '신속한 서리 고리',
      'card.upg_frost_nova_radius_1.title': '넓은 서리 고리',
      'card.upg_arcane_missile_dmg_1.title': '날카로운 미사일',
      'card.upg_arcane_missile_count_1.title': '미사일 폭격',
      'card.var_chain_lightning_stun.title': '충격 번개',
      'card.var_ice_wall_spikes.title': '가시 성벽',
      'card.util_wall_repair_2.title': '대규모 수리',
      'card.util_shield_2.title': '대형 보호막',
      'card.util_reroll_2.title': '추가 기회',
      'card.cursed_berserker_1.title': '광전사',
      'card.cursed_no_cooldown.title': '무한의 마력',
      'card.stat_global_dmg_2.title': '공격력 강화 II',
      'card.stat_global_cd_2.title': '재사용 대기시간 감소 II',
      'card.stat_wall_hp_2.title': '성벽 보강 II',
      'card.stat_coin_gain_2.title': '코인 자석 II',
      'card.upg_fireball_dmg_2.title': '강력한 화염구 II',
      'card.upg_chain_lightning_chains_2.title': '과충전 번개 II',
      'card.upg_ice_wall_hp_2.title': '두꺼운 얼음 벽 II',
      'card.rule_seventh_slot.title': '칠감',

      // Card Descriptions
      'card.stat_global_dmg_1.desc': '+5% 모든 공격력',
      'card.stat_global_cd_1.desc': '-3% 전역 재사용 대기시간',
      'card.stat_wall_hp_1.desc': '+10% 성벽 최대 체력',
      'card.stat_coin_gain_1.desc': '+10% 코인 획득량',
      'card.lvl_fireball.desc': '화염구 레벨 +1',
      'card.lvl_chain_lightning.desc': '연쇄 번개 레벨 +1',
      'card.lvl_ice_wall.desc': '얼음 벽 레벨 +1',
      'card.lvl_arcane_missile.desc': '신비한 미사일 레벨 +1',
      'card.lvl_frost_nova.desc': '서리 고리 레벨 +1',
      'card.lvl_poison_cloud.desc': '독 구름 레벨 +1',
      'card.lvl_healing_aura.desc': '치유의 오라 레벨 +1',
      'card.lvl_shield_barrier.desc': '보호막 장벽 레벨 +1',
      'card.lvl_berserk_rage.desc': '광폭화 레벨 +1',
      'card.upg_fireball_dmg_1.desc': '+20% 화염구 피해량',
      'card.upg_fireball_cd_1.desc': '-10% 화염구 재사용 대기시간',
      'card.upg_chain_lightning_dmg_1.desc': '+25% 연쇄 번개 피해량',
      'card.upg_chain_lightning_chains_1.desc': '+1 연쇄 번개 튕김 횟수',
      'card.upg_ice_wall_hp_1.desc': '+30% 얼음 벽 체력',
      'card.upg_ice_wall_duration_1.desc': '+2초 얼음 벽 지속 시간',
      'card.var_fireball_meteor.desc': '화염구가 유성으로 변합니다.',
      'card.util_wall_repair_1.desc': '성벽 체력을 20% 회복합니다.',
      'card.util_shield_1.desc': '최대 체력의 25%만큼 보호막을 얻습니다.',
      'card.util_reroll_1.desc': '다시 뽑기 기회 +1',
      'card.rule_sixth_slot.desc': '6번째 스킬 슬롯을 해제합니다.',
      'card.cursed_glass_cannon_1.desc': '+80% 모든 공격력, -40% 성벽 최대 체력',
      'card.cursed_overcharge_1.desc': '-40% 전역 재사용 대기시간, 코인 획득 불가',
      'card.stat_projectile_speed_1.desc': '+15% 투사체 이동 속도',
      'card.stat_projectile_size_1.desc': '+10% 투사체 크기',
      'card.stat_area_of_effect_1.desc': '+15% 공격 범위',
      'card.upg_frost_nova_cd_1.desc': '-15% 서리 고리 재사용 대기시간',
      'card.upg_frost_nova_radius_1.desc': '+20% 서리 고리 범위',
      'card.upg_arcane_missile_dmg_1.desc': '+15% 신비한 미사일 피해량',
      'card.upg_arcane_missile_count_1.desc': '+1 신비한 미사일 발사 수',
      'card.var_chain_lightning_stun.desc': '연쇄 번개가 적을 기절시킵니다.',
      'card.var_ice_wall_spikes.desc': '얼음 벽에 닿은 적이 피해를 입습니다.',
      'card.util_wall_repair_2.desc': '성벽 체력을 50% 회복합니다.',
      'card.util_shield_2.desc': '최대 체력의 60%만큼 보호막을 얻습니다.',
      'card.util_reroll_2.desc': '다시 뽑기 기회 +2',
      'card.cursed_berserker_1.desc': '+150% 모든 공격력, -75% 성벽 최대 체력',
      'card.cursed_no_cooldown.desc': '-80% 재사용 대기시간, -50% 모든 공격력',
      'card.stat_global_dmg_2.desc': '+10% 모든 공격력',
      'card.stat_global_cd_2.desc': '-5% 전역 재사용 대기시간',
      'card.stat_wall_hp_2.desc': '+20% 성벽 최대 체력',
      'card.stat_coin_gain_2.desc': '+20% 코인 획득량',
      'card.upg_fireball_dmg_2.desc': '+40% 화염구 피해량',
      'card.upg_chain_lightning_chains_2.desc': '+2 연쇄 번개 튕김 횟수',
      'card.upg_ice_wall_hp_2.desc': '+60% 얼음 벽 체력',
      'card.rule_seventh_slot.desc': '7번째 스킬 슬롯을 해제합니다.',
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