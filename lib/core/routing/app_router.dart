import 'package:balanced_meal/core/routing/routes.dart';
import 'package:balanced_meal/screens/order_screen.dart';
import 'package:balanced_meal/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../screens/home_screen.dart';


class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
        case Routes.userInfoScreen:
        return MaterialPageRoute(
          builder: (_) => const UserInfoScreen(),
        );
        // case Routes.orderScreen:
        // return MaterialPageRoute(
        //   builder: (_) => const OrderScreen(userProfile: UserProfile()),
        // );
      default:
        return null;
    }
  }
}
