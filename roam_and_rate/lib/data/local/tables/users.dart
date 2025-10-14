import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Users extends Table {
  TextColumn get id =>
      text().clientDefault(() => const Uuid().v4())(); // default UUID
  TextColumn get username => text()();
  TextColumn get fullName => text()();
  DateTimeColumn get dob => dateTime()();
  TextColumn get gender => text()();
  BoolColumn get admin => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();


  @override
  Set<Column> get primaryKey => {id};
}
