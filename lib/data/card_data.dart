// lib/data/card_data.dart
//
// Defines the data structures for the card system.
// - `CardType` and `CardRank` enums categorize cards.
// - `CardDefinition` represents the static data of a card loaded from assets,
//   including its ID, localization keys, and the dynamic effects/risks it carries.

enum CardType { stat, skillUpgrade, skillVariant, utility, ruleBreak, cursed }

enum CardRank { normal, bronze, silver, gold, platinum, diamond, master }

/// Represents a single card definition loaded from JSON.
class CardDefinition {
  final String cardId;
  final CardRank rank;
  final CardType type;
  final String titleLocaleKey;
  final String descriptionLocaleKey;

  // Generic effect parameters, can be parsed further based on CardType
  final Map<String, dynamic> effect;

  // Optional: Conditions for variants or special cards
  final Map<String, dynamic>? condition;

  // Optional: Risk parameters for cursed cards
  final Map<String, dynamic>? risk;

  CardDefinition({
    required this.cardId,
    required this.rank,
    required this.type,
    required this.titleLocaleKey,
    required this.descriptionLocaleKey,
    required this.effect,
    this.condition,
    this.risk,
  });

  factory CardDefinition.fromJson(Map<String, dynamic> json) {
    return CardDefinition(
      cardId: json['cardId'],
      rank: CardRank.values.firstWhere(
        (e) => e.toString().split('.').last == json['rank'],
      ),
      type: CardType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      titleLocaleKey: json['titleLocaleKey'],
      descriptionLocaleKey: json['descriptionLocaleKey'],
      effect: Map<String, dynamic>.from(json['effect']),
      condition: json['condition'] != null
          ? Map<String, dynamic>.from(json['condition'])
          : null,
      risk: json['risk'] != null
          ? Map<String, dynamic>.from(json['risk'])
          : null,
    );
  }
}
