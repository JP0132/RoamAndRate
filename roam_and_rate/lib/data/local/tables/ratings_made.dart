import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/tables/participants.dart';
import 'package:roam_and_rate/data/local/tables/rating_details.dart';
import 'package:uuid/uuid.dart';

class RatingsMade extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get ratingDetailsId => text().references(RatingDetails, #id)();
  TextColumn get participantId => text().references(Participants, #id)();
  RealColumn get rating => real().nullable()();
  RealColumn get expectedRating => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
