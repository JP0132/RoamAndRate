import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/mappers/participant_mappers.dart';
import 'package:roam_and_rate/data/local/tables/participants.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import '../database.dart';

part 'participant_dao.g.dart';

@DriftAccessor(tables: [Participants])
class ParticipantDao extends DatabaseAccessor<AppDatabase>
    with _$ParticipantDaoMixin {
  ParticipantDao(super.db);

  Future<List<Participant>> getAllParticipants() => select(participants).get();

  Stream<List<Participant>> watchAllParticipant() =>
      select(participants).watch();

  Future<void> insertParticipant(ParticipantsCompanion participant) =>
      into(participants).insert(participant);

  Future<void> deleteParticipant(String id) => (delete(
    participants,
  )..where((participantTbl) => participantTbl.id.equals(id))).go();

  Future<void> updateParticipant(ParticipantModel participant) {
    return (update(participants)
          ..where((tbl) => tbl.id.equals(participant.id!)))
        .write(participant.toCompanion());
  }
}
