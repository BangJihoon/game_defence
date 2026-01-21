
# 📄 spec/11_content_pipeline.md

## Content Pipeline & Live Content Operation

> 이 문서는
> **스킬 / 적 / 보스 / 카드 / 챕터 콘텐츠를 추가·수정·검증·배포하는 전 과정을 정의**한다.
> 기획자·밸런서·개발자가 **서로 충돌 없이 협업**하는 것을 목표로 한다.

---

## 0. 파이프라인 설계 철학

### 핵심 원칙

1. **콘텐츠 추가 ≠ 코드 수정**
2. 모든 신규 콘텐츠는 **Config(JSON)만으로 동작**
3. 실패 가능성은 QA 단계에서 제거
4. 라이브 반영은 **원격 Config**로 단계적 적용

---

## 1️⃣ Skill 콘텐츠 추가 파이프라인

### 1.1 신규 스킬 추가 절차 (Step-by-Step)

#### Step 1. Skill Definition 작성

```text
config/skills/
└─ skill_lightning_chain.json
```

```json
{
  "skill_id": "lightning_chain",
  "name_locale_key": "skill.lightning_chain.name",
  "desc_locale_key": "skill.lightning_chain.desc",

  "skill_type": "projectile",
  "rarity": "epic",

  "base_stats": {
    "base_damage": 18,
    "base_cooldown_sec": 1.8,
    "min_cooldown_sec": 0.3
  }
}
```

---

#### Step 2. Variant 정의 (지속 확장 핵심)

```json
{
  "variant_id": "chain_upgrade",
  "unlock_condition": {
    "required_skill_level": 10
  },
  "effect_list": [
    {
      "effect_type": "chain",
      "base_value": 2,
      "value_per_level": 1
    }
  ]
}
```

> 이 구조로 **“같은 스킬, 다른 플레이 감각”**을 무한 확장 가능

---

#### Step 3. Locale 추가 (5개 언어)

```text
l10n/
├─ locale_en.json
├─ locale_ko.json
├─ locale_ja.json
├─ locale_es.json
└─ locale_zh.json
```

> ❗ locale_key 없으면 빌드 실패 처리 (검증 규칙)

---

#### Step 4. 카드 연결

```text
CardDefinition
- card_type: learn_skill
- target_skill_id: lightning_chain
```

---

### 1.2 Skill QA 체크리스트

* [ ] 쿨타임 최소값 존재
* [ ] 무한 발동 루프 없음
* [ ] Variant unlock 조건 명확
* [ ] 천장 시스템과 충돌 없음
* [ ] 모든 locale_key 존재

---

## 2️⃣ Enemy 콘텐츠 추가 파이프라인

### 2.1 신규 적 추가 절차

```text
config/enemies/
└─ enemy_splitter_beast.json
```

```json
{
  "enemy_id": "splitter_beast",
  "enemy_type": "splitter",

  "base_hp": 120,
  "base_move_speed": 40,
  "base_attack_damage": 8,

  "abilities": ["split_on_death"]
}
```

---

### 2.2 Enemy Ability 확장

```json
{
  "ability_id": "split_on_death",
  "trigger_condition": "on_death",
  "effect": {
    "spawn_enemy_id": "small_beast",
    "spawn_count": 3
  }
}
```

> Ability는 **조합 가능**, 단 보스 전용 우선

---

### 2.3 Enemy QA 체크리스트

* [ ] 성벽 도달 가능 여부
* [ ] Ability 중첩 위험 없음
* [ ] 스폰 무한 루프 없음
* [ ] 고난이도 전용 플래그 설정

---

## 3️⃣ Boss 콘텐츠 파이프라인

### 3.1 Boss 정의 구조

```text
BossDefinition
- boss_id
- phase_list
- enraged_condition
```

```json
{
  "boss_id": "ancient_golem",
  "phases": [
    {
      "phase_id": "phase_1",
      "hp_threshold": 1.0,
      "spawn_pattern": "minion_wave"
    },
    {
      "phase_id": "phase_2",
      "hp_threshold": 0.5,
      "ability_unlock": "earthquake"
    }
  ]
}
```

---

### 3.2 Boss 설계 규칙

* 최소 2 Phase
* 시간 압박 요소 필수
* 광역 스킬 대응 필요
* 처치 시 보상 스파이크 제공

---

## 4️⃣ Wave / Chapter 콘텐츠 파이프라인

### 4.1 Chapter 정의

```text
ChapterDefinition
- chapter_id
- difficulty_modifier
- wave_list
```

```json
{
  "chapter_id": "chapter_3",
  "difficulty_modifier": 1.25
}
```

---

### 4.2 Wave 테이블 작성

```json
{
  "wave_number": 18,
  "spawn_groups": [
    {
      "enemy_id": "normal_slime",
      "count": 30,
      "spawn_interval_sec": 0.5
    }
  ]
}
```

---

### 4.3 Chapter QA 기준

* 평균 클리어율 40~60%
* 부활 사용률 20~35%
* 천장 발동률 과도하지 않음

---

## 5️⃣ Gacha / Card 콘텐츠 파이프라인

### 5.1 카드 추가 절차

```text
CardDefinition
- card_id
- card_type
- effect
- rarity
```

> 카드 자체는 **Meta 수집 대상 아님**
> → 결과만 Meta/Run에 반영

---

### 5.2 천장 검증 규칙

* 특정 결과 10회 이상 미등장 ❌
* pity 발동 로그 반드시 기록
* 확률 변경 시 기존 pity 유지

---

## 6️⃣ QA & 테스트 파이프라인

### 6.1 내부 테스트 단계

```text
DEV → QA → Soft Launch → Global
```

---

### 6.2 테스트용 Config

```json
{
  "debug": {
    "force_skill": "fireball",
    "force_gacha_result": "upgrade_skill",
    "skip_wave": true
  }
}
```

---

## 7️⃣ 라이브 배포 & 롤백 전략

### 7.1 단계적 배포

* 10% → 50% → 100%
* clear_rate / revive_rate 모니터링

---

### 7.2 즉각 롤백 조건

```text
- clear_rate 급락
- revive_usage 급증
- 특정 스킬 사용률 70% 이상
```

---

## 8️⃣ 운영자를 위한 체크리스트

### 콘텐츠 추가 전

* [ ] locale 5종 추가
* [ ] QA 시뮬레이션 통과
* [ ] 천장 충돌 없음

### 배포 후

* [ ] 로그 정상 수집
* [ ] 자동 밸런스 작동 확인
* [ ] 커뮤니티 반응 모니터링

---

## ✅ 이 문서로 완성된 것

* 콘텐츠 추가 절차 완전 고정
* 스킬/적/보스/챕터 확장 무한 가능
* 기획자 단독 작업 가능 영역 명확
* 라이브 운영 리스크 최소화

