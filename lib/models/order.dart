import 'ingredient.dart';

class Order {
  final List<Ingredient> items;
  final int totalCalories;

  Order({
    required this.items,
    required this.totalCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .where((item) => item.quantity > 0)
          .map((item) => {
        'name': item.foodName,
        'total_price': item.quantity * 12, // Using fixed price of $12 per item
        'quantity': item.quantity,
      })
          .toList(),
    };
  }
}