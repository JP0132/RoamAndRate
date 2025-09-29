import 'package:roam_and_rate/domain/models/participant_model.dart';

abstract class ParticipantRepository {
  Future<List<ParticipantModel>> getParticipants();
  Stream<List<ParticipantModel>> watchParticipants();
  Future<void> addParticipant(ParticipantModel participant);
  Future<void> deleteParticipant(String id);
  Future<void> editParticipant(ParticipantModel participant);
}
