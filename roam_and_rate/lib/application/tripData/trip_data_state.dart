import 'package:roam_and_rate/data/local/database.dart';

class TripDataState {
  final List<Expense> expenses;
  final List<Rating> ratings;

  const TripDataState({this.expenses = const [], this.ratings = const []});

  TripDataState copyWith({List<Expense>? expenses, List<Rating>? ratings}) {
    return TripDataState(
      expenses: expenses ?? this.expenses,
      ratings: ratings ?? this.ratings,
    );
  }
}
