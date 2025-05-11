import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:balanced_meal/core/helpers/spacing.dart';
import 'package:balanced_meal/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/routing/routes.dart';
import '../core/theming/colors.dart';
import '../core/theming/styles.dart';
import '../models/ingredient.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class SummaryScreen extends StatefulWidget {
  final Order order;
  final UserProfile userProfile;

  const SummaryScreen({
    Key? key,
    required this.order,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  late Order _editableOrder;

  @override
  void initState() {
    super.initState();
    // Create a proper copy of the original order
    _editableOrder = Order.copy(widget.order);
  }

  Future<void> _submitOrder() async {
    if (_isLoading) return; // Prevent multiple submissions

    setState(() => _isLoading = true);

    try {
      final success = await _apiService.placeOrder(_editableOrder);

      if (success) {
        // Don't modify the existing order, just navigate
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const UserInfoScreen()),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order could not be processed. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
      print('Order submission error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateItemQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _editableOrder.items[index].quantity = newQuantity;
      } else {
        _editableOrder.items.removeAt(index);
      }
      _editableOrder.totalCalories = _calculateTotalCalories();
    });
  }

  int _calculateTotalCalories() {
    return _editableOrder.items.fold(
      0,
          (sum, item) => sum + (item.calories * item.quantity),
    );
  }

  double get _totalPrice {
    return _editableOrder.items.fold(
      0,
          (sum, item) => sum + (item.quantity * 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Summary'),
        titleTextStyle: TextStyles.font20BlackBold,
        backgroundColor: ColorsManager.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: _editableOrder.items.isEmpty
                ? Center(
              child: Text(
                'No items in order',
                style: TextStyles.font14GreyColorRegular,
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _editableOrder.items.length,
              itemBuilder: (context, index) {
                final item = _editableOrder.items[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        // Food image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            item.imageUrl,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80.w,
                                height: 80.h,
                                color: Colors.grey.shade200,
                                child: Icon(Icons.fastfood,
                                    color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // Food details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.foodName,
                                style: TextStyles.font16BlackBold,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${item.calories * item.quantity} Cal',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Price and quantity controls
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${(item.quantity * 12)}',
                              style: TextStyles.font16BlackBold,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onPressed: () =>
                                      _updateItemQuantity(
                                          index, item.quantity - 1),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w),
                                  child: Text(
                                    '${item.quantity}',
                                    style: TextStyles.font16BlackBold,
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onPressed: () =>
                                      _updateItemQuantity(
                                          index, item.quantity + 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Summary section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Calories info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Calories',
                      style: TextStyles.font16BlackBold,
                    ),
                    Text(
                      '${_editableOrder.totalCalories} Cal',
                      style: TextStyles.font14GreyColorRegular,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Price info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyles.font16BlackBold,
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Confirm button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _isLoading || _editableOrder.items.isEmpty
                        ? null
                        : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading || _editableOrder.items.isEmpty
                          ? Colors.grey.shade300
                          : ColorsManager.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                        : Text(
                      'Confirm Order',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
        onPressed: onPressed,
      ),
    );
  }
}