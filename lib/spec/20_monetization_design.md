
---

# 📄 spec/12_monetization_design.md

## Monetization, Ads & Ethical Design Specification

> 이 문서는
> **과금·광고·랭킹·수집 요소가 게임 밸런스를 해치지 않으면서도
> 장기 운영과 글로벌 서비스를 가능하게 하는 설계 기준**을 정의한다.
(이 문서는 **BM·윤리·운영·랭킹 신뢰성**까지 동시에 커버한다)
---

## 0. 과금 설계의 철학 (Core Philosophy)

### 핵심 원칙 5가지

1. **무과금도 모든 콘텐츠를 클리어할 수 있다**
2. 과금은 “우회”이지 “필수 조건”이 아니다
3. 광고는 **무과금 유저의 생존 수단**이다
4. 랭킹은 **실력 + 시간 + 선택의 결과**여야 한다
5. 희소성은 **판매가 아닌 획득**에서 나온다

---

## 1️⃣ 과금의 주된 역할 정의

### 1.1 과금의 기능적 목적

이 게임에서 과금은 다음 목적을 동시에 가진다:

```text
MonetizationRoles
- 성장 가속 (Acceleration)
- 실패 완화 (Failure Mitigation)
- 수집 욕구 충족 (Collection)
- 경쟁 요소 보조 (Ranking Support)
```

> ❗ 단, **과금 없이는 진행 불가한 구조는 금지**

---

### 1.2 랭킹과 과금의 관계

* 랭킹 유형:

  * 글로벌 랭킹
  * 국가별 랭킹
  * 챕터별 랭킹

```text
RankingPolicy
- ranking_scope: global | regional | chapter
- monetization_direct_power: false
```

> 과금은 랭킹 **상위 진입을 빠르게 할 수는 있지만**
> **실력 없는 상위 고착은 불가능**

---

## 2️⃣ 광고(Rewarded Ad) 시스템 설계

### 2.1 광고의 전략적 위치

광고는 **인앱결제의 밸런스 붕괴를 막는 핵심 장치**다.

```text
AdUsagePurpose
- revive_after_fail
- reward_multiplier_after_run
- emergency_coin_supply
- daily_free_benefit
```

---

### 2.2 광고의 필수성 정의

* 광고는:

  * **선택이지만**
  * 고난이도 챕터에서는 **사실상 필수 수단**

```text
AdPhilosophy
- mandatory_feeling: yes
- forced_viewing: no
```

> 유저는
> “광고를 봐야만 깰 수 있었다”가 아니라
> **“광고를 써서 돌파했다”**고 느껴야 한다

---

### 2.3 광고 미시청에 대한 체감

* 광고를 보지 않아도 손해는 아님
* 단, 성장 체감 속도는 느려짐

```text
AdVsGrowth
- ad_user: faster_progress
- non_ad_user: slower_but_possible
```

---

## 3️⃣ 판매하지 않는 귀한 것 (Non-Sellable Value)

> **이 게임에서 가장 중요한 결정 중 하나**

### 3.1 “절대 판매하지 않는 것”의 존재

```text
NonSellableAssets
- 특정 캐릭터 Variant
- 특정 스킬 Variant
- 상위 룬 각성 형태
- 챕터/랭킹 한정 칭호
```

---

### 3.2 획득 방식

* 오직 다음을 통해서만 획득:

  * 고난이도 챕터 클리어
  * 특정 랭킹 도달
  * 장기 플레이 누적 보상

```text
ExclusiveAcquirePolicy
- purchasable: false
- ad_acquirable: false
- grind_required: true
```

> 이 요소들이 **게임 내 최고 가치**를 가진다
> → 과금 유저도 반드시 플레이해야 함

---

## 4️⃣ 직접 판매 대상 정의

### 4.1 직접 판매 허용 대상

```text
DirectPurchaseAllowed
- premium_currency (gem)
- convenience_packages
- starter_packages
- vip_pass
```

---

### 4.2 직접 판매 금지 대상

```text
DirectPurchaseForbidden
- exclusive_skill_variant
- top_tier_rune_awaken
- ranking_reward_assets
```

---

## 5️⃣ 성능 과금에 대한 기준

### 5.1 성능 과금 허용 범위

```text
PowerPurchasePolicy
- early_game: allowed
- mid_game: limited
- late_game: gameplay_required
```

> 과금은 “지름길”일 뿐
> **최종 도착지는 플레이로만 가능**

---

### 5.2 과금 vs 플레이 가치 분리

* 과금:

  * 시간 단축
  * 실패 완화
* 플레이:

  * 고난이도 클리어
  * 희소 자산 획득

---

## 6️⃣ 시간 기반 시스템

### 6.1 도입 요소

```text
TimeBasedSystems
- daily_reset_rewards
- ad_cooldown
```

* 에너지 시스템 ❌
* 플레이 제한 ❌

> “한 판 구조”와 충돌 방지

---

## 7️⃣ 패키지 & 이벤트 설계

### 7.1 패키지 노출 타이밍

```text
PackageTiming
- chapter_clear
- periodic_event
```

* 첫 실패 직후 ❌ (압박 금지)

---

### 7.2 필수 UX 요소

```text
RequiredMonetizationUX
- first_purchase_bonus
- cumulative_purchase_reward
- vip_system
```

---

### 7.3 VIP 시스템 철학

```text
VIPPolicy
- convenience_focus
- no_exclusive_power
- quality_of_life_only
```

---

## 8️⃣ 확률형 상품에 대한 입장

### 8.1 확률 공개 정책

```text
GachaProbabilityPolicy
- public_exact_rate: false
- internal_rate_higher_than_displayed: true
```

> 유저는
> “확률이 낮다”가 아니라
> **“내가 운이 좋은 편이다”**라고 느껴야 한다

---

### 8.2 국가별 대응

* 중국/유럽:

  * 법적 요구 최소 충족
* 일본/기타:

  * 천장 시스템 강조

---

## 9️⃣ 과금 윤리 규칙 (절대 금지 사항)

```text
ForbiddenCases
- paywall_blocking_clear
- mandatory_purchase_for_progress
- forced_ads
```

---

### 허용되는 구조

* 과금 없으면:

  * 클리어는 가능
  * 다만 시간이 오래 걸림
  * 성장 속도 차이 발생

---

## 10️⃣ Monetization 관련 데이터 구조 (요약)

```text
MonetizationMetaState
- vip_level
- total_purchase_amount
- first_purchase_completed
```

```text
AdMetaState
- daily_ad_count
- ad_cooldown_remaining
```

---

## ✅ 이 문서로 확정된 것

* 과금/광고/랭킹의 관계 명확화
* 무과금 클리어 보장
* 판매되지 않는 최고 가치 자산 정의
* 글로벌 윤리 기준 충족
* 장기 서비스 가능한 BM 구조

