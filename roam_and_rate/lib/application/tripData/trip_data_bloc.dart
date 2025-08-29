import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/tripData/trip_data_event.dart';
import 'package:roam_and_rate/application/tripData/trip_data_state.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';

class TripDataBloc extends Bloc<TripDataEvent, TripDataState> {
  final ExpenseDao expenseDao;
  final RatingDao ratingDao;

  StreamSubscription? _expenseSub;
  StreamSubscription? _ratingSub;

  TripDataBloc(this.expenseDao, this.ratingDao) : super(const TripDataState()) {
    on<StartWatchingTrip>(_onStartWatching);
    on<TripExpensesUpdated>(
      (event, emit) => emit(state.copyWith(expenses: event.expenses)),
    );
    on<TripRatingsUpdated>(
      (event, emit) => emit(state.copyWith(ratings: event.ratings)),
    );
  }

  void _onStartWatching(StartWatchingTrip event, Emitter<TripDataState> emit) {
    _expenseSub?.cancel();
    _ratingSub?.cancel();

    _expenseSub = expenseDao
        .watchByTrip(event.tripId)
        .listen((data) => add(TripExpensesUpdated(data)));
    _ratingSub = ratingDao
        .watchByTrip(event.tripId)
        .listen((data) => add(TripRatingsUpdated(data)));
  }

  @override
  Future<void> close() {
    _expenseSub?.cancel();
    _ratingSub?.cancel();
    return super.close();
  }
}
