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
          .map((item) => item.toJson())
          .toList(),
    };
  }
}