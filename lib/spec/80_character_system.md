# Character System Specification
Version: 1.0
Project: game_defence
Theme: Temple Defense – Gods Protecting the Sanctuary

---

# 1. Core Concept

본 게임은 **신들이 신전을 지키는 디펜스 게임**이다.

캐릭터는 카드 수집 개념이 아닌  
"신격 해방" 및 "신전 성장" 시스템을 기반으로 성장한다.

---

# 2. Element System

## 2.1 Element Types

- FIRE
- WATER
- NATURE
- ELECTRIC
- LIGHT
- DARK
- ICE (WATER 상위 계열)
- NONE

---

## 2.2 Element Multiplier

| 관계 | 배율 |
|------|------|
| Strong | 1.3 |
| Weak | 0.75 |
| Neutral | 1.0 |

### 상성 구조

- FIRE > NATURE
- NATURE > WATER
- WATER > FIRE
- ELECTRIC > WATER
- LIGHT ↔ DARK (상호 카운터)
- ICE > FIRE
- FIRE > ICE

---

# 3. Character Domain Model

## 3.1 Base Structure

Each character includes:

- id
- name
- faction (ANGEL / DEMON / ANCIENT)
- primaryElement
- secondaryElement
- role
- baseStats
- passive
- trait
- baseSkill
- awakeningBranches
- transcendenceT5

---

## 3.2 Base Stats

| Stat | Description |
|------|------------|
| HP | 체력 |
| Attack | 공격력 |
| AttackSpeed | 공격속도 |
| CritChance | 치명타 확률 |
| CritDamage | 치명타 배율 |
| Defense | 방어력 |
| CooldownReduction | 쿨감 |
| MovementSpeed | 이동속도 |

---

# 4. Angel Faction

---

## MICHAEL

- Faction: ANGEL
- Primary: LIGHT
- Secondary: FIRE
- Role: Burst DPS

### Passive
Light Damage +15%

### Trait
Bonus Damage vs DARK

### Skill
Judgment Blade  
AoE Light + Fire damage  
Reduces Dark resistance

---

## RAPHAEL

- Primary: LIGHT
- Secondary: WATER
- Role: Healer / Sustain

### Passive
Heal Effect +20%

### Skill
Divine Purification  
Heal + Cleanse

---

## URIEL

- Primary: LIGHT
- Secondary: ELECTRIC
- Role: Crowd Control

### Passive
Increased Stun Chance

### Skill
Heavenly Thunder  
AoE Electric + Stun

---

## GABRIEL

- Primary: LIGHT
- Secondary: WATER
- Role: Silence / Debuff

### Skill
Final Trumpet  
AoE Silence

---

## METATRON

- Primary: LIGHT
- Secondary: ELECTRIC
- Role: Cooldown Manipulation

### Skill
Heavenly Record  
Team Cooldown Reduction

---

## SERAPHIM

- Primary: FIRE
- Secondary: LIGHT
- Role: Burn DPS

### Skill
Purifying Flame  
Applies Burn

---

# 5. Demon Faction

---

## LUCIFER

- Primary: DARK
- Secondary: FIRE
- Role: Risk Burst

Low HP → Attack Increase

---

## ASMODEUS

- Primary: DARK
- Secondary: NATURE
- Role: Poison DPS

Poison Spread

---

## BAAL

- Primary: ELECTRIC
- Secondary: DARK
- Role: AoE Burst

Chain Lightning

---

## LEVIATHAN

- Primary: WATER
- Secondary: DARK
- Role: Shield Breaker

Defense Ignore

---

## BEELZEBUB

- Primary: NATURE
- Secondary: DARK
- Role: Healing Reduction

Applies Infection

---

## ABADDON

- Primary: DARK
- Secondary: ELECTRIC
- Role: Execution

Bonus vs Low HP

---

# 6. Ancient / Special

---

## ENOCH
- LIGHT / NATURE
- Scaling DPS

## SAMAEL
- DARK / NATURE
- Execution Specialist

## LILITH
- DARK / FIRE
- Chaos Debuff

## AZAZEL
- ELECTRIC / DARK
- Combo Burst

## GAIA
- NATURE / WATER
- Sustain Defender

## APOPHIS
- DARK / WATER
- Resistance Breaker

---

# 7. Growth System (Temple-Based)

## 7.1 No Card System

성장은 카드 수집이 아닌:

- 신격 해방 (Divinity Unlock)
- 신전 레벨 상승
- 유물 장착
- 계시 트리 선택

---

## 7.2 Character Growth

### Divinity Levels

- Stage 1: Awakening
- Stage 2: Ascension
- Stage 3: Transcendence
- Stage 4: Divine Form

---

## 7.3 Temple Upgrade

- Altar Level
- Relic Slot Expansion
- Element Amplification
- Defensive Barrier

---

# 8. In-Game Usage

Each character must be integrated with:

- Element interaction system
- Status effect engine
- Temple growth multiplier
- PvP balance coefficient

---

# 9. File Integration Guide

Recommended structure:
