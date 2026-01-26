import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // 메인 메뉴
  String get gameTitle => _localizedValues[locale.languageCode]?['gameTitle'] ?? 'Defense Game';
  String get startGame => _localizedValues[locale.languageCode]?['startGame'] ?? 'Start Game';
  String get gameDescription => _localizedValues[locale.languageCode]?['gameDescription'] ?? 'Tap to defeat enemies!';

  // 게임 UI
  String score(int score) => (_localizedValues[locale.languageCode]?['score'] ?? 'Score: {score}').replaceAll('{score}', score.toString());
  String get gameOver => _localizedValues[locale.languageCode]?['gameOver'] ?? 'Game Over!';
  String get tapToRestart => _localizedValues[locale.languageCode]?['tapToRestart'] ?? 'Tap to restart';

  // 스킬 이름
  String get lightningSkill => _localizedValues[locale.languageCode]?['lightningSkill'] ?? 'Lightning';
  String get freezeSkill => _localizedValues[locale.languageCode]?['freezeSkill'] ?? 'Freeze';
  String get healSkill => _localizedValues[locale.languageCode]?['healSkill'] ?? 'Heal';

  // 스킬 설명
  String get lightningSkillDesc => _localizedValues[locale.languageCode]?['lightningSkillDesc'] ?? 'Full screen damage';
  String get freezeSkillDesc => _localizedValues[locale.languageCode]?['freezeSkillDesc'] ?? 'Reduce enemy speed by 50%';
  String get healSkillDesc => _localizedValues[locale.languageCode]?['healSkillDesc'] ?? 'Restore 30 HP';
  String get wave => _localizedValues[locale.languageCode]?['wave'] ?? 'Wave';
  String get nextWaveIn => _localizedValues[locale.languageCode]?['nextWaveIn'] ?? 'Next Wave In';

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'gameTitle': 'Defense Game',
      'startGame': 'Start Game',
      'gameDescription': 'Tap to defeat enemies!',
      'score': 'Score: {score}',
      'gameOver': 'Game Over!',
      'tapToRestart': 'Tap to restart',
      'lightningSkill': 'Lightning',
      'freezeSkill': 'Freeze',
      'healSkill': 'Heal',
      'lightningSkillDesc': 'Strikes 5 random enemies',
      'freezeSkillDesc': 'Reduce enemy speed by 50%',
      'healSkillDesc': 'Restore 30 HP',
      'wave': 'Wave',
      'nextWaveIn': 'Next Wave In',
      'skill.fireball.title': 'Fireball',
      'skill.chain_lightning.title': 'Chain Lightning',
      'skill.ice_wall.title': 'Ice Wall',
    },
    'ko': {
      'gameTitle': '디펜스 게임',
      'startGame': '게임 시작',
      'gameDescription': '화면을 터치하여 적을 처치하세요!',
      'score': '점수: {score}',
      'gameOver': '게임 오버!',
      'tapToRestart': '탭하여 재시작',
      'lightningSkill': '번개',
      'freezeSkill': '얼음',
      'healSkill': '힐',
      'lightningSkillDesc': '무작위 적 5명 타격',
      'freezeSkillDesc': '적 이동 속도 50% 감소',
      'healSkillDesc': '기지 HP 30 회복',
      'wave': '웨이브',
      'nextWaveIn': '다음 웨이브까지',
      'skill.fireball.title': '화염구',
      'skill.chain_lightning.title': '연쇄 번개',
      'skill.ice_wall.title': '얼음 벽',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
