# Character System Specification
Project: game_defence
Theme: Temple Defense – Gods Protecting the Sanctuary
Version: 1.1 (All 18 Characters Defined)

---

# 1. Element System

## Elements

- FIRE
- WATER
- ICE
- NATURE
- ELECTRIC
- LIGHT
- DARK
- NONE

---

## Element Relationships

- FIRE > NATURE
- NATURE > WATER
- WATER > FIRE
- ELECTRIC > WATER
- ICE > FIRE
- FIRE > ICE
- LIGHT ↔ DARK (Mutual Counter)

Strong: 1.3x  
Weak: 0.75x  
Neutral: 1.0x  

---

# 2. Angel Faction

---

## 1. MICHAEL

- Primary: LIGHT
- Secondary: FIRE
- Role: Burst DPS

Passive:
Light Damage +15%

Trait:
Bonus damage vs DARK

Skill:
Judgment Blade  
AoE Light + Fire damage  
Reduces Dark resistance

Meta:
Primary Dark Counter / Boss Burst

---

## 2. RAPHAEL

- Primary: LIGHT
- Secondary: WATER
- Role: Sustain / Healer

Passive:
Heal +20%

Trait:
Auto shield below 30% HP

Skill:
Divine Purification  
Heal + Cleanse

Meta:
Long Fight / PvP Sustain

---

## 3. URIEL

- Primary: LIGHT
- Secondary: ELECTRIC
- Role: Crowd Control

Passive:
Stun Chance Increase

Skill:
Heavenly Thunder  
AoE Electric + Stun

Meta:
Wave Control Specialist

---

## 4. GABRIEL

- Primary: LIGHT
- Secondary: WATER
- Role: Silence / Debuff

Passive:
Debuff duration reduction

Skill:
Final Trumpet  
AoE Silence + Damage

Meta:
Buff Counter / PvP Disruptor

---

## 5. METATRON

- Primary: LIGHT
- Secondary: ELECTRIC
- Role: Cooldown Manipulator

Passive:
Cooldown -15%

Skill:
Heavenly Record  
Reduces team cooldown

Meta:
Skill Spam / Combo Engine

---

## 6. SERAPHIM

- Primary: FIRE
- Secondary: LIGHT
- Role: Burn DPS

Passive:
Burn Stack +2

Skill:
Purifying Flame  
Applies Burn

Meta:
Boss Damage Over Time

---

# 3. Demon Faction

---

## 7. LUCIFER

- Primary: DARK
- Secondary: FIRE
- Role: Risk Burst

Passive:
Low HP → Attack Increase

Skill:
Fallen Radiance  
Dark AoE Explosion

Meta:
Comeback Carry

---

## 8. ASMODEUS

- Primary: DARK
- Secondary: NATURE
- Role: Poison DPS

Passive:
Poison Damage +30%

Skill:
Corruption Seed  
Poison + Defense Down

Meta:
Anti-Heal Meta

---

## 9. BAAL

- Primary: ELECTRIC
- Secondary: DARK
- Role: AoE Burst

Passive:
Electric Damage +20%

Skill:
Infernal Storm  
Chain Lightning AoE

Meta:
Wave Clear

---

## 10. LEVIATHAN

- Primary: WATER
- Secondary: DARK
- Role: Shield Breaker

Passive:
Defense Ignore

Skill:
Abyssal Wave  
Shield Destruction

Meta:
Tank Counter

---

## 11. BEELZEBUB

- Primary: NATURE
- Secondary: DARK
- Role: Infection / Healing Reduction

Passive:
Healing Reduction 40%

Skill:
Swarm Plague  
Spread Infection

Meta:
Healer Shutdown

---

## 12. ABADDON

- Primary: DARK
- Secondary: ELECTRIC
- Role: Execution

Passive:
Bonus vs Low HP

Skill:
Abyss Storm  
Kill → Explosion

Meta:
End Wave Finisher

---

# 4. Ancient / Special Faction

---

## 13. ENOCH

- Primary: LIGHT
- Secondary: NATURE
- Role: Scaling DPS

Passive:
Damage increases over time

Skill:
Ascension Pulse  
Damage grows each cast

Meta:
Long Duration Scaling

---

## 14. SAMAEL

- Primary: DARK
- Secondary: NATURE
- Role: Execution Specialist

Passive:
Execute below 20% HP

Skill:
Death Sentence  
High single-target burst

Meta:
Boss Finisher

---

## 15. LILITH

