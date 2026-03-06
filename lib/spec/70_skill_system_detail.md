# Skill System Design

## 1. 목표

- 모든 스킬은 JSON 기반 데이터로 관리
- 코드 수정 없이 밸런스 조정 가능
- 상태이상 시스템과 완전 연결
- PvE / PvP 공통 사용

---

## 2. 필드 설명

| 필드 | 설명 |
|------|------|
| id | 고유 식별자 |
| owner | 캐릭터 ID |
| element | 속성 |
| damageType | PHYSICAL / MAGIC / NONE |
| targetType | SINGLE / AREA / LINE / CHAIN / GLOBAL |
| range | 사거리 |
| cooldown | 재사용 대기시간 |
| multiplier | 공격력 계수 |
| hitCount | 타격 횟수 |
| effects | 부여 상태이상 리스트 |

---

## 3. TargetType 정의

| 타입 | 설명 |
|------|------|
| SINGLE | 단일 대상 |
| AREA | 원형 범위 |
| LINE | 직선 관통 |
| FRONT_CONE | 전방 부채꼴 |
| CHAIN | 연쇄 공격 |
| GLOBAL | 전맵 |

---

## 4. Damage Calculation


finalDamage =
(Attack * multiplier)

elementMultiplier

critMultiplier

defenseReduction
---

## 5. 상태이상 적용 순서

1. 피해 계산
2. 속성 상성 적용
3. 피해 적용
4. 상태이상 부여
5. 중첩 처리

---

## 6. 확장 설계

향후 추가 가능:

- 조건부 발동
- HP 비율 기반 강화
- 킬 트리거
- 파티 버프 연계
- 스킬 진화 단계

---

## 7. 밸런싱 가이드

- 기본 단일기: 2.5~3.0
- 광역기: 1.5~2.2
- 다단기: 1.2 * hitCount
- 제어기: 피해 낮게 + 상태이상 강하게

---

