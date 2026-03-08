# Combat Engine Specification
Version: 1.0 (Consolidated 2026-03-08)

---

# 1. Skill Engine Architecture

전투 엔진은 다음과 같은 책임 분리 구조를 가진다:
- **SkillExecutor**: 스킬의 시전 및 쿨타임 관리.
- **TargetSelector**: 스킬 타입(SINGLE, AREA, CHAIN 등)에 따른 대상 선정.
- **DamageCalculator**: 속성 상성, 방어력, 치명타가 반영된 최종 데미지 계산.
- **StatusApplier**: 상태이상(CC, DOT, Buff/Debuff) 부여 및 중첩 관리.
- **HitFeedbackSystem**: 화면 흔들림(Screen Shake), 역경직(Hit Stop), 데미지 수치 표시.

---

# 2. Damage Calculation (데미지 계산식)

최종 데미지(`finalDamage`)는 다음 공식을 따른다:
```text
finalDamage = (BaseAttack * SkillMultiplier) * ElementMultiplier * CritMultiplier * DefenseReduction
```
- **DefenseReduction**: `1 - (Defense / (Defense + 100))`
- **ElementMultiplier**: 상성에 따라 0.75x ~ 1.3x 적용.

---

# 3. Status Effect System (상태이상)

## 3.1 분류
1. **Control (제어)**: Stun(기절), Silence(침묵), Freeze(빙결), Fear(공포).
2. **DOT (지속 피해)**: Burn(화상), Poison(중독), Shock(감전), Bleed(출혈).
3. **Debuff (약화)**: DefenseDown, AttackDown, SpeedDown, HealingReduction.
4. **Buff (강화)**: Shield(보호막), AttackUp, DefenseUp, CooldownReduction.

## 3.2 중첩 및 갱신
- **Stackable**: 동일 효과 중첩 시 스택 증가 및 효과 증폭.
- **Refresh**: 재부여 시 지속시간 초기화.

---

# 4. Element Interaction (속성 상성)

| 공격 ↓ / 방어 → | FIRE | WATER | NATURE | ELECTRIC | LIGHT | DARK |
|-----------------|------|-------|--------|----------|-------|------|
| FIRE            | 1.0  | 0.8   | 1.2    | 1.0      | 1.0   | 1.0  |
| WATER           | 1.2  | 1.0   | 0.8    | 1.0      | 1.0   | 1.0  |
| NATURE          | 0.8  | 1.2   | 1.0    | 1.0      | 1.0   | 1.0  |
| ELECTRIC        | 1.0  | 1.2   | 1.0    | 1.0      | 1.0   | 1.0  |
| LIGHT           | 1.0  | 1.0   | 1.0    | 1.0      | 1.0   | 1.3  |
| DARK            | 1.0  | 1.0   | 1.0    | 1.0      | 1.3   | 1.0  |

---

# 5. Hit Feedback (타격감 연출)

- **Hit Stop**: 타격 시 0.05~0.08초간 엔진 일시 정지로 묵직한 타격감 부여.
- **Screen Shake**: 강력한 스킬 또는 보스 피격 시 카메라 흔들림 적용.
- **Damage Pop**: 데미지 수치를 띄우며, 크리티컬 시 크기와 색상으로 강조.
- **Attack Animation**: 스킬 발동 시 캐릭터 이미지를 `attack.png`로 0.5초간 변경 및 화이트 플래시 효과.
