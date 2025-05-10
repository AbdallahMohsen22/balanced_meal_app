import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.whiteButtonColor,
  );
  static TextStyle font48WhiteBold = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeightHelper.extraBold,
    color: ColorsManager.whiteButtonColor,
    fontFamily: 'Abhaya Libre'
  );
  static TextStyle font20WhiteBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.light,
    color: const Color(0xFFDADADA),
  );
  static TextStyle font20BlackBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.blackColor,
  );
  static TextStyle font14GreyBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.greyColor,
  );
  static TextStyle font14BlackSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Color(0xFF1E1E1E),
  );
  static TextStyle font16WhiteBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.whiteColor,
  );
  static TextStyle font16HintColor = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.lightGreyColor,
    fontFamily: "Questrial"
  );

}
