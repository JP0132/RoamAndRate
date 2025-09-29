import 'package:drift/drift.dart';
import 'package:roam_and_rate/core/utils/helper/string_list_converter.dart';
import 'package:roam_and_rate/data/local/tables/participants.dart';
import 'package:roam_and_rate/data/local/tables/trips.dart';
import 'package:uuid/uuid.dart';

class Expenses extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get tripId =>
      text().references(Trips, #id)(); // Foriegn Key Many to 1
  TextColumn get participantId =>
      text().references(Participants, #id)(); // Many to 1
  BoolColumn get toBeSplit => boolean()();
  TextColumn get expenseName => text()();
  TextColumn get category => text()();
  RealColumn get paid => real()();
  RealColumn get cost => real()();
  TextColumn get currency => text()();
  DateTimeColumn get datePaid => dateTime()();
  DateTimeColumn get dateAdded => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get images => text().nullable()();
  TextColumn get type => text()();
  TextColumn get tags => text().map(const StringListConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
