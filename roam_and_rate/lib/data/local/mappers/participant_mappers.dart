import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:drift/drift.dart';

extension ParticipantEntityMapper on Participant {
  ParticipantModel toModel() {
    return ParticipantModel(
      id: id,
      particpantName: name,
      isAdmin: isMainUser,
      createdAt: createdAt,
      lastUpdated: lastUpdated
    );
  }
}

extension ParticipantModelMapper on ParticipantModel {
  ParticipantsCompanion toCompanion() {
    return ParticipantsCompanion.insert(
      name: particpantName,
      id: id != null ? Value(id!) : const Value.absent(),
      isMainUser: Value(isAdmin),
      createdAt: createdAt,
    );
  }
}
