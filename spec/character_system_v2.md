# Character System Specification v2
Version: 2.0 (Updated 2026-03-08)
Theme: Temple Defense – Gods Protecting the Sanctuary

---

# 1. Core Concept

본 게임은 **신들이 신전을 지키는 디펜스 게임**이다. 캐릭터는 고유한 속성과 진영을 가지며, 플레이어의 성장 전략에 따라 압도적인 힘을 발휘한다.

---

# 2. Element System (속성 시스템)

## 2.1 Element Types
- FIRE, WATER, NATURE, ELECTRIC, LIGHT, DARK, ICE (WATER 상위), NONE

## 2.2 Element Multiplier
| 관계 | 배율 | 설명 |
|------|------|------|
| Strong | 1.3x | 유리한 상성 공격 시 피해 증가 |
| Weak | 0.75x | 불리한 상성 공격 시 피해 감소 |
| Neutral | 1.0x | 일반적인 피해 |

### 상성 구조
- FIRE > NATURE, ICE
- NATURE > WATER
- WATER > FIRE
- ELECTRIC > WATER
- LIGHT ↔ DARK (상호 카운터)

---

# 3. Growth System (성장 및 승급)

## 3.1 카드 기반 레벨업
캐릭터의 성장은 "캐릭터 전용 카드"와 "골드"를 소모하여 이루어진다.
- **레벨업 비용**: 캐릭터 카드 **12장** 고정 + **(현재 레벨 * 5,000) Gold**.
- **공격력 성장**: 레벨당 **8% 복리(Compounded)** 증가.
- **HP 성장**: 레벨당 **10% 선형(Linear)** 증가.

## 3.2 랭크 및 승급 (12단계 시스템)
각 랭크는 12단계의 레벨로 구성되며, 12단계를 모두 채우면 다음 랭크로 승급한다.
- **랭크 순서**: Silver → Gold → Platinum → Diamond
- **시작 레벨**: Silver(1), Gold(13), Platinum(25), Diamond(37)
- **승급 효과**: 랭크가 오를 때마다 기본 스탯이 대폭 상승하며, 타일 테두리의 아우라(Glow)가 화려해진다.

---

# 4. Factions & Characters (진영 및 캐릭터)

## 4.1 Angel Faction (천사) - 빛의 중앙청 보너스
- **MICHAEL**: 빛/불, Burst DPS. 스킬: Judgment Blade.
- **RAPHAEL**: 빛/물, Healer. 스킬: Divine Sanctuary.
- **URIEL**: 빛/번개, Control. 스킬: Heavenly Thunder.
- **GABRIEL**: 빛/물, Debuffer. 스킬: Final Trumpet.
- **METATRON**: 빛/번개, Utility. 스킬: Chrono Archive.
- **SERAPHIM**: 불/빛, DOT DPS. 스킬: Sacred Inferno.

## 4.2 Demon Faction (악마) - 흑암의 바벨 보너스
- **LUCIFER**: 어둠/불, Risk DPS. 스킬: Fallen Cataclysm.
- **ASMODEUS**: 어둠/자연, Poison. 스킬: Corruption Bloom.
- **BAAL**: 번개/어둠, AoE Burst. 스킬: Thunder Dominion.
- **LEVIATHAN**: 물/어둠, Breaker. 스킬: Abyss Collapse.
- **BEELZEBUB**: 자연/어둠, Anti-Heal. 스킬: Plague Swarm.
- **ABADDON**: 어둠/번개, Executioner. 스킬: Abyss Execution.

## 4.3 Ancient Faction (고대) - 불가사의 고대신전 보너스
- **ENOCH**: 빛/자연, Scaling DPS. 스킬: Ascension Protocol.
- **SAMAEL**: 어둠/자연, Execute. 스킬: Death Mark.
- **LILITH**: 어둠/불, Chaos Debuff. 스킬: Queen's Temptation.
- **AZAZEL**: 번개/어둠, Combo Burst. 스킬: Fallen Lightning Rush.
- **GAIA**: 자연/물, Defender. 스킬: Earth Mother Embrace.
- **APOPHIS**: 어둠/물, Resist Breaker. 스킬: Solar Devourer.

---

# 5. Temple Integration (신전 연동)

각 캐릭터는 자신이 속한 진영과 일치하는 신전이 활성화되었을 때 **공격력 보너스(BONUS)**를 받는다.
- 신전 레벨에 따라 보너스 수치가 증가하며, 캐릭터 페이지에서 시각적으로 표시된다.
