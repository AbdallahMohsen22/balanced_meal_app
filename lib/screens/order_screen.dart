import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:balanced_meal/core/helpers/spacing.dart';
import 'package:balanced_meal/core/widgets/primary_button.dart';
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
  bool _isLoading = true;
  String _selectedCategory = 'Vegetables';

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
  double get _totalPrice {
    int totalQuantity = 0;
    for (var ingredient in _selectedIngredients) {
      totalQuantity += ingredient.quantity;
    }
    return totalQuantity * 12.0;
  }

  void _updateTotalCalories() {
    int total = 0;
    for (var ingredient in [..._meatIngredients, ..._vegetableIngredients, ..._carbIngredients]) {
      total += ingredient.totalCalories;
    }
    setState(() {
      _totalCalories = total;
      _updateSelectedIngredients();
    });
  }

  void _updateSelectedIngredients() {
    _selectedIngredients = [
      ..._meatIngredients.where((i) => i.quantity > 0),
      ..._vegetableIngredients.where((i) => i.quantity > 0),
      ..._carbIngredients.where((i) => i.quantity > 0),
    ];
  }

  bool get _isWithinCalorieRange {
    double lowerLimit = widget.userProfile.dailyCalories * 0.9;
    double upperLimit = widget.userProfile.dailyCalories * 1.1;
    return _totalCalories >= lowerLimit && _totalCalories <= upperLimit;
  }

  double get _caloriePercentage {
    return _totalCalories / widget.userProfile.dailyCalories;
  }

  List<Ingredient> get _currentIngredients {
    switch (_selectedCategory) {
      case 'Meat':
        return _meatIngredients;
      case 'Vegetables':
        return _vegetableIngredients;
      case 'Carbs':
        return _carbIngredients;
      default:
        return _vegetableIngredients;
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
            child: Icon(Icons.arrow_left_outlined,
                color: Colors.black, size: 25.sp)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Main content with scrolling
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Vegetables section
                  _buildIngredientSection(
                    title: "Vegetables",
                    ingredients: _vegetableIngredients,
                  ),

                  // Meat section
                  _buildIngredientSection(
                    title: "Meat",
                    ingredients: _meatIngredients,
                  ),

                  // Carbs section
                  _buildIngredientSection(
                    title: "Carbs",
                    ingredients: _carbIngredients,
                  ),

                  // Selected items summary
                  if (_selectedIngredients.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      color: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedIngredients.length,
                              itemBuilder: (context, index) {
                                final item = _selectedIngredients[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 8.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${item.foodName} x${item.quantity}'),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '(${item.totalCalories} cal)',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),



          // Bottom calorie and price info
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cal',
                      style: TextStyles.font16BlackBold,
                    ),
                    Text(
                      '$_totalCalories Cal out of ${widget.userProfile.dailyCalories.toInt()} Cal',
                      style: TextStyles.font14GreyColorRegular,
                    ),
                  ],
                ),
                verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price',
                      style: TextStyles.font16BlackBold,
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style:  TextStyles.font16primaryColor,
                    ),
                  ],
                ),
                verticalSpace(20),
                /// Place order button (fixed at bottom)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  child: PrimaryButton(

                    onPressed: _isWithinCalorieRange
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
                        : () {},
                    buttonText: 'Place Order',
                    textStyle: _isWithinCalorieRange ?TextStyles.font16WhiteBold : TextStyles.font16lightGreyColor,
                    backgroundColor: _isWithinCalorieRange ?ColorsManager.primaryColor: ColorsManager.whiteButtonColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientSection({
    required String title,
    required List<Ingredient> ingredients,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyles.font20BlackBold,
          ),
        ),

        SizedBox(
          height: 170.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: IngredientCard(
                    ingredient: ingredients[index],
                    onQuantityChanged: (quantity) {
                      setState(() {
                        ingredients[index].quantity = quantity;
                        _updateTotalCalories();
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}