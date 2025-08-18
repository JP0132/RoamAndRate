import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Users extends Table {
  TextColumn get id =>
      text().clientDefault(() => const Uuid().v4())(); // default UUID
  TextColumn get fullName => text()();
  DateTimeColumn get dob => dateTime().nullable()();
  TextColumn get gender => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
