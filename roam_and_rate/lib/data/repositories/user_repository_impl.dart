import 'package:roam_and_rate/data/local/daos/participant_dao.dart';
import 'package:roam_and_rate/data/local/daos/user_dao.dart';
import 'package:roam_and_rate/data/local/mappers/participant_mappers.dart';
import 'package:roam_and_rate/data/local/mappers/user_mappers.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDao dao;
  final ParticipantDao participantDao;

  UserRepositoryImpl(this.dao, this.participantDao);

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

    final participant = ParticipantModel(
      particpantName: user.username,
      isAdmin: true,
      createdAt: DateTime.now(),
    );
    await participantDao.insertParticipant(participant.toCompanion());
  }

  @override
  Future<void> deleteUser(String id) async {
    await dao.deleteUser(id);
  }
  
  @override
  Future<UserModel> fetchAdminUser() async{
    final users = await dao.getAllUsers(); 
    final adminUser = users.firstWhere((user) => user.admin == true);
    return adminUser.toModel();
  }
}
