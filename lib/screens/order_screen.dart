import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import '../core/routing/routes.dart';
import '../core/theming/colors.dart';
import '../core/theming/styles.dart';
import '../core/widgets/ingredient_card.dart';
import '../models/ingredient.dart';
import '../models/user_profile.dart';
import '../models/order.dart';
import '../services/firebase_service.dart';
import 'summary_screen.dart';

class OrderScreen extends StatefulWidget {
  final UserProfile userProfile;

  const OrderScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Ingredient> _meatIngredients = [];
  List<Ingredient> _vegetableIngredients = [];
  List<Ingredient> _carbIngredients = [];
  List<Ingredient> _selectedIngredients = [];
  int _totalCalories = 0;
  int _totalPrice = 0;
  bool _isLoading = true;

  String _selectedCategory = 'Vegetables';
  final List<String> _categories = ['Vegetables', 'Meats', 'Carbs'];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _meatIngredients = await _firebaseService.fetchIngredients('meat');
      _vegetableIngredients = await _firebaseService.fetchIngredients('vegetable');
      _carbIngredients = await _firebaseService.fetchIngredients('carb');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading ingredients: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void _updateTotalCalories() {
  //   int totalCal = 0;
  //   int totalPrice = 0;
  //
  //   for (var ingredient in _selectedIngredients) {
  //     totalCal += ingredient.totalCalories;
  //     totalPrice += ingredient.price * ingredient.quantity;
  //   }
  //
  //   setState(() {
  //     _totalCalories = totalCal;
  //     _totalPrice = totalPrice;
  //   });
  // }

  void _updateSelectedIngredients() {
    _selectedIngredients = [
      ..._meatIngredients.where((i) => i.quantity > 0),
      ..._vegetableIngredients.where((i) => i.quantity > 0),
      ..._carbIngredients.where((i) => i.quantity > 0),
    ];
    //_updateTotalCalories();
  }

  void _onQuantityChanged(Ingredient ingredient, int quantity) {
    setState(() {
      ingredient.quantity = quantity;
      _updateSelectedIngredients();
    });
  }

  bool get _isWithinCalorieRange {
    double lowerLimit = widget.userProfile.dailyCalories * 0.9;
    double upperLimit = widget.userProfile.dailyCalories * 1.1;
    return _totalCalories >= lowerLimit && _totalCalories <= upperLimit;
  }

  double get _caloriePercentage {
    return _totalCalories / widget.userProfile.dailyCalories;
  }

  List<Ingredient> _getCurrentCategoryIngredients() {
    switch (_selectedCategory) {
      case 'Vegetables':
        return _vegetableIngredients;
      case 'Meats':
        return _meatIngredients;
      case 'Carbs':
        return _carbIngredients;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create your order'),
        titleTextStyle: TextStyles.font20BlackBold,
        backgroundColor: ColorsManager.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            context.pushNamed(Routes.userInfoScreen);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Category selector
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.green.shade700)
                          : null,
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.green.shade700 : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Selected category title
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedCategory,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Ingredient horizontal list
          Container(
            height: 220,
            padding: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _getCurrentCategoryIngredients().length,
              itemBuilder: (context, index) {
                final ingredient = _getCurrentCategoryIngredients()[index];
                return HorizontalIngredientCard(
                  ingredient: ingredient,
                  onQuantityChanged: (quantity) {
                    _onQuantityChanged(ingredient, quantity);
                  },
                );
              },
            ),
          ),

          // Spacer
          const Spacer(),

          // Bottom calorie and price info
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_totalCalories Cal out of ${widget.userProfile.dailyCalories.toInt()} Cal',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isWithinCalorieRange ? Colors.black : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$ $_totalPrice',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selectedIngredients.isNotEmpty
                        ? () {
                      final order = Order(
                        items: _selectedIngredients,
                        totalCalories: _totalCalories,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SummaryScreen(
                            order: order,
                            userProfile: widget.userProfile,
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Place order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalIngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final Function(int) onQuantityChanged;

  const HorizontalIngredientCard({
    Key? key,
    required this.ingredient,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(ingredient.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.foodName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '12 Cal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '\$12',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onQuantityChanged(ingredient.quantity + 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        minimumSize: const Size(60, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        ingredient.quantity > 0 ? 'Added' : 'Add',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}