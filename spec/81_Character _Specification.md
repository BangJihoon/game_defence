# Character & Skill Master Specification
Project: game_defence
Theme: Temple Defense – Gods Protecting the Sanctuary
Version: 2.1 (Synced with assets/data/skills.json)

This document provides the definitive list of characters and their associated skills, including combat stats, ranges, and effects.

---

# 1. Element System

## Elements
- **FIRE**: Strong vs NATURE, ICE | Weak vs WATER
- **WATER**: Strong vs FIRE | Weak vs NATURE, ELECTRIC
- **NATURE**: Strong vs WATER | Weak vs FIRE
- **ELECTRIC**: Strong vs WATER | Neutral vs Others
- **ICE**: Strong vs FIRE | Neutral vs Others
- **LIGHT**: Strong vs DARK (Mutual Counter)
- **DARK**: Strong vs LIGHT (Mutual Counter)
- **NONE**: Neutral

**Multipliers:** Strong (1.3x) / Weak (0.75x) / Neutral (1.0x)

---

# 2. Angel Faction

## [01] MICHAEL – Archblade of Judgment
- **Elements**: Primary LIGHT / Secondary FIRE
- **Role**: BURST_DPS
- **Stats**: HP 1200 | ATK 180 | SPD 1.2 | CRIT 15%
- **Passive**: Radiant Blade (Light damage +15%)
- **Trait**: Dark Slayer (25% bonus damage to DARK enemies)
- **Skill**: **Judgment Blade**
  - **Type**: FRONT_CONE | **Range**: 300 | **CD**: 8s
  - **Power**: 2.8x Multiplier | **Hits**: 1
  - **Effect**: Reduces Defense by 20% (3s)

## [02] RAPHAEL – Guardian of Restoration
- **Elements**: Primary LIGHT / Secondary WATER
- **Role**: HEALER
- **Stats**: HP 1500 | ATK 90 | SPD 1.0 | CRIT 5%
- **Passive**: Holy Grace (Healing effect +20%)
- **Trait**: Guardian Shield (Generate shield below 30% HP)
- **Skill**: **Divine Sanctuary**
  - **Type**: ALLY_AREA | **Range**: 400 | **CD**: 10s
  - **Power**: 0.0x Multiplier | **Hits**: 0
  - **Effect**: Applies Shield (25% value, 5s)

## [03] URIEL – Thunder Executor
- **Elements**: Primary LIGHT / Secondary ELECTRIC
- **Role**: CONTROL_DPS
- **Stats**: HP 1100 | ATK 140 | SPD 1.4 | CRIT 12%
- **Passive**: Thunder Will (Increase stun chance)
- **Trait**: Execution Shock (Bonus damage to stunned enemies)
- **Skill**: **Heavenly Thunder**
  - **Type**: CHAIN | **Range**: 500 | **CD**: 7s
  - **Power**: 2.2x Multiplier | **Hits**: 3
  - **Effect**: Applies Stun (1.5s)

## [04] GABRIEL – Herald of Silence
- **Elements**: Primary LIGHT / Secondary WATER
- **Role**: DEBUFFER
- **Stats**: HP 1150 | ATK 130 | SPD 1.1 | CRIT 10%
- **Passive**: Sacred Calm (Debuff duration on self -30%)
- **Trait**: Divine Weakening (Reduce enemy attack at wave start)
- **Skill**: **Final Trumpet**
  - **Type**: GLOBAL | **Range**: 9999 | **CD**: 12s
  - **Power**: 1.5x Multiplier | **Hits**: 1
  - **Effect**: Applies Silence (2s)

## [05] METATRON – Keeper of Records
- **Elements**: Primary LIGHT / Secondary ELECTRIC
- **Role**: UTILITY
- **Stats**: HP 1100 | ATK 120 | SPD 1.2 | CRIT 10%
- **Passive**: Chronicle (Cooldown -15%)
- **Trait**: Skill Echo (Chance to reset skill cooldown)
- **Skill**: **Chrono Archive**
  - **Type**: ALLY_GLOBAL | **Range**: 9999 | **CD**: 14s
  - **Power**: 0.0x Multiplier | **Hits**: 0
  - **Effect**: Cooldown Reduction (30% value, 5s)

