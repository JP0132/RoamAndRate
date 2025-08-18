import 'package:drift/drift.dart';
import 'package:roam_and_rate/core/utils/helper/string_list_converter.dart';
import 'package:roam_and_rate/database/tables/trips.dart';
import 'package:uuid/uuid.dart';

class Ratings extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get tripId => text().references(Trips, #id)();
  TextColumn get placeName => text()();
  TextColumn get location => text()();
  TextColumn get category => text()();
  TextColumn get status => text()();
  RealColumn get rating => real().nullable()();
  DateTimeColumn get dateVisited => dateTime().nullable()();
  DateTimeColumn get datePlanned => dateTime().nullable()();
  TextColumn get value => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get images => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();

  DateTimeColumn get createdAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}
