import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/tables/ratings_made.dart';

class TripDataState {
  final List<Expense> expenses;
  final List<RatingDetail> ratings;
  final List<RatingsMadeData> ratingsMade;

  const TripDataState({
    this.expenses = const [],
    this.ratings = const [],
    this.ratingsMade = const [],
  });

  TripDataState copyWith({
    List<Expense>? expenses,
    List<RatingDetail>? ratings,
    List<RatingsMadeData>? ratingsMade,
  }) {
    return TripDataState(
      expenses: expenses ?? this.expenses,
      ratings: ratings ?? this.ratings,
      ratingsMade: ratingsMade ?? this.ratingsMade,
    );
  }
}
