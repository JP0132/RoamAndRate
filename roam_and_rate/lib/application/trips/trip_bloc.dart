import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/domain/repositories/trip_repository.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository _repository;
  StreamSubscription<List<TripModel>>? _subscription;

  TripBloc(this._repository) : super(TripInitial()) {
    on<AddTrip>(_onAddTrip);
    on<DeleteTrip>(_onDeleteTrip);

    _subscription = _repository.watchTrips().listen(
      (trips) {
        add(_TripsUpdated(trips));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );
    on<_TripsUpdated>((event, emit) {
      emit(TripLoaded(event.trips));
    });
  }

  Future<void> _onAddTrip(AddTrip event, Emitter<TripState> emit) async {
    try {
      await _repository.addTrip(event.trip);
      emit(TripAdded());
    } catch (e) {
      emit(TripError("Failed to add trip: $e"));
    }
  }

  Future<void> _onDeleteTrip(DeleteTrip event, Emitter<TripState> emit) async {
    try {
      await _repository.deleteTrip(event.tripId);
      // stream auto-updates
    } catch (e) {
      emit(TripError("Failed to delete trip: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _TripsUpdated extends TripEvent {
  final List<TripModel> trips;
  _TripsUpdated(this.trips);
}
