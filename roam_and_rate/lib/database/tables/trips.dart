import 'package:drift/drift.dart';
import 'package:roam_and_rate/database/tables/users.dart';
import 'package:uuid/uuid.dart';

class Trips extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get tripName => text()();
  TextColumn get location => text()();
  TextColumn get currency => text()();
  RealColumn get budget => real()();
  TextColumn get category => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get images => text().nullable()();
  TextColumn get bgColour => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}