## [06] SERAPHIM – Flame of Purification
- **Elements**: Primary FIRE / Secondary LIGHT
- **Role**: DOT_DPS
- **Stats**: HP 1000 | ATK 170 | SPD 1.3 | CRIT 10%
- **Passive**: Sacred Flame (Burn stack +2)
- **Trait**: Flame Amplify (Burned enemies take extra damage)
- **Skill**: **Sacred Inferno**
  - **Type**: AREA | **Range**: 300 | **CD**: 8s
  - **Power**: 1.2x Multiplier | **Hits**: 1
  - **Effect**: Applies Burn (15% value, 5s, Max 5 stacks)

---

# 3. Demon Faction

## [07] LUCIFER – Fallen Sovereign
- **Elements**: Primary DARK / Secondary FIRE
- **Role**: RISK_DPS
- **Stats**: HP 950 | ATK 210 | SPD 1.3 | CRIT 20%
- **Passive**: Fallen Power (Low HP increases attack)
- **Trait**: Blood Pact (Crit restores HP)
- **Skill**: **Fallen Cataclysm**
  - **Type**: AREA | **Range**: 350 | **CD**: 9s
  - **Power**: 3.5x Multiplier | **Hits**: 1
  - **Effect**: Applies Life Steal (25% value, 3s)

## [08] ASMODEUS – Plague Monarch
- **Elements**: Primary DARK / Secondary NATURE
- **Role**: POISON_DPS
- **Stats**: HP 1100 | ATK 150 | SPD 1.2 | CRIT 10%
- **Passive**: Plague Master (Poison damage +30%)
- **Trait**: Toxic Spread (Poison spreads on kill)
- **Skill**: **Corruption Bloom**
  - **Type**: AREA | **Range**: 320 | **CD**: 8s
  - **Power**: 1.8x Multiplier | **Hits**: 1
  - **Effect**: Applies Poison (12% value, 6s, Max 3 stacks)

## [09] BAAL – Storm Tyrant
- **Elements**: Primary ELECTRIC / Secondary DARK
- **Role**: AOE_DPS
- **Stats**: HP 1150 | ATK 170 | SPD 1.2 | CRIT 12%
- **Passive**: Storm Authority (Electric damage +20%)
- **Trait**: Shock Amplify (Bonus vs stunned enemies)
- **Skill**: **Thunder Dominion**
  - **Type**: CHAIN | **Range**: 500 | **CD**: 7s
  - **Power**: 2.0x Multiplier | **Hits**: 4
  - **Effect**: Applies Shock (10% value, 4s, Max 3 stacks)

## [10] LEVIATHAN – Abyss Leviathan
- **Elements**: Primary WATER / Secondary DARK
- **Role**: TANK_BREAKER
- **Stats**: HP 1600 | ATK 130 | SPD 1.0 | CRIT 5%
- **Passive**: Abyss Pressure (Ignores defense)
- **Trait**: Shield Devour (Bonus vs shielded enemies)
- **Skill**: **Abyss Collapse**
  - **Type**: LINE | **Range**: 400 | **CD**: 10s
  - **Power**: 3.0x Multiplier | **Hits**: 1
  - **Effect**: Armor Ignore (30% value, 4s)

## [11] BEELZEBUB – Lord of Decay
- **Elements**: Primary NATURE / Secondary DARK
- **Role**: ANTI_HEAL
- **Stats**: HP 1200 | ATK 140 | SPD 1.1 | CRIT 8%
- **Passive**: Decay Aura (Healing reduction 40%)
- **Trait**: Infection Boost (Poison duration increased)
- **Skill**: **Plague Swarm**
  - **Type**: AREA | **Range**: 350 | **CD**: 9s
  - **Power**: 1.6x Multiplier | **Hits**: 1
  - **Effect**: Healing Reduction (40% value, 5s)

