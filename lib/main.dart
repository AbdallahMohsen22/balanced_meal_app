import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'balanced_meal_app.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyATkg37PRjRSWv4znmwfyxCEvn-Uq84hHI",
        appId: "1:862746834673:android:e96f8252b0227b7b3d9b50",
        messagingSenderId: "862746834673",
        projectId: "balancedmeal-c9fa4",
      ),
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  runApp(BalancedMealApp(
    appRouter: AppRouter(),
  ));
}
