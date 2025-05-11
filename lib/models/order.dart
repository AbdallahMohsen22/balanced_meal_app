import 'ingredient.dart';

class Order {
  final List<Ingredient> items;
  int totalCalories; // Remove 'late final' and just make it mutable

  Order({
    required this.items,
    required this.totalCalories,
  });

  // Add copy constructor
  Order.copy(Order other)
      : items = other.items.map((e) => Ingredient.copy(e)).toList(),
        totalCalories = other.totalCalories;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => {
        'name': item.foodName,
        'total_price': item.quantity * 12,
        'quantity': item.quantity,
      }).toList(),
    };
  }
}