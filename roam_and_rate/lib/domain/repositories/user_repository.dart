import '../models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Stream<List<UserModel>> watchUsers();
  Future<void> addUser(UserModel user);
  Future<void> deleteUser(String id);
}
