import 'package:roam_and_rate/data/local/database.dart';

abstract class TripDataEvent {}

class StartWatchingTrip extends TripDataEvent {
  final String tripId;
  StartWatchingTrip(this.tripId);
}

class TripExpensesUpdated extends TripDataEvent {
  final List<Expense> expenses;
  TripExpensesUpdated(this.expenses);
}

class TripRatingsUpdated extends TripDataEvent {
  final List<RatingDetail> ratings;
  TripRatingsUpdated(this.ratings);
}
