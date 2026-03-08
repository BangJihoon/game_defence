
# 📄 spec/00_game_design_document.md

## The Archivist's Doctrine: Game Design & Vision

> **이 문서는 '돌겜 디펜스' 프로젝트의 모든 의사결정을 이끄는 핵심 설계 원칙이자 최종 지침이다.**
> 모든 팀원은 이 문서의 철학에 동의하며, 의문이 생길 때마다 이 문서로 돌아와 답을 찾는다.

---

## 1. 핵심 비전과 철학

### 1.1 한 줄 비전 (The Vision)

> **"매 순간 주어지는 하이-리스크 선택지를 통해, 플레이어 스스로 압도적인 신(God)이 되어가는 경험을 제공하는, 궁극의 중독성 로그라이크 디펜스."**

### 1.2 플레이어 판타지 (The Fantasy)

> **"플레이어는 영웅이 아닌, 흩어진 금단의 힘을 탐욕스럽게 되찾으려는 '우주적 지식의 약탈자'다."**

### 1.3 핵심 게임 루프 (The Core Loop)

> **불안 (Anxiety) → 선택 (Choice) → 힘 (Power) → 정복 (Catharsis) → (Repeat)**
> 웨이브의 압박감 속에서, 단 한 번의 카드 선택으로 전세를 뒤집고, 모든 것을 쓸어버리는 쾌감을 반복적으로 경험한다.

---

## 2. 3대 디자인 원칙 (The Three Pillars)

우리 게임의 모든 시스템은 아래 3가지 원칙을 중심으로 설계되고, 이 원칙을 통해 일관성을 유지한다.

### Ⅰ. 중독 (Addiction through Choice)

*   **핵심**: 게임의 중독성은 '카드 선택' 행위 그 자체에서 나온다. 30~60초마다 주어지는 선택지는 항상 의미 있으며, 즉각적으로 강력한 피드백을 제공한다.
*   **구현**: `05a_card_design_details.md`의 다양한 카드 시스템, `10_balance_tuning.md`의 정교한 난이도 곡선, `11_content_pipeline.md`의 지속적인 콘텐츠 추가 계획은 모두 이 '선택의 중독성'을 강화하기 위해 존재한다.

### Ⅱ. 탐욕 (Greed as a Motivator)

*   **핵심**: 플레이어가 스스로 '탐욕'을 부리도록 적극적으로 유도한다. 더 큰 힘을 위해 기꺼이 위험을 감수하게 만든다.
*   **구현**: `05a_card_design_details.md`의 '저주 카드', `12_monetization_design.md`의 윤리적이면서도 매력적인 보상 설계, `narrative_world.md`의 '지식 약탈자' 판타지, 그리고 `audio_design.md`와 `visual_effect_guidelines.md`의 '잭팟' 연출은 모두 플레이어의 탐욕을 자극하고 보상하기 위해 설계되었다.

### Ⅲ. 재미 (Fun via Overwhelming Power)

*   **핵심**: 이 게임의 근본적인 재미는, 플레이어 스스로의 선택으로 만들어낸 '압도적인 힘'으로 수백의 적을 쓸어버리는 정복의 쾌감에서 온다.
*   **구현**: `visual_effect_guidelines.md`의 '스킬의 시각적 진화'와 '전리품 폭발' 연출, `audio_design.md`의 파괴적인 스킬 임팩트 사운드, 그리고 `post_launch_roadmap.md`의 끝없는 성장 시스템(스킬 각성, 명예)은 모두 이 '압도적인 힘'의 판타지를 실현시키기 위해 존재한다.

---

## 3. 설계 문서 색인 (Document Index)

*   `00_game_design_document.md`: **(본 문서)** 모든 것을 관장하는 최상위 설계 원칙.
*   `10_data_flow.md`: 데이터의 생명주기와 흐름을 정의.
*   `11_card_system.md`: 중독성의 핵심, 다양한 카드 종류와 역할을 정의.
*   `12_balance_tuning.md`: 난이도와 성장 체감에 대한 수학적/철학적 접근.
*   `13_content_pipeline.md`: 코드 수정 없이 콘텐츠를 무한 확장하는 방법.
*   `20_monetization_design.md`: 윤리적이면서도 장기적인 수익 모델.
*   `21_analytics_kpi.md`: 데이터 기반 운영을 위한 핵심 지표.
*   `22_live_operation_rules.md`: 감정에 휘둘리지 않는 라이브 운영 규칙.
*   `23_community_policy.md`: 게임의 중독성을 커뮤니티로 확장하는 방법.
*   `30_narrative_world.md`: '탐욕'을 정당화하는 세계관과 스토리 전달 방식.
*   `31_audio_design.md`: '힘'과 '보상'을 소리로 체감시키는 방법.
*   `32_visual_effect_guidelines.md`: '힘'과 '보상'을 눈으로 극대화하는 방법.
*   `90_qa_test_cases.md`: '버그'와 '의도'를 구분하는 품질 기준.
*   `91_release_scope.md`: '더 나은 출시'가 아닌 '빠른 출시'를 위한 범위 정의.
*   `99_post_launch_roadmap.md`: 끝없는 탐욕과 중독을 위한 장기 계획.
*   `40_marketing_positioning.md`: 우리가 만든 '힘의 판타지'를 세상에 파는 방법.

---

## 4. 개발자를 위한 최종 지침

> **"의사결정이 막히면, 스스로에게 질문하라."**
>
> *"이 결정이 플레이어의 '탐욕'을 더 자극하는가?"*
>
> *"이 결정이 플레이어의 '힘'을 더 극적으로 느끼게 하는가?"*
>
> *"이 결정이 플레이어가 '한 판만 더' 하고 싶게 만드는가?"*
>
> **"셋 중 하나라도 '아니오'라면, 그것은 정답이 아니다."**