- Primary: DARK
- Secondary: FIRE
- Role: Chaos Debuff

Passive:
Damage increased per debuff

Skill:
Queen of Chaos  
Applies random debuffs

Meta:
PvP Control Meta

---

## 16. AZAZEL

- Primary: ELECTRIC
- Secondary: DARK
- Role: Combo Burst

Passive:
Crit triggers lightning

Skill:
Divine Fragment  
Multi-hit burst

Meta:
Crit Combo Engine

---

## 17. GAIA

- Primary: NATURE
- Secondary: WATER
- Role: Defensive Sustain

Passive:
HP Regen over time

Skill:
Heart of Earth  
Creates protective field

Meta:
Defense Anchor

---

## 18. APOPHIS

- Primary: DARK
- Secondary: WATER
- Role: Resistance Breaker

Passive:
Reduces Light resistance

Skill:
Devour the Sun  
Dark Beam Attack

Meta:
Light Counter Boss

---

# 5. Growth System Integration

Growth is not card-based.

Character progression includes:

- Divinity Unlock Stage
- Awakening Branch
- Transcendence Tier
- Temple Amplification Bonus
- Relic Equip Slot

---

# 6. Integration Requirements

Each character must:

- Support Element Damage Engine
- Support Status Effect System
- Support Temple Multiplier
- Support PvP Balance Coefficient

# Character Master Definition
Project: game_defence
Theme: Temple Defense – Gods Protecting the Sanctuary
Version: 2.0 (Full Definition – 18 Characters)

---

# 1. Angel Faction

---

## 1. MICHAEL – Archblade of Judgment

Primary: LIGHT  
Secondary: FIRE  
Role: Burst DPS  

Base Stat Profile:
High Attack / Medium HP / Medium Speed / High Crit  

Passive:
Light Damage +15%

Trait:
Deals 25% additional damage to DARK enemies

Skill:
Judgment Blade  
AoE Light + Fire damage  
Reduces DARK resistance by 20% (5s)

Meta:
Primary Dark Counter / Boss Burst Specialist

---

## 2. RAPHAEL – Guardian of Restoration

Primary: LIGHT  
Secondary: WATER  
Role: Healer / Sustain  

Base Stat Profile:
High HP / Low Attack / Medium Speed  

Passive:
Healing Effect +20%

Trait:
When HP < 30%, generates shield (10% max HP)

Skill:
Divine Purification  
Heals all allies and removes debuffs

Meta:
Sustain Anchor / PvP Long Fight Core

---

## 3. URIEL – Thunder Executor

Primary: LIGHT  
Secondary: ELECTRIC  
Role: Crowd Control DPS  

Base Stat Profile:
Medium HP / Medium Attack / High Speed  

Passive:
Stun Chance +10%

Trait:
Stunned enemies receive +30% damage

Skill:
Heavenly Thunder  
AoE Electric damage + 1.5s stun

Meta:
Wave Control / PvP Lockdown

---

## 4. GABRIEL – Herald of Silence

Primary: LIGHT  
Secondary: WATER  
Role: Debuffer  

Base Stat Profile:
Medium HP / Medium Attack  

Passive:
Debuff duration on self -30%

Trait:
Wave start: Enemy attack -10% (5s)

Skill:
Final Trumpet  
AoE Silence (2s)

Meta:
Buff Counter / Control Support

---

## 5. METATRON – Keeper of Records

Primary: LIGHT  
Secondary: ELECTRIC  
Role: Cooldown Manipulator  

Base Stat Profile:
Medium HP / Medium Attack / High Utility  

Passive:
Skill Cooldown -15%

Trait:
10% chance to reset skill cooldown

Skill:
Heavenly Record  
Reduces ally skill cooldown by 20%

Meta:
Combo Engine / Skill Spam Meta

---

## 6. SERAPHIM – Flame of Purification

Primary: FIRE  
Secondary: LIGHT  
Role: Burn DPS  

Base Stat Profile:
High Attack / Low HP  

Passive:
Burn Stack +2

Trait:
Burned enemies take +20% damage

Skill:
Purifying Flame  
Applies stacking Burn

Meta:
Boss Damage Over Time

---

# 2. Demon Faction

---

## 7. LUCIFER – Fallen Sovereign

Primary: DARK  
Secondary: FIRE  
Role: Risk Burst  

Base Stat Profile:
Very High Attack / Low HP  

Passive:
Below 50% HP → Attack +30%

