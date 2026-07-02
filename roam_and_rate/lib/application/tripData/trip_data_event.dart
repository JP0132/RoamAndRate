import 'package:roam_and_rate/data/local/database.dart';

abstract class TripDataEvent {}

class StartWatchingTrip extends TripDataEvent {
  final String tripId;
  StartWatchingTrip(this.tripId);
}

class ProcessPendingConversions extends TripDataEvent {
  final String tripId;
  ProcessPendingConversions(this.tripId);
}

class TripExpensesUpdated extends TripDataEvent {
  final List<Expense> expenses;
  TripExpensesUpdated(this.expenses);
}

class TripRatingsUpdated extends TripDataEvent {
  final List<RatingDetail> ratings;
  TripRatingsUpdated(this.ratings);
}

class TripRatingsMadeUpdated extends TripDataEvent {
  final List<RatingsMadeData> ratingsMade;
  TripRatingsMadeUpdated(this.ratingsMade);
}
