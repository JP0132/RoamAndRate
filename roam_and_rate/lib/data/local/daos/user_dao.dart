import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/tables/users.dart';
import '../database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<List<User>> getAllUsers() => select(users).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<void> deleteUser(String id) =>
      (delete(users)..where((userTbl) => userTbl.id.equals(id))).go();
}