## [12] ABADDON – Abyss Executioner
- **Elements**: Primary DARK / Secondary ELECTRIC
- **Role**: EXECUTIONER
- **Stats**: HP 1100 | ATK 190 | SPD 1.2 | CRIT 15%
- **Passive**: Final Judgment (Bonus vs low HP enemies)
- **Trait**: Death Explosion (Kill triggers explosion)
- **Skill**: **Abyss Execution**
  - **Type**: SINGLE | **Range**: 300 | **CD**: 10s
  - **Power**: 4.0x Multiplier | **Hits**: 1
  - **Effect**: Execute (Targets below 25% HP)

---

# 4. Ancient / Special Faction

## [13] ENOCH – Eternal Ascendant
- **Elements**: Primary LIGHT / Secondary NATURE
- **Role**: SCALING_DPS
- **Stats**: HP 1200 | ATK 140 | SPD 1.1 | CRIT 10%
- **Passive**: Eternal Growth (Damage increases over time)
- **Trait**: Ascendant Force (Scaling bonus per wave)
- **Skill**: **Ascension Protocol**
  - **Type**: SELF | **Range**: 0 | **CD**: 12s
  - **Power**: 0.0x Multiplier | **Hits**: 0
  - **Effect**: Stack Damage Boost (10% per stack, 8s, Max 5 stacks)

## [14] SAMAEL – Death Arbiter
- **Elements**: Primary DARK / Secondary NATURE
- **Role**: EXECUTE_SPECIALIST
- **Stats**: HP 1000 | ATK 200 | SPD 1.3 | CRIT 18%
- **Passive**: Death Mark (Execute below threshold)
- **Trait**: Fatal Precision (Bonus single-target damage)
- **Skill**: **Death Mark**
  - **Type**: SINGLE | **Range**: 400 | **CD**: 8s
  - **Power**: 1.5x Multiplier | **Hits**: 1
  - **Effect**: Death Mark (25% damage amplification, 5s)

## [15] LILITH – Queen of Chaos
- **Elements**: Primary DARK / Secondary FIRE
- **Role**: DEBUFF_DPS
- **Stats**: HP 1050 | ATK 160 | SPD 1.2 | CRIT 12%
- **Passive**: Chaos Aura (Damage increases per debuff)
- **Trait**: Dark Seduction (Random debuff application)
- **Skill**: **Queen's Temptation**
  - **Type**: AREA | **Range**: 350 | **CD**: 9s
  - **Power**: 1.7x Multiplier | **Hits**: 1
  - **Effect**: Confusion (Random movement, 4s)

## [16] AZAZEL – Lightning Apostle
- **Elements**: Primary ELECTRIC / Secondary DARK
- **Role**: CRIT_COMBO
- **Stats**: HP 1000 | ATK 185 | SPD 1.4 | CRIT 20%
- **Passive**: Lightning Reflex (Crit triggers lightning strike)
- **Trait**: Combo Drive (Increased multi-hit damage)
- **Skill**: **Fallen Lightning Rush**
  - **Type**: FRONT_CONE | **Range**: 300 | **CD**: 6s
  - **Power**: 2.5x Multiplier | **Hits**: 2
  - **Effect**: Crit Boost (30% value, 4s)

## [17] GAIA – Earth Mother
- **Elements**: Primary NATURE / Secondary WATER
- **Role**: DEFENDER
- **Stats**: HP 1700 | ATK 110 | SPD 1.0 | CRIT 5%
- **Passive**: Earth Regen (HP regen over time)
- **Trait**: Nature Shield (Periodic shield generation)
- **Skill**: **Earth Mother Embrace**
  - **Type**: ALLY_AREA | **Range**: 400 | **CD**: 11s
  - **Power**: 0.0x Multiplier | **Hits**: 0
  - **Effect**: Damage Reduction (25% value, 6s)

## [18] APOPHIS – Devourer of Light
- **Elements**: Primary DARK / Secondary WATER
- **Role**: RESIST_BREAKER
- **Stats**: HP 1300 | ATK 175 | SPD 1.1 | CRIT 12%
- **Passive**: Light Devourer (Reduce Light resistance)
- **Trait**: Dark Pressure (Dark damage amplification)
- **Skill**: **Solar Devourer**
  - **Type**: LINE | **Range**: 600 | **CD**: 12s
  - **Power**: 3.2x Multiplier | **Hits**: 1
  - **Effect**: Penetration (40% value, 4s)
