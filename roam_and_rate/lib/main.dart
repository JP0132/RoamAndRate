import 'package:flutter/material.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/themes/theme.dart';
import 'package:roam_and_rate/pages/navigation/navigation_page.dart';
import 'package:roam_and_rate/pages/onboarding/onboarding_page.dart';
import 'package:roam_and_rate/pages/splash/splash_page.dart';
import 'package:roam_and_rate/pages/trips/add_trip_page.dart';
import 'package:roam_and_rate/pages/trips/view_trip.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomAppTheme.lightTheme,
      darkTheme: CustomAppTheme.darkTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
