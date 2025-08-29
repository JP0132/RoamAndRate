import 'package:roam_and_rate/domain/models/participant_model.dart';

abstract class ParticipantState {}

class ParticipantInitial extends ParticipantState {}

class ParticipantLoading extends ParticipantState {}

class ParticipantAdded extends ParticipantState {}

class ParticipantLoaded extends ParticipantState {
  final List<ParticipantModel> participants;
  ParticipantLoaded(this.participants);
}

class ParticipantError extends ParticipantState {
  final String message;
  ParticipantError(this.message);
}
