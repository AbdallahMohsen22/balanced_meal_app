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

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  List<Ingredient> _meatIngredients = [];
  List<Ingredient> _vegetableIngredients = [];
  List<Ingredient> _carbIngredients = [];
  List<Ingredient> _selectedIngredients = [];
  int _totalCalories = 0;
  bool _isLoading = true;
  late TabController _tabController;

  String _selectedCategory = 'Meat';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            child:  Icon(Icons.arrow_left_outlined,
                color: Colors.black, size: 25.sp)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Calorie information and progress
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Calorie Target: ${widget.userProfile.dailyCalories.toStringAsFixed(0)} cal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Selection: $_totalCalories cal (${(_caloriePercentage * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isWithinCalorieRange ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 20,
                  child: LiquidLinearProgressIndicator(
                    value: _caloriePercentage.clamp(0.0, 1.5),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(
                      _isWithinCalorieRange ? Colors.green : Colors.orange,
                    ),
                    borderRadius: 10,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),

          // Category tabs
          TabBar(
            controller: _tabController,
            labelColor: Colors.green.shade700,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Meat'),
              Tab(text: 'Vegetables'),
              Tab(text: 'Carbs'),
            ],
            onTap: (index) {
              setState(() {
                _selectedCategory = ['Meat', 'Vegetables', 'Carbs'][index];
              });
            },
          ),

          // Ingredient list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Meat tab
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _meatIngredients.length,
                  itemBuilder: (context, index) {
                    return IngredientCard(
                      ingredient: _meatIngredients[index],
                      onQuantityChanged: (quantity) {
                        setState(() {
                          _meatIngredients[index].quantity = quantity;
                          _updateTotalCalories();
                        });
                      },
                    );
                  },
                ),

                // Vegetables tab
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _vegetableIngredients.length,
                  itemBuilder: (context, index) {
                    return IngredientCard(
                      ingredient: _vegetableIngredients[index],
                      onQuantityChanged: (quantity) {
                        setState(() {
                          _vegetableIngredients[index].quantity = quantity;
                          _updateTotalCalories();
                        });
                      },
                    );
                  },
                ),

                // Carbs tab
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _carbIngredients.length,
                  itemBuilder: (context, index) {
                    return IngredientCard(
                      ingredient: _carbIngredients[index],
                      onQuantityChanged: (quantity) {
                        setState(() {
                          _carbIngredients[index].quantity = quantity;
                          _updateTotalCalories();
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Selected items summary
          if (_selectedIngredients.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Items (${_selectedIngredients.length}):',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedIngredients.length,
                      itemBuilder: (context, index) {
                        final item = _selectedIngredients[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${item.foodName} x${item.quantity}'),
                              const SizedBox(width: 4),
                              Text(
                                '(${item.totalCalories} cal)',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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

          // Place order button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
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
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                disabledBackgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}