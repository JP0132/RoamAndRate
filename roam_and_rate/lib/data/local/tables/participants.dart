import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:roam_and_rate/data/local/tables/users.dart';


class Participants extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get name => text()();
  BoolColumn get isMainUser => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();


  @override
  Set<Column> get primaryKey => {id};
}