Trait:
Crit restores 5% HP

Skill:
Fallen Radiance  
Massive Dark AoE Explosion

Meta:
Comeback Carry / High Risk Reward

---

## 8. ASMODEUS – Plague Monarch

Primary: DARK  
Secondary: NATURE  
Role: Poison DPS  

Base Stat Profile:
Medium Attack / Medium HP  

Passive:
Poison Damage +30%

Trait:
Poison spreads on kill

Skill:
Corruption Seed  
Applies heavy Poison + Defense Down

Meta:
Anti-Heal / Sustain Counter

---

## 9. BAAL – Storm Tyrant

Primary: ELECTRIC  
Secondary: DARK  
Role: AoE Burst  

Base Stat Profile:
High Attack / Medium HP  

Passive:
Electric Damage +20%

Trait:
Bonus damage vs Stunned

Skill:
Infernal Storm  
Chain Lightning (Multi-target)

Meta:
Wave Clear Specialist

---

## 10. LEVIATHAN – Abyss Leviathan

Primary: WATER  
Secondary: DARK  
Role: Tank Breaker  

Base Stat Profile:
High HP / Medium Attack  

Passive:
Ignores 20% Defense

Trait:
Bonus vs Shielded enemies

Skill:
Abyssal Wave  
Destroys shields

Meta:
Anti-Tank / Shield Counter

---

## 11. BEELZEBUB – Lord of Decay

Primary: NATURE  
Secondary: DARK  
Role: Infection / Heal Reduction  

Base Stat Profile:
Medium HP / Medium Attack  

Passive:
Healing Reduction 40%

Trait:
Poison duration +3s

Skill:
Swarm Plague  
Spreads Infection

Meta:
Healer Shutdown Core

---

## 12. ABADDON – Abyss Executioner

Primary: DARK  
Secondary: ELECTRIC  
Role: Execution  

Base Stat Profile:
High Attack / Medium HP  

Passive:
Deals +30% to enemies below 30% HP

Trait:
Kill triggers explosion

Skill:
Abyss Storm  
Dark AoE + Execute scaling

Meta:
End-Wave Finisher

---

# 3. Ancient / Special

---

## 13. ENOCH – Eternal Ascendant

Primary: LIGHT  
Secondary: NATURE  
Role: Scaling DPS  

Passive:
Damage increases every 10 seconds

Skill:
Ascension Pulse  
Scaling Light Beam

Meta:
Long Duration Growth

---

## 14. SAMAEL – Death Arbiter

Primary: DARK  
Secondary: NATURE  
Role: Execute Specialist  

Passive:
Instant kill below 20% HP (Chance-based)

Skill:
Death Sentence  
High Single Target Burst

Meta:
Boss Finisher

---

## 15. LILITH – Queen of Chaos

Primary: DARK  
Secondary: FIRE  
Role: Debuff Chaos  

Passive:
Damage +10% per debuff on target

Skill:
Queen’s Curse  
Applies random debuffs

Meta:
PvP Disruption

---

## 16. AZAZEL – Lightning Apostle

Primary: ELECTRIC  
Secondary: DARK  
Role: Crit Combo DPS  

Passive:
Crit triggers lightning strike

Skill:
Divine Fragment  
Multi-hit burst combo

Meta:
High Skill Combo

---

## 17. GAIA – Earth Mother

Primary: NATURE  
Secondary: WATER  
Role: Sustain Defender  

Passive:
HP Regen 2% per second

Skill:
Heart of Earth  
Creates protective field

Meta:
Defense Anchor

---

## 18. APOPHIS – Devourer of Light

Primary: DARK  
Secondary: WATER  
Role: Resistance Breaker  

Passive:
Reduces Light resistance by 25%

Skill:
Devour the Sun  
Dark Beam + Resistance Break

Meta:
Light Counter Boss


