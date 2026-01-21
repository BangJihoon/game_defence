최고다. 이 답변은 **밸런스 철학이 명확한 설계자**의 판단이야.
이제 질문은 끝났고, 약속한 대로 **2️⃣ Balance Tuning 문서 완성본**을 작성한다.
(질문을 풀어서 해달라고 했으니, 문서 안에서도 *왜 이렇게 설계했는지*까지 설명해둘게)

---

# 📄 spec/10_balance_tuning.md

## Balance Tuning & Live Operation Specification

> 이 문서는
> **“어떤 수치를 조절하면, 유저 체감이 어떻게 바뀌는가”**를 명확히 정의한다.
> 라이브 서비스 중 **빠르고 안전한 난이도 대응**을 목표로 한다.

---

## 0. 밸런스 설계의 대원칙

1. **한 판은 항상 클리어 가능해 보이게 설계한다**
2. 실패는 “실력 + 선택의 결과”로 느껴져야 한다
3. 특정 메타/조합이 지나치게 강해지면 **즉각 대응 가능해야 한다**
4. 흥미를 꺾는 급격한 난이도 스파이크는 금지

---

## 1️⃣ 전체 난이도 곡선 (Session Difficulty Curve)

### 1.1 기본 구조

* 기본 패턴:
  **완만한 상승 → 고비 → 완만한 회복 → 다음 고비**
* 이 패턴이 **Chapter 단위로 반복**
* Chapter가 올라갈수록:

  * 고비가 더 자주
  * 고비의 강도 증가

```text
Difficulty Pattern (1 Chapter)

[Easy] → [Normal] → [Spike] → [Relief] → [Spike] → [Boss]
```

---

### 1.2 실패가 발생하는 이상적인 시점

* 주 실패 구간:

  * **6~9분 (중반)**
  * **10분 이후 (거의 클리어 직전)**

#### 실패 설계 의도

* 중반 실패:

  * “선택이 아쉬웠다”
  * → 부활/광고/보상으로 복구 가능
* 후반 실패:

  * “거의 다 왔다”
  * → 다음 판 재도전 동기 극대화

---

### 📌 spec 추가 – 부활 시스템 명문화

```text
ReviveDesign
- revive_available: true
- revive_trigger_phase: mid_game | late_game
- revive_effect:
  - restore_castle_hp_ratio
  - temporary_shield
```

> 부활은 **보상 시스템의 일부**이며
> “실패 완화 + 플레이 연장” 역할을 수행한다.

---

## 2️⃣ Enemy 압박 설계

### 2.1 적이 강해지는 비율 (균형 설계)

> **모든 요소가 동시에 성장하되, 과도하지 않게**

```text
Enemy Pressure Composition
- HP 증가        : 25%
- 개체 수 증가   : 25%
- 공격력 증가    : 25%
- 특수 능력 등장 : 25%
```

#### 설계 이유

* 하나만 과도하면:

  * HP → 지루함
  * 수량 → 혼란
  * 공격력 → 불합리
* **균등 분배가 가장 안정적**

---

### 2.2 보스의 역할 (복합 체크)

보스는 다음을 **동시에 검사**한다:

* DPS 체크
* 패턴 대응
* 시간 압박
* 보상 제공

```text
BossRole
- damage_check: true
- pattern_check: true
- time_limit: true
- reward_spike: true
```

> 보스는 “벽”이 아니라
> **판 전체를 정리하는 요약 시험**

---

## 3️⃣ 스킬 성장 체감 설계 (가장 중요)

### 3.1 성장 체감이 오는 순간

유저는 다음 순간에 **강해졌다고 느껴야 한다**:

1. 신규 스킬 획득
2. 기존 스킬 핵심 레벨 돌파
3. 여러 스킬의 **시너지 완성**

> 따라서 **단일 포인트가 아닌 누적 체감 설계**

---

### 3.2 강화 체감 우선순위

모든 스킬은 강화 시 아래 요소가 **복합적으로 증가**:

