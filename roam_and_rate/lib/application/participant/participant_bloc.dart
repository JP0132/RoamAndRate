import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_event.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/repositories/participant_repository.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  final ParticipantRepository _repository;
  StreamSubscription<List<ParticipantModel>>? _subscription;

  ParticipantBloc(this._repository) : super(ParticipantLoading()) {
    _subscription = _repository.watchParticipants().listen(
      (participants) {
        print("📢 Stream emitted ${participants.length} participants");
        add(ParticipantsUpdated(participants));
      },
      onError: (error) {
        print("❌ Stream error: $error");
        addError(error, StackTrace.current);
      },
    );

    on<AddParticipant>(_onAddParticipant);
    on<DeleteParticipant>(_onDeleteParticipant);

    on<ParticipantsUpdated>((event, emit) {
      emit(ParticipantLoaded(event.participants));
    });
  }

  Future<void> _onAddParticipant(
    AddParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      await _repository.addParticipant(event.participant);
      // rely on the stream → no emit needed
    } catch (e) {
      emit(ParticipantError("Failed to add participant: $e"));
    }
  }

  Future<void> _onDeleteParticipant(
    DeleteParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      await _repository.deleteParticipant(event.participantId);
      // rely on the stream → no emit needed
    } catch (e) {
      emit(ParticipantError("Failed to delete participant: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
