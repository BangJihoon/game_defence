
# 📄 spec/09_data_flow.md

## Data Flow Specification

*(Run → Meta → Analytics 전체 흐름 정의)*

---

## 0. 문서 목적

이 문서는 다음을 명확히 정의한다.

* Run(한 판) 시작부터 종료까지 **데이터가 언제 생성/변경/전달되는지**
* Run 데이터와 Meta 데이터의 **경계와 전달 규칙**
* 운영/밸런스 분석을 위한 **로그 이벤트 기준**

> ⚠️ 규칙
>
> * Run 데이터는 **영구 저장하지 않는다**
> * Meta 데이터는 **Run 중 직접 변경되지 않는다**
> * 모든 데이터 변경은 **이벤트 기반**으로 발생한다

---

## 1️⃣ Run 시작(Data Initialization Flow)

### 1.1 Run 시작 트리거

* 유저가 “게임 시작” 버튼 클릭
* 이전 Run 데이터는 모두 폐기

---

### 1.2 Run 초기화 규칙 (확정)

Run 시작 시 다음 데이터가 초기화된다:

```text
RunState.init():
- current_wave = 1
- elapsed_sec = 0
- coins_current = 0
- coins_earned_total = 0
- coins_spent_total = 0

- castle_state.current_hp = castle_state.max_hp
- castle_state.shield_hp = meta + rune + item 반영값
- revive_remaining = meta + item 반영값
```

---

### 1.3 Meta → Run 반영 데이터

다음 Meta 데이터는 **Run 시작 시 1회만 반영**된다:

```text
- 캐릭터 기본 스킬
- 캐릭터 고유 특성
- 룬 효과
- 아이템 효과
- 스킬 영구 강화 수치
```

> ❗ Run 도중 Meta 데이터는 변경되지 않는다

---

### 1.4 Pity(천장) 초기 상태

* 이전 Run의 pity 상태 일부 반영 가능
* 단, **Config로 제어 가능** (reset / partial carry)

```text
GachaRuntimeState.init():
- pity_state.fail_count = meta_pity_snapshot
```

---

## 2️⃣ Wave 전환(Data Transition Flow)

### 2.1 Wave 시작 시

```text
onWaveStarted(wave_number):
- spawn_table 로드
- enemy_spawn_system 활성화
- wave_timer 시작
```

---

### 2.2 Wave 종료 시 처리 규칙

기본 동작:

* 잔여 적 제거 ❌
* 즉시 다음 Wave 진입 ⭕ (default)

선택적 처리(Config 기반):

```text
- coin_bonus 지급
- castle_shield 회복
- grace 효과 초기화
```

> 보너스 처리 여부는 **wave_definition의 property**로 관리

---

## 3️⃣ Enemy 사망(Data Event Flow)

### 3.1 Enemy 사망 이벤트

```text
onEnemyKilled(enemy_id, enemy_type):
```

즉시 처리:

```text
- coins_current += enemy.coin_reward
- coins_earned_total += enemy.coin_reward
- kill_count += 1
```

---

### 3.2 보너스 코인 트리거

* 특정 조건 충족 시 발동

  * 예: 10킬마다 +보너스 코인
  * 외부 아이템/룬/특성으로 제어

```text
if (kill_count % bonus_trigger == 0):
  coins_current += bonus_coin
```

---

### 3.3 처치 트리거 효과

```text
- "적 처치 시 발동" 스킬/아이템 효과
- 체인 효과 / 버프 누적
```

---

## 4️⃣ Skill 발동(Data Mutation Flow)

### 4.1 Skill Cast 발생 시

```text
onSkillCast(skill_id, variant_id):
```

반드시 처리:

```text
- skill.cast_count_total += 1
- skill.cooldown_timer_sec = 0
- log_skill_cast
```

---

### 4.2 Skill Hit 발생 시

```text
onSkillHit(skill_id, enemy_id, damage):
```

```text
- 누적 피해량 기록
- 적 HP 감소
```

> 이 데이터는 **Run 통계용**이며
> Meta에는 **요약값만 전달 가능**

---

## 5️⃣ Castle 피해 처리 파이프라인

### 5.1 CastleDamagePipeline (확정 순서)

```text
1. Shield 감소
2. Defense(방어력) 적용
3. HP 감소
```

---

### 5.2 Damage 계산식 개념

```text
effective_damage =
  (raw_damage - defense)
  * (1 - damage_reduction_ratio)
```

---

## 6️⃣ Castle 파괴 & Grace Time Flow

### 6.1 Castle HP = 0 도달 시

```text
onCastleBroken():
- grace_timer 시작
```

Grace 기간 동안:

* 스킬 발동 ⭕
* 뽑기 버튼 사용 ⭕
* 적 스폰 ❌ (기본값)
* 적 공격 ❌

---

### 6.2 Revival 체크

```text
if revive_remaining > 0:
  revive_remaining -= 1
  restore_hp = max_hp * revive_restore_ratio
  grace_timer 종료
else:
  GameOver 확정
```

---

## 7️⃣ Game Over 확정(Data Finalization Flow)

### 7.1 Game Over 조건

```text
- grace 종료 후 HP <= 0
- 최종 보스 타임아웃
- 유저 수동 종료
```

---

### 7.2 Game Over 시 즉시 처리

```text
- Meta 보상 계산
- 통계 요약 생성
```

> ❗ Run 데이터는 즉시 폐기
> ❗ pity 상태는 **요약 후 Meta로 전달**

---

## 8️⃣ Run → Meta 데이터 전달

### 8.1 Meta로 전달되는 데이터

```text
- cleared_wave_count
- total_kill_count
- used_skill_list
- pity_summary
```

---

### 8.2 Meta 반영 시점

* Result Screen 진입 시
* 광고 보상 수령 시 추가 반영 가능

---

## 9️⃣ Logging & Analytics Flow

### 9.1 로그 목적

* 운영 밸런스 분석
* 빠른 난이도 대응
* 불운 시스템 검증

---

### 9.2 기본 로그 이벤트 (샘플링 가능)

```text
log_wave_start
log_wave_end
log_enemy_killed
log_skill_cast
log_gacha_pull
log_gacha_pity_triggered
log_game_over
```

> 로그 레벨 / 이벤트 활성화 여부는 **원격 Config로 제어**

---

## 10️⃣ 절대 규칙 (Non-Negotiable)

```text
- Run 데이터는 영구 저장 ❌
- Meta 데이터는 Run 중 직접 수정 ❌
- Config는 런타임 중 변경 ⭕
- 모든 상태 변화는 이벤트 기반 ⭕
```

---

## ✅ 정리

이 문서로 확정된 것:

* 데이터 생명주기 완전 고정
* Run ↔ Meta 경계 명확
* 천장/불운/운영 대응 구조 완성
* 구현 시 **의사결정 없이 코드만 작성 가능**

---

이제 다음 차례는 약속한 대로 **2️⃣ Balance Tuning 문서**야.

👉 다음 메시지에서
**`spec/10_balance_tuning.md`**

* 웨이브/적/스킬/뽑기 밸런스 설계
* “어디를 건드리면 어떤 체감이 바뀌는지”
* 라이브 운영 시 빠른 패치 전략

까지 **문서로만** 정리해줄게.

준비됐으면, 다음으로 간다 🚀