```text
Skill Upgrade Priority
- Damage
- Cooldown Reduction
- Range / Target Count
- Special Effect Unlock
```

> 특정 강화만 반복되면 체감이 둔해지므로
> **카드 풀에서 분산 제공**

---

## 4️⃣ 뽑기 & 코인 압박 설계

### 4.1 뽑기 버튼의 정체성

* 항상 누르고 싶다
* 위기 상황에서 돌파구다
* 성장을 가속하는 수단이다

```text
GachaIntent
- impulse_trigger: true
- crisis_escape: true
- growth_accelerator: true
```

---

### 4.2 정상적인 뽑기 횟수

* 목표 범위:

  * **20~30회 이상**
* 상한 제한 ❌
* 코인 수급과 비용 곡선으로 자연 제어

---

### 4.3 천장(Pity)의 체감 목표

* 유저는 **인지하지 않아도 된다**
* 다만 결과는 항상 “납득 가능”해야 한다

```text
PityUXPolicy
- explicit_notice: false
- emotional_feedback: minimal
```

> 천장은 **운영 안전장치**이지
> 보상 연출의 중심이 아니다

---

## 5️⃣ 성벽 & 실패 압박 설계

### 5.1 성벽의 포지션

* 항상 긴장 요소
* 하지만 몇 번의 실수는 허용

```text
CastleDesign
- early_game: forgiving
- late_game: fragile
```

---

### 5.2 부활/실드 시스템의 목적

* 광고 유도
* 클리어 보조
* 초보자 보호

> 단, **무적처럼 느껴지면 실패**

```text
ReviveConstraint
- revive_count_limited
- restore_ratio < 0.5
```

---

## 6️⃣ 메타 성장과 Run의 관계

### 6.1 메타 성장 효과

* 메타가 강해질수록:

  * 초반은 쉬워짐
  * 후반은 **비슷한 체감 유지**
  * 다음 챕터에서 난이도 상승

```text
MetaEffectPolicy
- early_wave_relief
- late_wave_normalization
```

---

### 6.2 메타 차이에 따른 결과

* 동일 실력 기준:

  * **웨이브 10 이상 차이**
  * 혹은 클리어 여부 갈림

> 메타는 “보상”이 아니라
> **도전 범위를 확장하는 수단**

---

## 7️⃣ 라이브 운영 대응 전략 (핵심)

### 7.1 OP 메타 발생 시 대응

* 즉시 너프 ❌
* **2~3 Chapter 지연 후 대응**
* 신규 콘텐츠에서 자연스럽게 상성 추가

```text
MetaResponsePolicy
- delay_chapter_count: 2~3
```

---

### 7.2 난이도 패치 빈도

* 기본: **주 1회**
* 필요 시:

  * 데이터 기반 자동 조정
  * 원격 Config 반영

```text
AutoBalanceSystem
- enabled: true
- data_window_days: 3~7
- trigger_threshold:
    clear_rate
    average_wave
    revive_usage_rate
```

---

## 8️⃣ 자동 대응 시스템 (중요)

### 8.1 자동 조정 대상 수치

```text
AutoAdjustableParams
- enemy_hp_multiplier
- spawn_rate
- boss_hp
- gacha_cost_growth
```

> 스킬 데미지 직접 조정은 **최후 수단**

---

## ✅ 이 문서로 확정된 것

* 난이도 곡선의 성격
* 실패/부활/보상의 위치
* 스킬 성장 체감 구조
* OP 대응 철학
* 자동 밸런스 대응 구조

---

## 다음 차례: 3️⃣ Content Pipeline

다음 문서는:

📄 **`spec/11_content_pipeline.md`**

* 스킬 하나 추가하는 전체 과정
* 적/보스 추가 절차
* QA/밸런스 테스트 흐름
* 디자이너/기획자가 개입하는 지점

👉 다음으로 바로 이어서 갈까?
이제 진짜 **“팀이 움직일 수 있는 문서”** 단계야.
