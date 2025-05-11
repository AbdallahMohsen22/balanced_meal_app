import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:balanced_meal/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/routing/routes.dart';
import '../core/theming/colors.dart';
import '../core/theming/styles.dart';
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

  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _apiService.placeOrder(widget.order);

      if (success) {
        // Navigate back to home on success
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total price based on the quantities and fixed $12 price per item
    double totalPrice = widget.order.items.fold(0, (sum, item) => sum + (item.quantity * 12));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order summary'),
        titleTextStyle: TextStyles.font20BlackBold,
        backgroundColor: ColorsManager.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
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
                                // Fallback if image fails to load
                                return Container(
                                  width: 80.w,
                                  height: 80.h,
                                  color: Colors.grey.shade200,
                                  child: Icon(Icons.fastfood, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Food details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  _buildCircularButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      // Decrement functionality would go here
                                    },
                                    color: Colors.deepOrange,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      '${item.quantity}',
                                      style: TextStyles.font16BlackBold,
                                    ),
                                  ),
                                  _buildCircularButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      // Increment functionality would go here
                                    },
                                    color: Colors.deepOrange,
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
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  // Calories info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cals',
                        style: TextStyles.font16BlackBold,
                      ),
                      Text(
                        '${widget.order.totalCalories} Cal out of ${widget.userProfile.dailyCalories.toInt()} Cal',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Price info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: TextStyles.font16BlackBold,
                      ),
                      Text(
                        '\$ ${totalPrice.toInt()}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.deepOrange,
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
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: Text(
                        'Confirm',
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
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: color,
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