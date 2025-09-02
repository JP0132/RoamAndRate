import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/tables/ratings_made.dart';

class TripDataState {
  final List<Expense> expenses;
  final List<RatingDetail> ratings;

  const TripDataState({this.expenses = const [], this.ratings = const []});

  TripDataState copyWith({
    List<Expense>? expenses,
    List<RatingDetail>? ratings,
  }) {
    return TripDataState(
      expenses: expenses ?? this.expenses,
      ratings: ratings ?? this.ratings,
    );
  }
}
