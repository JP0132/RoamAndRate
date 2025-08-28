import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/rating/rating_event.dart';
import 'package:roam_and_rate/application/rating/rating_state.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';
import 'package:roam_and_rate/domain/repositories/rating_repository.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _repository;
  StreamSubscription<List<RateModel>>? _subscription;

  RatingBloc(this._repository) : super(RatingInitial()) {
    on<AddRating>(_onAddRating);
    on<DeleteRating>(_onDeleteRating);

    _subscription = _repository.watchRatings().listen(
      (ratings) {
        add(_RatingsUpdated(ratings));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );
    on<_RatingsUpdated>((event, emit) {
      emit(RatingLoaded(event.ratings));
    });
  }

  Future<void> _onAddRating(AddRating event, Emitter<RatingState> emit) async {
    try {
      await _repository.addRating(event.rating);
      emit(RatingAdded());
    } catch (e) {
      emit(RatingError("Failed to add rating: $e"));
    }
  }

  Future<void> _onDeleteRating(
    DeleteRating event,
    Emitter<RatingState> emit,
  ) async {
    try {
      await _repository.deleteRating(event.ratingId);
      // stream auto-updates
    } catch (e) {
      emit(RatingError("Failed to delete rating: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _RatingsUpdated extends RatingEvent {
  final List<RateModel> ratings;
  _RatingsUpdated(this.ratings);
}
