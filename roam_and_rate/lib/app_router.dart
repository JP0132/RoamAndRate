import 'package:flutter/material.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/pages/add_expense_page.dart';
import 'package:roam_and_rate/presentation/expenses/pages/edit_expense_page.dart';
import 'package:roam_and_rate/presentation/get_started/pages/enter_user_details.dart';
import 'package:roam_and_rate/presentation/get_started/pages/get_started.dart';
import 'package:roam_and_rate/presentation/navigation/navigation_page.dart';
import 'package:roam_and_rate/presentation/onboarding/pages/onboarding_page.dart';
import 'package:roam_and_rate/presentation/ratings/pages/add_rating.dart';
import 'package:roam_and_rate/presentation/settings/pages/participant_page.dart';
import 'package:roam_and_rate/presentation/splash/splash_page.dart';
import 'package:roam_and_rate/presentation/trips/pages/add_trip_page.dart';
import 'package:roam_and_rate/presentation/trips/pages/view_trip.dart';

class ViewTripArguments {
  final TripModel tripDetails;

  ViewTripArguments({required this.tripDetails});
}

class AddExpenseArguments {
  final String tripId;

  AddExpenseArguments({required this.tripId});
}

class EditExpenseArugments {
  final ExpenseModel expense;
  EditExpenseArugments({required this.expense});
}

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String enterUserDetails = '/enterUserDetails';
  static const String getStarted = '/getStarted';
  static const String addTrip = '/addTrip';
  static const String viewTrip = '/viewTrip';
  static const String addRating = '/addRating';
  static const String addExpense = '/addExpense';
  static const String participantSettings = '/participantSettings';
  static const String editExpense = '/editExpense';

  static Route<dynamic> generateRoute(RouteSettings selectedRoute) {
    switch (selectedRoute.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => CustomBottomNavbar());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case enterUserDetails:
        return MaterialPageRoute(builder: (_) => EnterUserDetails());
      case getStarted:
        return MaterialPageRoute(builder: (_) => GetStarted());
      case addTrip:
        return MaterialPageRoute(builder: (_) => AddTripPage());
      case addRating:
        return MaterialPageRoute(builder: (_) => AddRatingPage());
      case addExpense:
        final args = selectedRoute.arguments as AddExpenseArguments;
        return MaterialPageRoute(
          builder: (_) => AddExpensePage(tripId: args.tripId),
        );
      case editExpense:
        final args = selectedRoute.arguments as EditExpenseArugments;
        return MaterialPageRoute(
          builder: (_) => EditExpensePage(expenseToEdit: args.expense),
        );
      case viewTrip:
        final args = selectedRoute.arguments as ViewTripArguments;
        return MaterialPageRoute(
          builder: (_) => ViewTrip(tripDetails: args.tripDetails),
        );
      case participantSettings:
        return MaterialPageRoute(builder: (_) => ParticipantPage());

      default:
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
