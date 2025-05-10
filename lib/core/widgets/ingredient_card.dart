import 'package:balanced_meal/balanced_meal_app.dart';
import 'package:balanced_meal/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/ingredient.dart';
import '../theming/styles.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final Function(int) onQuantityChanged;

  const IngredientCard({
    Key? key,
    required this.ingredient,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsManager.whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                ingredient.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 12.h,horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ingredient.foodName,
                      style:  TextStyles.font14BlackSemiBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '12 cal',
                      style:  TextStyles.font14GreyBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${ingredient.calories} cal',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity control
                    ingredient.quantity == 0
                        ? TextButton(
                            onPressed: () => onQuantityChanged(1),
                            style: TextButton.styleFrom(
                              backgroundColor: ColorsManager.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyles.font16WhiteBold,
                            ),
                          )
                        :
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: ingredient.quantity > 0
                                ? () => onQuantityChanged(ingredient.quantity - 1)
                                : null,
                          ),
                          Text(
                            '${ingredient.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => onQuantityChanged(ingredient.quantity + 1),
                          ),
                        ],
                      ),
                    ),

                    // // Total calories
                    // if (ingredient.quantity > 0)
                    //   Text(
                    //     '${ingredient.totalCalories}',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.green.shade700,
                    //     ),
                    //   ),
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