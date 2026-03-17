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
    on<EditParticipant>(_onEditParticipant);
    
    on<ParticipantsUpdated>((event, emit) {
      emit(ParticipantLoaded(event.participants));
    });

    on<LoadParticipants>(_onLoadParticipants);
  }

  Future<void> _onLoadParticipants(LoadParticipants event, Emitter<ParticipantState> emit) async {
    try {
      emit(ParticipantLoading());
      final participants = await _repository.getParticipants();
      emit(ParticipantLoaded(participants));
    } catch (e) {
      emit(ParticipantError("Failed to load participants: $e"));
    } 
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

  Future<void> _onEditParticipant(
    EditParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      await _repository.editParticipant(event.participant);
      // rely on the stream → no emit needed
    } catch (e) {
      emit(ParticipantError("Failed to edit participant: $e"));
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
