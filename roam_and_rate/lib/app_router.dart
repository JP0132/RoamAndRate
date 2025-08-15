import 'package:flutter/material.dart';
import 'package:roam_and_rate/models/trip_model.dart';
import 'package:roam_and_rate/pages/expenses/add_expense_page.dart';
import 'package:roam_and_rate/pages/navigation/navigation_page.dart';
import 'package:roam_and_rate/pages/onboarding/onboarding_page.dart';
import 'package:roam_and_rate/pages/ratings/add_rating.dart';
import 'package:roam_and_rate/pages/splash/splash_page.dart';
import 'package:roam_and_rate/pages/trips/add_trip_page.dart';
import 'package:roam_and_rate/pages/trips/view_trip.dart';

class ViewTripArguments {
  final TripModel tripDetails;

  ViewTripArguments({required this.tripDetails});
}

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String addTrip = '/addTrip';
  static const String viewTrip = '/viewTrip';
  static const String addRating = '/addRating';
  static const String addExpense = '/addExpense';

  static Route<dynamic> generateRoute(RouteSettings selectedRoute) {
    switch (selectedRoute.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => CustomBottomNavbar());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case addTrip:
        return MaterialPageRoute(builder: (_) => AddTripPage());
      case addRating:
        return MaterialPageRoute(builder: (_) => AddRatingPage());
      case addExpense:
        return MaterialPageRoute(builder: (_) => AddExpensePage());
      case viewTrip:
        final args = selectedRoute.arguments as ViewTripArguments;
        return MaterialPageRoute(
          builder: (_) => ViewTrip(tripDetails: args.tripDetails),
        );

      default:
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
