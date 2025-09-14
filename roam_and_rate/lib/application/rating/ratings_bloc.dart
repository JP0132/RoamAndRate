import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';

import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/domain/repositories/ratings_repository.dart';

class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  final RatingsRepository _repository;

  StreamSubscription<List<RatingDetailsModel>>? _ratingDetailsSubscription;
  StreamSubscription<List<RatingsMadeModel>>? _ratingsMadeSubscription;

  RatingsBloc(this._repository) : super(RatingInitial()) {
    on<AddRatingDetails>(_onAddRatingDetails);
    on<DeleteRatingDetails>(_onDeleteRatingDetails);
    on<EditRatingDetails>(_onEditRatingDetails);
    on<AddRatingsMade>(_onAddRatingsMade);
    on<DeleteRatingsMade>(_onDeleteRatingsMade);
    on<DeleteRating>(_onDeleteRating);
    on<EditRatingsMade>(_onEditRatingsMade);
    on<AddRatingWithParticipants>(_onAddRatingWithParticipants);
    on<EditRatingWithParticipants>(_onEditRatingWithParticipants);

    // Set up subscriptions for streaming data
    _ratingDetailsSubscription = _repository.watchRatingDetails().listen(
      (ratingDetails) {
        add(_RatingDetailsUpdated(ratingDetails));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );

    _ratingsMadeSubscription = _repository.watchRatingsMade().listen(
      (ratingsMade) {
        add(_RatingsMadeUpdated(ratingsMade));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );

    on<_RatingDetailsUpdated>((event, emit) {
      emit(RatingDetailsLoaded(event.ratingDetails));
    });

    on<_RatingsMadeUpdated>((event, emit) {
      emit(RatingsMadeLoaded(event.ratingsMade));
    });
  }

  Future<void> _onAddRatingDetails(
    AddRatingDetails event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.addRatingDetails(event.ratingDetails);
      emit(RatingDetailsAdded());
    } catch (e) {
      emit(RatingError("Failed to add rating details: $e"));
    }
  }

  Future<void> _onEditRatingDetails(
    EditRatingDetails event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.editRatingDetails(event.ratingDetails);
      emit(RatingDetailsEdited());
    } catch (e) {
      emit(RatingError("Failed to edit rating details: $e"));
    }
  }

  Future<void> _onDeleteRatingDetails(
    DeleteRatingDetails event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.deleteRatingDetails(event.ratingDetailsId);
      // stream auto-updates
    } catch (e) {
      emit(RatingError("Failed to delete rating details: $e"));
    }
  }

  Future<void> _onDeleteRating(
    DeleteRating event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.deleteRating(event.ratingDetailsId);
      // stream auto-updates
    } catch (e) {
      emit(RatingError("Failed to delete rating: $e"));
    }
  }

  Future<void> _onAddRatingsMade(
    AddRatingsMade event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.addRatingsMade(event.ratingsMade);
      emit(RatingsMadeAdded());
    } catch (e) {
      emit(RatingError("Failed to add ratings made: $e"));
    }
  }

  Future<void> _onEditRatingsMade(
    EditRatingsMade event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.editRatingsMade(event.ratingsMade);
      emit(RatingsMadeEdited());
    } catch (e) {
      emit(RatingError("Failed to edit ratings made: $e"));
    }
  }

  Future<void> _onDeleteRatingsMade(
    DeleteRatingsMade event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      await _repository.deleteRatingsMade(event.ratingsMadeId);
      // stream auto-updates
    } catch (e) {
      emit(RatingError("Failed to delete ratings made: $e"));
    }
  }

  Future<void> _onAddRatingWithParticipants(
    AddRatingWithParticipants event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      print("🚀 Bloc received AddRatingWithParticipants");
      // print("😂😂😂😂😂😂😂😂 ${event.participantRatings.entries.first.key}");
      // print("😂😂😂😂😂😂😂😂 ${event.ratingDetails.id}");

      await _repository.addRatingWithParticipants(
        event.ratingDetails,
        event.participantRatings,
      );

      print("😂😂😂😂😂😂😂😂 YOU BEST BE EMITTING");

      emit(RatingWithParticipantsAdded());
      print("😂😂😂😂😂😂😂😂 DID YOU EMIT?");
    } catch (e) {
      emit(RatingError("Failed to add rating with participants: $e"));
    }
  }

  Future<void> _onEditRatingWithParticipants(
    EditRatingWithParticipants event,
    Emitter<RatingsState> emit,
  ) async {
    try {
      print("🚀 Bloc received EditRatingWithParticipants");

      await _repository.editRatingWithParticipants(
        event.ratingDetails,
        event.participantRatings,
      );

      emit(RatingWithParticipantsEdited());
    } catch (e) {
      emit(RatingError("Failed to edit rating with participants: $e"));
    }
  }

  @override
  Future<void> close() {
    _ratingDetailsSubscription?.cancel();
    _ratingsMadeSubscription?.cancel();
    return super.close();
  }
}

class _RatingDetailsUpdated extends RatingsEvent {
  final List<RatingDetailsModel> ratingDetails;
  _RatingDetailsUpdated(this.ratingDetails);
}

class _RatingsMadeUpdated extends RatingsEvent {
  final List<RatingsMadeModel> ratingsMade;
  _RatingsMadeUpdated(this.ratingsMade);
}
