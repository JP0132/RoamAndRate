import 'package:roam_and_rate/data/local/daos/participant_dao.dart';
import 'package:roam_and_rate/data/local/mappers/participant_mappers.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/repositories/participant_repository.dart';

class ParticipantRepositoryImpl implements ParticipantRepository {
  final ParticipantDao dao;

  ParticipantRepositoryImpl(this.dao);

  @override
  Future<void> addParticipant(ParticipantModel participant) async {
    await dao.insertParticipant(participant.toCompanion());
  }

  @override
  Future<void> deleteParticipant(String id) async {
    await dao.deleteParticipant(id);
  }

  @override
  Future<List<ParticipantModel>> getParticipants() async {
    final participants = await dao.getAllParticipants();
    return participants.map((participant) => participant.toModel()).toList();
  }

  @override
  Stream<List<ParticipantModel>> watchParticipants() {
    return dao.watchAllParticipant().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Future<void> editParticipant(ParticipantModel participant) async {
    await dao.updateParticipant(participant);
  }
}
