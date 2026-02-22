class ShopItem {
  final String id;
  final String name;
  final int price;
  final int amount;
  final String currencyType;
  final bool isDiscount;

  ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    required this.currencyType,
    required this.isDiscount,
  });
}