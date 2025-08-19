import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Users extends Table {
  TextColumn get id =>
      text().clientDefault(() => const Uuid().v4())(); // default UUID
  TextColumn get fullName => text()();
  DateTimeColumn get dob => dateTime()();
  TextColumn get gender => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
