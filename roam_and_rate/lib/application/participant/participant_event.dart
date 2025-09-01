import 'package:roam_and_rate/domain/models/participant_model.dart';

abstract class ParticipantEvent {}

class AddParticipant extends ParticipantEvent {
  final ParticipantModel participant;
  AddParticipant(this.participant);
}

class DeleteParticipant extends ParticipantEvent {
  final String participantId;
  DeleteParticipant(this.participantId);
}

class ParticipantsUpdated extends ParticipantEvent {
  final List<ParticipantModel> participants;
  ParticipantsUpdated(this.participants);
}

class EditParticipant extends ParticipantEvent {
  final ParticipantModel participant;
  EditParticipant(this.participant);
}
