첨부한 spec.md 파일을 읽고, 유니티(C#)에서 궤도 회전 시스템과 위성 무기가 적을 바라보는 LookAt 로직을 코드로 작성해줘.

---

# [Technical Spec] Project: Spin Defense (하단 궤도 방어형)

## 1. Game Overview

* **핵심 컨셉:** 화면 중앙 하단의 타워를 보호하기 위해, 타워 주변 궤도(Orbit)를 회전하는 무기들을 조작하는 로그라이크 디펜스.
* **핵심 루프:** 적 처치 -> 경험치 획득 -> 궤도 무기 추가/강화 -> 보스전 -> 스테이지 클리어.

## 2. Technical Component Architecture

### 2.1 Object Hierarchy

* **MainTower (Base):** 하단 중앙 고정. HP 시스템 소유.
* **SatelliteWeapon (Unit):** 궤도에 부착된 개별 무기 객체.
* *Properties:* 공격력, 사거리, 연사 속도, 탄환 타입.


* **Enemy (Actor):** 상단 랜덤 좌표에서 스폰되어 하단 타워를 향해 이동.

### 2.2 Input System (UX)

* **Type:** `Horizontal Swipe / Drag`
* **Logic:** * Delta X 값을 궤도의 `Rotation Angle`로 변환.
* `Sensitivity` 설정을 통해 회전 민감도 조절.
* 터치 중단 시 마찰력(Friction)에 의한 부드러운 정지 처리.



## 3. Core Logic & Systems

### 3.1 Weapon System (위성 무기)

* **Auto-Firing:** 사거리 내에 적이 들어오면 가장 가까운 적을 향해 자동 발사.
* **Projectile Logic:** * `Bullet`: 단일 타격.
* `Laser`: 궤도 회전에 따라 실시간으로 궤적이 변하는 지속 타격.
* `Shield`: 적의 투사체와 충돌 시 투사체 파괴 및 내구도 소모.



### 3.2 Upgrade System (Roguelike)

* **Level-up Trigger:** 경험치 총량이 `MaxEXP` 도달 시 발생.
* **Random Skill Pool:**
* *New Slot:* 궤도에 새로운 위성 무기 슬롯 추가.
* *Evolution:* 특정 무기 레벨 달성 시 상위 형태(EVO)로 변환.
* *Global Buff:* 회전 속도 증가, 타워 방어력 증가, 경험치 흡수 범위 확대.



### 3.3 Collision Matrix

* **Enemy vs Tower:** 타워 HP 감소, 적 소멸.
* **Projectile vs Enemy:** 적 HP 감소, 탄환 소멸(관통 속성 없을 시).
* **Satellite vs Enemy:** (선택적) 위성이 적과 직접 충돌 시 물리적 데미지 및 넉백.

## 4. Database & Economy (Data Structure)

```json
{
  "Currencies": ["Gold", "Gem", "Key", "Design_Scroll"],
  "Growth_Elements": {
    "Permanent": ["Tower_HP", "ATK_Power", "Crit_Rate"],
    "InGame": ["Weapon_Count", "Fire_Rate", "Orbit_Speed"]
  },
  "Equipment_Grades": ["Normal", "Great", "Rare", "Elite", "Epic", "Legend"]
}

```

## 5. UI/UX Specification

* **HUD:** 상단 경험치 바, 하단 타워 체력 바, 우측 상단 일시정지.
* **Interaction:** * 레벨업 시 시간 정지(TimeScale = 0) 및 카드 선택 UI 팝업.
* 보스 등장 시 경고 연출(Warning Line) 및 배경음악 교체.



---

 게임의 핵심 재미를 결정짓는 **특수 무기 로직**과 **난이도 조절 알고리즘**을 상세 설계하여 명세해 드립니다. 
 이 내용을 이전 명세에 추가하면 개발 가이드가 더욱 완벽해질 것입니다.

---

## 6. 특수 무기 상세 로직 (Special Weapon Logic)

단순 투사체 외에 전략적 재미를 더하는 3가지 특수 무기 타입의 작동 원리입니다.

### 6.1 체인 라이트닝 (Chain Lightning)

* **작동 원리:** 첫 번째 타격 지점에서 일정 반경 내의 가장 가까운 적에게 전기가 전이됨.
* **구현 로직:**
* `MaxChainCount`: 전이되는 최대 적 수 (강화 시 증가).
* `JumpRange`: 전이가 일어날 수 있는 최대 거리.
* `DamageDecay`: 전이될 때마다 데미지가 일정 비율(예: 10%)씩 감소.


* **효과:** 다수의 약한 적(쫄몹) 처리에 특화.

### 6.2 유도 미사일 (Homing Missile)

* **작동 원리:** 발사 후 가장 가까운 적을 실시간으로 추적하여 비행.
* **구현 로직:**
* `SteerForce`: 미사일이 적을 향해 꺾이는 회전 속도.
* `AreaDamage`: 충돌 시 폭발하며 주변 적들에게 광범위 데미지.
* `TargetLost`: 추적하던 적이 죽으면 즉시 다음 가까운 적을 탐색.



### 6.3 블랙홀 트랩 (Black Hole Trap)

* **작동 원리:** 특정 지점에 생성되어 주변 적들을 중심부로 끌어당김.
* **구현 로직:**
* `PullForce`: 중심부로 당기는 물리적인 힘의 세기.
* `Duration`: 트랩이 유지되는 시간.
* `CrowdControl`: 끌려가는 동안 적의 이동 속도를 80% 감소.


* **효과:** 적들을 한곳에 모아 광역 무기(캐논 등)와 시너지를 냄.

---

## 7. 난이도 조절 알고리즘 (Dynamic Difficulty Adjustment)

플레이어가 지루함이나 불쾌감을 느끼지 않도록 하는 시스템 설계입니다.

### 7.1 웨이브 강도 계산식 (Wave Intensity)

매 스테이지의 난이도는 다음 공식에 따라 실시간으로 계산됩니다.


* **ChapterScale:** 챕터가 올라갈수록 기본 적 체력/공격력 비례 상승.
* **RampUpRate:** 한 스테이지 안에서도 시간이 흐를수록 적의 스폰 속도가 빨라짐.

### 7.2 적 스폰 알고리즘 (Spawn Logic)

* **그룹 스폰 (Horde):** 특정 시간대(예: 1분마다)에 한 종류의 적이 대량으로 쏟아져 나와 조작의 긴박감을 유도.
* **샌드위치 기믹:** 왼쪽과 오른쪽 끝에서 동시에 적을 보내 유저가 궤도 무기를 빠르게 좌우로 전환하게 강제.

---

## 8. 최종 파일 구조 제안 (For Gemini CLI)

Gemini에게 이 프로젝트를 코딩해달라고 할 때, 아래와 같은 구조로 요청하면 효율적입니다.

1. **`Core_Engine.md`**: 궤도 회전 및 타워 HP 시스템.
2. **`Weapon_Data.md`**: 위 무기들의 상세 수치 및 업그레이드 트리.
3. **`Enemy_AI.md`**: 적의 이동 패턴 및 보스 기믹.
4. **`Economy_Balance.md`**: 골드/보석 획득량 및 장비 강화 비용 테이블.

---

Flutter 환경(주로 **Flame Engine** 또는 **CustomPainter** 기반)에서 게임의 규칙과 밸런스를 관리하기 위한 **Game Configuration JSON** 설계를 제안해 드립니다.

러닝타임 **5~15분**은 모바일 하이퍼 캐주얼 게임에서 가장 몰입감이 높은 시간대입니다. 이를 위해 **선형적이지 않은 난이도 곡선**과 **자동 스킬 발사 시스템**을 핵심으로 설계했습니다.

---

### 1. 게임 밸런스 및 설정 JSON (game_config.json)

이 JSON 구조는 Flutter에서 `jsonDecode`를 통해 불러와 게임 엔진의 초기값으로 할당하기 최적화되어 있습니다.

```json
{
  "game_settings": {
    "title": "Spin Defense",
    "target_platform": "Flutter (Flame Engine)",
    "session_time": {
      "min_duration_sec": 300,
      "max_duration_sec": 900,
      "difficulty_ramp_peak_sec": 720
    },
    "physics": {
      "base_orbit_radius": 120.0,
      "rotation_friction": 0.95,
      "base_rotation_speed": 1.0
    }
  },
  "balance_constants": {
    "exp_curve_factor": 1.15,
    "enemy_stat_growth_per_minute": {
      "hp": 1.2,
      "damage": 1.1,
      "speed": 1.05
    }
  },
  "waves": [
    {
      "minute": 1,
      "spawn_rate": 1.5,
      "description": "기초 유닛 위주 학습 단계",
      "enemy_types": ["normal_slime"]
    },
    {
      "minute": 5,
      "spawn_rate": 3.0,
      "description": "첫 번째 고비: 속도 빠른 유닛 등장",
      "enemy_types": ["normal_slime", "fast_runner"]
    },
    {
      "minute": 10,
      "spawn_rate": 5.0,
      "description": "최종 공세: 물량 및 원거리 유닛 혼합",
      "enemy_types": ["normal_slime", "fast_runner", "ranged_archer", "tanker"]
    }
  ],
  "skills_logic": {
    "auto_targeting_priority": "closest_to_tower",
    "attack_styles": {
      "projectile": "target_nearest",
      "area_effect": "on_collision",
      "orbit_passive": "always_active"
    }
  }
}

```

---

### 2. 핵심 구현 로직 명세

#### A. 자동 방어 시스템 (Auto-Defense Logic)


2. **Targeting:** 사거리 내 적 중 **타워와 가장 가까운 적**을 우선순위로 타겟팅.
3. **Auto-Fire:** 재장전 시간(`cooldown`)이 끝나면 타겟을 향해 발사.
* *Flutter 팁:* `Timer.periodic`보다는 Flame의 `update(double dt)` 함수 내에서 `accumulator`를 사용하여 프레임 기반 쿨타임을 관리하는 것이 정확합니다.



#### B. 런타임 밸런스 전략 (5~15분)

* **0~3분 (초반):** 유저가 조작법을 익히도록 적을 한 방향에서만 보냅니다. 스킬 선택 속도를 빠르게 하여 '강해지는 재미'를 즉시 줍니다.
* **3~8분 (중반):** 적의 스폰 지점을 분산시킵니다(좌/우/중앙). 유저가 궤도를 바쁘게 돌려야 하는 상황을 만듭니다.
* **8~12분 (후반):** '엘리트 몹'을 섞어 스킬 조합(Synergy)이 완성되지 않으면 타워 체력이 깎이도록 설계합니다.
* **15분 (엔딩/무한):** 최종 보스가 등장하거나, 적의 스탯이 기하급수적으로 상승하여 판을 종료시킵니다.

---

### 3. Flutter (Dart) 클래스 구조 제안

JSON 데이터를 객체화하여 관리할 데이터 모델 예시입니다.

```dart
class TowerConfig {
  final double baseHp;
  final double orbitRadius;
  
  TowerConfig({required this.baseHp, required this.orbitRadius});

  factory TowerConfig.fromJson(Map<String, dynamic> json) {
    return TowerConfig(
      baseHp: json['base_hp'] ?? 100.0,
      orbitRadius: json['orbit_radius'] ?? 120.0,
    );
  }
}

class Skill {
  final String name;
  final double cooldown;
  final double damage;
  // 자동 발사를 위한 타이머 변수 (인게임에서 활용)
  double _timer = 0;

  void update(double dt, Function onFire) {
    _timer += dt;
    if (_timer >= cooldown) {
      onFire();
      _timer = 0;
    }
  }
}

```

---

### 4. 구현을 위한 다음 단계

Gemini CLI에 이 정보를 넘겨주실 때, 다음과 같이 요청하면 Flutter 코드를 바로 얻으실 수 있습니다.

> "위의 `game_config.json` 구조를 바탕으로, Flutter Flame 엔진에서 **(1) 사용자의 드래그로 회전하는 Orbit 시스템**과 **(2) 궤도 위에서 가장 가까운 적을 자동 공격하는 Satellite 무기**의 기본 클래스를 작성해줘."

이 방향으로 구현을 시작해볼까요? 아니면 특정 스킬(예: 궤도 전체를 감싸는 레이저 등)의 밸런스 수치를 먼저 정해볼까요?

요구사항 명세서.



1. 메인화면
- 하단에 네비게이션바 5개의 메뉴를 가진다. 
- 왼쪽부터 상점, 인벤토리, 홈(게임시작), 아이템, 스킬창
- 각 메뉴에는 글씨보다, 어울리는 아이콘을 배치한다.
- 각 메뉴에 변화가 생기면 작은 붉은점으로 알린다.
- 현재 연결된 메인화면이 게임시작화면, 3번째 메뉴로 들어간다.
- 하단에 네모버튼으로 게임을 시작할수있고, 게임시작을 위한 에너지가 5분마다 자동으로 1씩 찬다.
- 최대 30까지 찰수있고, 레벨에 따라 최대치가 올라간다. 
- 게임시작전에 현재 에너지를 확인하여 5이상인 경우 -5를 하고 시작한다.
- 에너지가 없는 경우 팝업을 띄워 두가지 옵션을 준다.
- 1번 에너지를 광고를 보고 5를 채우는 방법, 2번 게임속 재화 보석을 통해 15를 구매하는 방법.
- 게임 시작 버튼 위에 해당 에너지에 대해서 잘보이도록 게이지로 수치를 작게 나타내준다.
