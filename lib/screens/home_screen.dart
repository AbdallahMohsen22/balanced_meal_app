import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:balanced_meal/core/routing/routes.dart';
import 'package:balanced_meal/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theming/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                child: PrimaryButton(
                  buttonWidth: 327,
                  buttonText: 'Order Food',
                  textStyle: TextStyles.font16WhiteBold,
                  onPressed: () {
                    context.pushNamed(Routes.userInfoScreen);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
