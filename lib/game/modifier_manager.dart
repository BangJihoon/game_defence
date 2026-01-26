
import 'package:flame/components.dart';

class ModifierManager extends Component {
  // Global modifiers
  double globalDamageMultiplier = 1.0;
  double globalCooldownMultiplier = 1.0;
  double coinGainMultiplier = 1.0;
  bool isCoinGainDisabled = false; // New field for disabling coin gain

  // Wall modifiers
  double wallMaxHpMultiplier = 1.0;

  // Skill-specific modifiers
  final Map<String, Map<String, double>> _skillModifiers = {};

  void applyGlobalModifier(String stat, double value) {
    switch (stat) {
      case 'damage':
        globalDamageMultiplier += value;
        break;
      case 'cooldown':
        globalCooldownMultiplier += value;
        break;
      case 'coin_gain':
        coinGainMultiplier += value;
        break;
      default:
        print("Unhandled global modifier stat: $stat");
    }
  }

  void applyWallModifier(String stat, double value) {
    switch (stat) {
      case 'max_hp':
        wallMaxHpMultiplier += value;
        break;
      default:
        print("Unhandled wall modifier stat: $stat");
    }
  }

  void applySkillModifier(String skillId, String stat, double value) {
    _skillModifiers.putIfAbsent(skillId, () => {});
    _skillModifiers[skillId]!.update(stat, (v) => v + value, ifAbsent: () => 1.0 + value);
  }

  double getSkillModifier(String skillId, String stat) {
    return _skillModifiers[skillId]?[stat] ?? 1.0;
  }

  void disableCoinGain() {
    isCoinGainDisabled = true;
  }

  void enableCoinGain() {
    isCoinGainDisabled = false;
  }
}
