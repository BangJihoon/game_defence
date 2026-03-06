

# 📄 1️⃣ status_effect_system.md

````markdown
# Status Effect System Design

## 1. 목표

- 18개 캐릭터 스킬 전부 지원
- PvE / PvP 공통 사용
- 속성 상성 반영
- 중첩 / 갱신 / 면역 관리 가능
- 성능 최적화 고려

---

## 2. 상태이상 분류

1. 제어형 (Control)
2. 지속피해형 (DOT)
3. 약화형 (Debuff)
4. 강화형 (Buff)


### 2.1 Control (제어형)

| 타입 | 설명 |
|------|------|
| stun | 행동 불가 |
| silence | 스킬 사용 불가 |
| freeze | 행동 불가 + 받는 피해 증가 |
| fear | 후퇴 이동 |
| knockup | 일정 시간 공중 띄움 |

---

### 2.2 DOT (지속 피해)

| 타입 | 설명 |
|------|------|
| burn | 화상, 중첩 가능 |
| poison | 지속 독 피해 |
| shock | 감전, 추가타 트리거 |
| bleed | 방어 무시 피해 |
| corruption | 어둠 침식 |

---

### 2.3 Debuff (약화)

| 타입 | 설명 |
|------|------|
| defenseDown | 방어 감소 |
| attackDown | 공격 감소 |
| speedDown | 이동속도 감소 |
| resistanceDown | 속성 저항 감소 |
| healingReduction | 회복 감소 |

---

### 2.4 Buff (강화)

| 타입 | 설명 |
|------|------|
| shield | 보호막 |
| attackUp | 공격 증가 |
| defenseUp | 방어 증가 |
| regeneration | 체력 재생 |
| cooldownReduction | 쿨 감소 |

---

## 3. 데이터 구조

```dart
class StatusEffect {
  final StatusEffectType type;
  final double duration;
  final double value;
  final int maxStack;
  final bool isStackable;
  final bool refreshOnReapply;
  final ElementType element;

  double remainingTime;
  int currentStack;
}
class StatusEffect {
  final StatusEffectType type;
  final double duration;
  final double value; // 피해량 또는 % 감소율
  final int maxStack;
  final bool isStackable;
  final bool refreshOnReapply;
  final ElementType element;

  double remainingTime;
  int currentStack;

````
enum StatusEffectType {
  // Control
  stun,
  silence,
  freeze,
  fear,
  knockup,

  // DOT
  burn,
  poison,
  shock,
  bleed,
  corruption,

  // Debuff
  defenseDown,
  attackDown,
  speedDown,
  resistanceDown,
  healingReduction,

  // Buff
  shield,
  attackUp,
  defenseUp,
  regeneration,
  cooldownReduction,
}

---

## 4. 중첩 정책

* 동일 타입 중첩 시:

  * stackable = true → 스택 증가
  * refreshOnReapply = true → 지속시간 갱신
* 최대 상태이상 10개 제한

---

## 5. Tick 처리

* 매 프레임 감소
* DOT는 delta 기반 피해 적용
* 0초 도달 시 제거

---

## 6. 면역 / 정화

* 상태이상 면역 플래그 가능
* 특정 타입만 해제 가능
* 정화 스킬은 Debuff 우선 제거

---

## 7. 18 캐릭터 적용 예시

| 캐릭터       | 상태이상             |
| --------- | ---------------- |
| Michael   | defenseDown      |
| Raphael   | shield           |
| Uriel     | stun             |
| Seraphim  | burn             |
| Lucifer   | lifesteal        |
| Asmodeus  | poison           |
| Baal      | shock            |
| Leviathan | speedDown        |
| Beelzebub | healingReduction |
| Abaddon   | execute          |
| Enoch     | attackUp         |
| Samael    | mark             |
| Lilith    | randomDebuff     |
| Azazel    | critAmp          |
| Gaia      | regeneration     |
| Apophis   | resistanceDown   |

중복 없음.

````

---

# 📄 2️⃣ element_system.md

```markdown
# Element System Design

## 1. 목표

- 6속성 상성 구조
- 공격 / 상태이상 모두 적용
- PvE / PvP 동일 계산식
- 확장 가능 구조

---

## 2. 속성 정의

| 속성 |
|------|
| FIRE |
| WATER |
| NATURE |
| ELECTRIC |
| LIGHT |
| DARK |

---

## 3. 기본 상성

| 공격 ↓ / 방어 → | FIRE | WATER | NATURE | ELECTRIC | LIGHT | DARK |
|-----------------|------|-------|--------|----------|-------|------|
| FIRE            | 1.0  | 0.8   | 1.2    | 1.0      | 1.0   | 1.0  |
| WATER           | 1.2  | 1.0   | 0.8    | 1.0      | 1.0   | 1.0  |
| NATURE          | 0.8  | 1.2   | 1.0    | 1.0      | 1.0   | 1.0  |
| ELECTRIC        | 1.0  | 1.2   | 1.0    | 1.0      | 1.0   | 1.0  |
| LIGHT           | 1.0  | 1.0   | 1.0    | 1.0      | 1.0   | 1.3  |
| DARK            | 1.0  | 1.0   | 1.0    | 1.0      | 1.3   | 1.0  |

---

## 4. 계산식

````

finalDamage = baseDamage * elementMultiplier

````

---

## 5. 상태이상 상성 적용

- burn → FIRE 영향 받음
- poison → NATURE 영향 받음
- shock → ELECTRIC 영향 받음
- corruption → DARK 영향 받음
- freeze → WATER 영향 받음

---

## 6. 확장 대비

향후 추가 가능:

- 듀얼 속성 캐릭터
- 속성 저항 스탯
- 속성 관통
- 속성 증폭 버프
- 속성 면역 보스

---

## 7. 예시 코드

```dart
double getMultiplier(ElementType attacker, ElementType defender) {
  return elementTable[attacker]?[defender] ?? 1.0;
}
````

---

## 8. 밸런스 기준

* 1.2 = 유리
* 0.8 = 불리
* 1.3 = 상극 (LIGHT vs DARK)

