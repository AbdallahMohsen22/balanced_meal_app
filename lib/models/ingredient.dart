class Ingredient {
  final String id;
  final String foodName;
  final int calories;
  final String imageUrl;
  final String category;
  int quantity;

  Ingredient({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.imageUrl,
    required this.category,
    this.quantity = 0,
  });

  // Add proper copy method
  Ingredient.copy(Ingredient other)
      : id = other.id,
        foodName = other.foodName,
        calories = other.calories,
        imageUrl = other.imageUrl,
        category = other.category,
        quantity = other.quantity;
}