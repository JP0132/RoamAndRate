import 'package:roam_and_rate/data/local/daos/user_dao.dart';
import 'package:roam_and_rate/data/local/mappers/user_mappers.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDao dao;

  UserRepositoryImpl(this.dao);

  @override
  Future<List<UserModel>> getUsers() async {
    final users = await dao.getAllUsers();
    return users.map((e) => e.toModel()).toList();
  }

  @override
  Stream<List<UserModel>> watchUsers() {
    return dao.watchAllUsers().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Future<void> addUser(UserModel user) async {
    await dao.insertUser(user.toCompanion());
  }

  @override
  Future<void> deleteUser(String id) async {
    await dao.deleteUser(id);
  }
}
