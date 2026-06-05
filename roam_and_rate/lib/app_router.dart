import 'package:flutter/material.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/pages/new_add_expense_page.dart';
import 'package:roam_and_rate/presentation/expenses/pages/edit_expense_page.dart';
import 'package:roam_and_rate/presentation/get_started/pages/connect_to_database_page.dart';
import 'package:roam_and_rate/presentation/get_started/pages/enter_user_details.dart';
import 'package:roam_and_rate/presentation/get_started/pages/get_started.dart';
import 'package:roam_and_rate/presentation/navigation/navigation_page.dart';
import 'package:roam_and_rate/presentation/onboarding/pages/onboarding_page.dart';
import 'package:roam_and_rate/presentation/ratings/pages/add_rating.dart';
import 'package:roam_and_rate/presentation/ratings/pages/edit_rating.dart';
import 'package:roam_and_rate/presentation/settings/pages/participant_page.dart';
import 'package:roam_and_rate/presentation/settings/pages/sync_settings.dart';
import 'package:roam_and_rate/presentation/settings/pages/user_details_page.dart';
import 'package:roam_and_rate/presentation/splash/splash_page.dart';
import 'package:roam_and_rate/presentation/trips/pages/add_trip_page.dart';
import 'package:roam_and_rate/presentation/trips/pages/edit_trip_page.dart';
import 'package:roam_and_rate/presentation/trips/pages/view_trip.dart';

class ViewTripArguments {
  final TripModel tripDetails;

  ViewTripArguments({required this.tripDetails});
}

class EditTripArguments {
  final TripModel tripDetails;
  EditTripArguments({required this.tripDetails});
}

class AddExpenseArguments {
  final TripModel tripDetails;
  final List<ParticipantModel> participants;

  AddExpenseArguments({required this.participants, required this.tripDetails});
}

class EditExpenseArugments {
  final ExpenseModel expense;
  EditExpenseArugments({required this.expense});
}

class AddRatingArguments {
  final String tripId;

  AddRatingArguments({required this.tripId});
}

class EditRatingArguments {
  final RatingDetailsModel rating;
  final RatingsMadeModel? ratingMade;
  final Map<String, Map<String, double>>? participantRatings;
  EditRatingArguments({
    required this.rating,
    this.ratingMade,
    this.participantRatings,
  });
}

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String enterUserDetails = '/enterUserDetails';
  static const String getStarted = '/getStarted';
  static const String addTrip = '/addTrip';
  static const String editTrip = '/editTrip';
  static const String viewTrip = '/viewTrip';
  static const String addRating = '/addRating';
  static const String addExpense = '/addExpense';
  static const String participantSettings = '/participantSettings';
  static const String editExpense = '/editExpense';
  static const String editRating = '/editRating';
  static const String userDetails = '/userDetails';
  static const String connectToDB = "/connectToDB";
  static const String syncSettings = "/syncSettings";

  static Route<dynamic> generateRoute(RouteSettings selectedRoute) {
    switch (selectedRoute.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => CustomBottomNavbar());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case connectToDB:
        return MaterialPageRoute(builder: (_) => ConnectToDatabasePage());
      case enterUserDetails:
        return MaterialPageRoute(builder: (_) => EnterUserDetails());
      case getStarted:
        return MaterialPageRoute(builder: (_) => GetStarted());
      case addTrip:
        return MaterialPageRoute(builder: (_) => AddTripPage());
      case editTrip:
        final args = selectedRoute.arguments as EditTripArguments;
        return MaterialPageRoute(
          builder: (_) => EditTripPage(tripDetails: args.tripDetails),
        );
      case addRating:
        final args = selectedRoute.arguments as AddRatingArguments;
        return MaterialPageRoute(
          builder: (_) => AddRatingPage(tripId: args.tripId),
        );
      case editRating:
        final args = selectedRoute.arguments as EditRatingArguments;
        return MaterialPageRoute(
          builder: (_) => EditRatingPage(
            rating: args.rating,
            ratingMade: args.ratingMade,
            participantRatings: args.participantRatings,
          ),
        );
      case addExpense:
        final args = selectedRoute.arguments as AddExpenseArguments;
        return MaterialPageRoute(
          builder: (_) => AddExpensePage(tripDetails: args.tripDetails, participants: args.participants,),
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
      case userDetails:
        return MaterialPageRoute(builder: (_) => UserDetailsPage());
      case syncSettings:
        return MaterialPageRoute(builder: (_) => SyncSettings());

      default:
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
