좋다 🔥🔥🔥
이제 진짜 **전투의 심장 + 손맛 + 이펙트 시스템** 설계 들어간다.

지금 목표는:

> ✔ 데이터 기반 Skill
> ✔ 상태이상 연동
> ✔ 속성 연동
> ✔ 강한 타격감
> ✔ 화려한 이펙트
> ✔ Flame 기반 확장 가능 구조

그냥 스킬 함수 하나가 아니라
**전투 엔진 구조**를 만든다.

---

# 📄 skill_engine_design.md

---

# 1️⃣ 전체 구조 개요

```text
SkillEngine
 ├─ SkillExecutor
 ├─ TargetSelector
 ├─ DamageCalculator
 ├─ StatusApplier
 ├─ EffectSpawner
 ├─ HitFeedbackSystem
```

각 책임을 분리한다.
이게 “확장 가능”의 핵심이다.

---

# 2️⃣ 핵심 인터페이스 설계

## 🔥 SkillData (JSON → Dart)

```dart
class SkillData {
  final String id;
  final String owner;
  final ElementType element;
  final DamageType damageType;
  final TargetType targetType;
  final double range;
  final double cooldown;
  final double multiplier;
  final int hitCount;
  final List<StatusEffectData> effects;

  SkillData({
    required this.id,
    required this.owner,
    required this.element,
    required this.damageType,
    required this.targetType,
    required this.range,
    required this.cooldown,
    required this.multiplier,
    required this.hitCount,
    required this.effects,
  });
}
```

---

# 3️⃣ SkillEngine 메인 구조

```dart
class SkillEngine {
  final DamageCalculator damageCalculator;
  final StatusEngine statusEngine;
  final EffectSpawner effectSpawner;
  final HitFeedbackSystem feedbackSystem;

  SkillEngine({
    required this.damageCalculator,
    required this.statusEngine,
    required this.effectSpawner,
    required this.feedbackSystem,
  });

  void executeSkill({
    required Character caster,
    required SkillData skill,
    required List<Character> targets,
  }) {
    for (final target in targets) {
      for (int i = 0; i < skill.hitCount; i++) {
        final damage = damageCalculator.calculate(
          caster: caster,
          target: target,
          skill: skill,
        );

        target.applyDamage(damage);

        statusEngine.applyEffects(
          caster: caster,
          target: target,
          effects: skill.effects,
          element: skill.element,
        );

        feedbackSystem.playHitFeedback(target, damage);

        effectSpawner.spawnImpactEffect(
          skill.element,
          target.position,
        );
      }
    }

    effectSpawner.spawnCastEffect(
      skill.element,
      caster.position,
    );
  }
}
```

---

# 4️⃣ DamageCalculator

```dart
class DamageCalculator {
  double calculate({
    required Character caster,
    required Character target,
    required SkillData skill,
  }) {
    double base = caster.attack * skill.multiplier;

    double elementMultiplier =
        ElementSystem.getMultiplier(skill.element, target.element);

    double defenseReduction =
        1 - (target.defense / (target.defense + 100));

    return base * elementMultiplier * defenseReduction;
  }
}
```

---

# 5️⃣ StatusEngine

```dart
class StatusEngine {
  void applyEffects({
    required Character caster,
    required Character target,
    required List<StatusEffectData> effects,
    required ElementType element,
  }) {
    for (final effect in effects) {
      target.addStatus(
        StatusEffect(
          type: effect.type,
          duration: effect.duration,
          value: effect.value,
          maxStack: effect.maxStack,
          isStackable: effect.maxStack > 1,
          refreshOnReapply: true,
          element: element,
        ),
      );
    }
  }
}
```

---

# 6️⃣ 💥 손맛 시스템 (핵심)

손맛은 4가지로 만든다.

## 1️⃣ Hit Stop

```dart
Future<void> hitStop(Duration duration) async {
  game.pauseEngine();
  await Future.delayed(duration);
  game.resumeEngine();
}
```

0.05~0.08초 정지 → 엄청 강한 타격감.

---

## 2️⃣ Screen Shake

```dart
void shakeCamera(double intensity) {
  camera.shake(intensity: intensity, duration: 0.2);
}
```

보스 스킬은 강하게.

---

## 3️⃣ Damage Pop Animation

```dart
feedbackSystem.showDamageNumber(
  position: target.position,
  damage: damage,
  isCritical: true,
);
```

* 크리 → 붉은색 + 확대
* 속성 상성 → 색 다르게

---

## 4️⃣ Element Impact FX

```dart
effectSpawner.spawnImpactEffect(
  ElementType.FIRE,
  position,
);
```

속성별 이펙트 분리:

* FIRE → 폭발
* WATER → 파동
* ELECTRIC → 번쩍임
* LIGHT → 빛 파편
* DARK → 그림자 파열
* NATURE → 잎/독 안개

---

# 7️⃣ EffectSpawner 구조

```dart
class EffectSpawner {
  void spawnImpactEffect(ElementType element, Vector2 position) {
    switch (element) {
      case ElementType.FIRE:
        game.add(FireExplosion(position));
        break;
      case ElementType.ELECTRIC:
        game.add(LightningImpact(position));
        break;
      case ElementType.DARK:
        game.add(DarkBurst(position));
        break;
      default:
        break;
    }
  }
}
```

---

# 8️⃣ TargetSelector 설계

```dart
class TargetSelector {
  List<Character> selectTargets(
    TargetType type,
    Character caster,
    List<Character> enemies,
  ) {
    switch (type) {
      case TargetType.SINGLE:
        return [closestEnemy(caster, enemies)];
      case TargetType.AREA:
        return enemies.where((e) =>
            e.position.distanceTo(caster.position) < 300).toList();
      case TargetType.CHAIN:
        return selectChain(enemies, 3);
      default:
        return [];
    }
  }
}
```

---

# 🔥 손맛 강화 설계 포인트

| 요소          | 체감도   |
| ----------- | ----- |
| HitStop     | ★★★★★ |
| ScreenShake | ★★★★  |
| 사운드 동기화     | ★★★★★ |
| 다단히트        | ★★★★  |
| 화면 밝기 플래시   | ★★★   |

---