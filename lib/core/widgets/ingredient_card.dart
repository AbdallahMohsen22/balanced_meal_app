import 'package:balanced_meal/balanced_meal_app.dart';
import 'package:balanced_meal/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                fit: BoxFit.contain,
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
            padding:  EdgeInsets.only(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        ingredient.foodName,
                        style:  TextStyles.font14BlackSemiBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        '${ingredient.calories} cal',
                        style:  TextStyles.font14GreyColorRegular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$12',
                        style: TextStyles.font16BlackBold,
                      ),

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
                      Row(
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              'assets/images/remove.svg',
                              height: 18.h,
                              width: 18.w,
                            ),
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
                            icon: SvgPicture.asset(
                              'assets/images/add.svg',
                              height: 18.h,
                              width: 18.w,
                            ),
                            onPressed: () => onQuantityChanged(ingredient.quantity + 1),
                          ),
                        ],
                      ),

                    ],
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