class Ingredient {
  final String foodName;
  final int calories;
  final String imageUrl;
  int quantity;
  final String category;

  Ingredient({
    required this.foodName,
    required this.calories,
    required this.imageUrl,
    this.quantity = 0,
    required this.category,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json, String category) {
    return Ingredient(
      foodName: json['food_name'],
      calories: json['calories'],
      imageUrl: json['image_url'],
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': foodName,
      'total_price': calories, // Using calories as price for simplicity
      'quantity': quantity,
    };
  }

  int get totalCalories => calories * quantity;
}