{
  "version": "1.0",
  "characters": [

    {
      "id": "MICHAEL",
      "name": "Michael",
      "faction": "ANGEL",
      "element": { "primary": "LIGHT", "secondary": "FIRE" },
      "role": "BURST_DPS",
      "baseStats": {
        "hp": 1200, "attack": 180, "attackSpeed": 1.2,
        "critChance": 0.15, "critDamage": 1.5,
        "defense": 80, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Radiant Blade", "description": "Light damage +15%" },
      "trait": { "name": "Dark Slayer", "description": "Deal 25% bonus damage to DARK enemies" },
      "skill": {
        "name": "Judgment Blade",
        "element": "LIGHT",
        "cooldown": 8,
        "description": "AoE Light + Fire damage, reduces DARK resistance"
      }
    },

    {
      "id": "RAPHAEL",
      "name": "Raphael",
      "faction": "ANGEL",
      "element": { "primary": "LIGHT", "secondary": "WATER" },
      "role": "HEALER",
      "baseStats": {
        "hp": 1500, "attack": 90, "attackSpeed": 1.0,
        "critChance": 0.05, "critDamage": 1.3,
        "defense": 100, "cooldownReduction": 0.1, "movementSpeed": 0.9
      },
      "passive": { "name": "Holy Grace", "description": "Healing effect +20%" },
      "trait": { "name": "Guardian Shield", "description": "Generate shield below 30% HP" },
      "skill": {
        "name": "Divine Purification",
        "element": "LIGHT",
        "cooldown": 10,
        "description": "Heal all allies and cleanse debuffs"
      }
    },

    {
      "id": "URIEL",
      "name": "Uriel",
      "faction": "ANGEL",
      "element": { "primary": "LIGHT", "secondary": "ELECTRIC" },
      "role": "CONTROL_DPS",
      "baseStats": {
        "hp": 1100, "attack": 140, "attackSpeed": 1.4,
        "critChance": 0.12, "critDamage": 1.5,
        "defense": 70, "cooldownReduction": 0.05, "movementSpeed": 1.1
      },
      "passive": { "name": "Thunder Will", "description": "Increase stun chance" },
      "trait": { "name": "Execution Shock", "description": "Deal bonus damage to stunned enemies" },
      "skill": {
        "name": "Heavenly Thunder",
        "element": "ELECTRIC",
        "cooldown": 7,
        "description": "AoE Electric damage and stun"
      }
    },

    {
      "id": "GABRIEL",
      "name": "Gabriel",
      "faction": "ANGEL",
      "element": { "primary": "LIGHT", "secondary": "WATER" },
      "role": "DEBUFFER",
      "baseStats": {
        "hp": 1150, "attack": 130, "attackSpeed": 1.1,
        "critChance": 0.1, "critDamage": 1.4,
        "defense": 75, "cooldownReduction": 0.05, "movementSpeed": 1.0
      },
      "passive": { "name": "Sacred Calm", "description": "Debuff duration on self -30%" },
      "trait": { "name": "Divine Weakening", "description": "Reduce enemy attack at wave start" },
      "skill": {
        "name": "Final Trumpet",
        "element": "LIGHT",
        "cooldown": 9,
        "description": "AoE silence and damage"
      }
    },

    {
      "id": "METATRON",
      "name": "Metatron",
      "faction": "ANGEL",
      "element": { "primary": "LIGHT", "secondary": "ELECTRIC" },
      "role": "UTILITY",
      "baseStats": {
        "hp": 1100, "attack": 120, "attackSpeed": 1.2,
        "critChance": 0.1, "critDamage": 1.4,
        "defense": 70, "cooldownReduction": 0.15, "movementSpeed": 1.0
      },
      "passive": { "name": "Chronicle", "description": "Cooldown -15%" },
      "trait": { "name": "Skill Echo", "description": "Chance to reset skill cooldown" },
      "skill": {
        "name": "Heavenly Record",
        "element": "LIGHT",
        "cooldown": 12,
        "description": "Reduce team skill cooldown"
      }
    },

    {
      "id": "SERAPHIM",
      "name": "Seraphim",
      "faction": "ANGEL",
      "element": { "primary": "FIRE", "secondary": "LIGHT" },
      "role": "DOT_DPS",
      "baseStats": {
        "hp": 1000, "attack": 170, "attackSpeed": 1.3,
        "critChance": 0.1, "critDamage": 1.5,
        "defense": 60, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Sacred Flame", "description": "Burn stack +2" },
      "trait": { "name": "Flame Amplify", "description": "Burned enemies take extra damage" },
      "skill": {
        "name": "Purifying Flame",
        "element": "FIRE",
        "cooldown": 8,
        "description": "Applies stacking burn"
      }
    },

    {
      "id": "LUCIFER",
      "name": "Lucifer",
      "faction": "DEMON",
      "element": { "primary": "DARK", "secondary": "FIRE" },
      "role": "RISK_DPS",
      "baseStats": {
        "hp": 950, "attack": 210, "attackSpeed": 1.3,
        "critChance": 0.2, "critDamage": 1.7,
        "defense": 50, "cooldownReduction": 0.0, "movementSpeed": 1.1
      },
      "passive": { "name": "Fallen Power", "description": "Low HP increases attack" },
      "trait": { "name": "Blood Pact", "description": "Crit restores HP" },
      "skill": {
        "name": "Fallen Radiance",
        "element": "DARK",
        "cooldown": 9,
        "description": "Massive Dark AoE"
      }
    },

    {
      "id": "ASMODEUS",
      "name": "Asmodeus",
      "faction": "DEMON",
      "element": { "primary": "DARK", "secondary": "NATURE" },
      "role": "POISON_DPS",
      "baseStats": {
        "hp": 1100, "attack": 150, "attackSpeed": 1.2,
        "critChance": 0.1, "critDamage": 1.4,
        "defense": 70, "cooldownReduction": 0.05, "movementSpeed": 1.0
      },
      "passive": { "name": "Plague Master", "description": "Poison damage +30%" },
      "trait": { "name": "Toxic Spread", "description": "Poison spreads on kill" },
      "skill": {
        "name": "Corruption Seed",
        "element": "NATURE",
        "cooldown": 8,
        "description": "Applies poison and defense down"
      }
    },

    {
      "id": "BAAL",
      "name": "Baal",
      "faction": "DEMON",
      "element": { "primary": "ELECTRIC", "secondary": "DARK" },
      "role": "AOE_DPS",
      "baseStats": {
        "hp": 1150, "attack": 170, "attackSpeed": 1.2,
        "critChance": 0.12, "critDamage": 1.5,
        "defense": 80, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Storm Authority", "description": "Electric damage +20%" },
      "trait": { "name": "Shock Amplify", "description": "Bonus vs stunned enemies" },
      "skill": {
        "name": "Infernal Storm",
        "element": "ELECTRIC",
        "cooldown": 7,
        "description": "Chain lightning AoE"
      }
    },

    {
      "id": "LEVIATHAN",
      "name": "Leviathan",
      "faction": "DEMON",
      "element": { "primary": "WATER", "secondary": "DARK" },
      "role": "TANK_BREAKER",
      "baseStats": {
        "hp": 1600, "attack": 130, "attackSpeed": 1.0,
        "critChance": 0.05, "critDamage": 1.3,
        "defense": 120, "cooldownReduction": 0.0, "movementSpeed": 0.8
      },
      "passive": { "name": "Abyss Pressure", "description": "Ignores defense" },
      "trait": { "name": "Shield Devour", "description": "Bonus vs shielded enemies" },
      "skill": {
        "name": "Abyssal Wave",
        "element": "WATER",
        "cooldown": 10,
        "description": "Destroys shields"
      }
    },

    {
      "id": "BEELZEBUB",
      "name": "Beelzebub",
      "faction": "DEMON",
      "element": { "primary": "NATURE", "secondary": "DARK" },
      "role": "ANTI_HEAL",
      "baseStats": {
        "hp": 1200, "attack": 140, "attackSpeed": 1.1,
        "critChance": 0.08, "critDamage": 1.4,
        "defense": 85, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Decay Aura", "description": "Healing reduction 40%" },
      "trait": { "name": "Infection Boost", "description": "Poison duration increased" },
      "skill": {
        "name": "Swarm Plague",
        "element": "NATURE",
        "cooldown": 9,
        "description": "Spreads infection"
      }
    },

    {
      "id": "ABADDON",
      "name": "Abaddon",
      "faction": "DEMON",
      "element": { "primary": "DARK", "secondary": "ELECTRIC" },
      "role": "EXECUTIONER",
      "baseStats": {
        "hp": 1100, "attack": 190, "attackSpeed": 1.2,
        "critChance": 0.15, "critDamage": 1.6,
        "defense": 70, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Final Judgment", "description": "Bonus vs low HP enemies" },
      "trait": { "name": "Death Explosion", "description": "Kill triggers explosion" },
      "skill": {
        "name": "Abyss Storm",
        "element": "DARK",
        "cooldown": 8,
        "description": "Dark AoE with execute scaling"
      }
    },

    {
      "id": "ENOCH",
      "name": "Enoch",
      "faction": "ANCIENT",
      "element": { "primary": "LIGHT", "secondary": "NATURE" },
      "role": "SCALING_DPS",
      "baseStats": {
        "hp": 1200, "attack": 140, "attackSpeed": 1.1,
        "critChance": 0.1, "critDamage": 1.4,
        "defense": 80, "cooldownReduction": 0.05, "movementSpeed": 1.0
      },
      "passive": { "name": "Eternal Growth", "description": "Damage increases over time" },
      "trait": { "name": "Ascendant Force", "description": "Scaling bonus per wave" },
      "skill": {
        "name": "Ascension Pulse",
        "element": "LIGHT",
        "cooldown": 9,
        "description": "Scaling Light beam"
      }
    },

    {
      "id": "SAMAEL",
      "name": "Samael",
      "faction": "ANCIENT",
      "element": { "primary": "DARK", "secondary": "NATURE" },
      "role": "EXECUTE_SPECIALIST",
      "baseStats": {
        "hp": 1000, "attack": 200, "attackSpeed": 1.3,
        "critChance": 0.18, "critDamage": 1.6,
        "defense": 60, "cooldownReduction": 0.0, "movementSpeed": 1.1
      },
      "passive": { "name": "Death Mark", "description": "Execute below threshold" },
      "trait": { "name": "Fatal Precision", "description": "Bonus single-target damage" },
      "skill": {
        "name": "Death Sentence",
        "element": "DARK",
        "cooldown": 8,
        "description": "High burst single-target"
      }
    },

    {
      "id": "LILITH",
      "name": "Lilith",
      "faction": "ANCIENT",
      "element": { "primary": "DARK", "secondary": "FIRE" },
      "role": "DEBUFF_DPS",
      "baseStats": {
        "hp": 1050, "attack": 160, "attackSpeed": 1.2,
        "critChance": 0.12, "critDamage": 1.5,
        "defense": 65, "cooldownReduction": 0.05, "movementSpeed": 1.0
      },
      "passive": { "name": "Chaos Aura", "description": "Damage increases per debuff" },
      "trait": { "name": "Dark Seduction", "description": "Random debuff application" },
      "skill": {
        "name": "Queen of Chaos",
        "element": "DARK",
        "cooldown": 9,
        "description": "Applies multiple debuffs"
      }
    },

    {
      "id": "AZAZEL",
      "name": "Azazel",
      "faction": "ANCIENT",
      "element": { "primary": "ELECTRIC", "secondary": "DARK" },
      "role": "CRIT_COMBO",
      "baseStats": {
        "hp": 1000, "attack": 185, "attackSpeed": 1.4,
        "critChance": 0.2, "critDamage": 1.7,
        "defense": 55, "cooldownReduction": 0.0, "movementSpeed": 1.1
      },
      "passive": { "name": "Lightning Reflex", "description": "Crit triggers lightning strike" },
      "trait": { "name": "Combo Drive", "description": "Increased multi-hit damage" },
      "skill": {
        "name": "Divine Fragment",
        "element": "ELECTRIC",
        "cooldown": 6,
        "description": "Multi-hit electric burst"
      }
    },

    {
      "id": "GAIA",
      "name": "Gaia",
      "faction": "ANCIENT",
      "element": { "primary": "NATURE", "secondary": "WATER" },
      "role": "DEFENDER",
      "baseStats": {
        "hp": 1700, "attack": 110, "attackSpeed": 1.0,
        "critChance": 0.05, "critDamage": 1.3,
        "defense": 130, "cooldownReduction": 0.0, "movementSpeed": 0.8
      },
      "passive": { "name": "Earth Regen", "description": "HP regen over time" },
      "trait": { "name": "Nature Shield", "description": "Periodic shield generation" },
      "skill": {
        "name": "Heart of Earth",
        "element": "NATURE",
        "cooldown": 12,
        "description": "Creates protective field"
      }
    },

    {
      "id": "APOPHIS",
      "name": "Apophis",
      "faction": "ANCIENT",
      "element": { "primary": "DARK", "secondary": "WATER" },
      "role": "RESIST_BREAKER",
      "baseStats": {
        "hp": 1300, "attack": 175, "attackSpeed": 1.1,
        "critChance": 0.12, "critDamage": 1.5,
        "defense": 85, "cooldownReduction": 0.0, "movementSpeed": 1.0
      },
      "passive": { "name": "Light Devourer", "description": "Reduce Light resistance" },
      "trait": { "name": "Dark Pressure", "description": "Dark damage amplification" },
      "skill": {
        "name": "Devour the Sun",
        "element": "DARK",
        "cooldown": 9,
        "description": "Dark beam with resistance break"
      }
    }

  ]
}