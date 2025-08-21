import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';

extension UserEntityMapper on User {
  UserModel toModel() {
    return UserModel(userId: id, fullName: fullName, dob: dob, gender: gender);
  }
}

extension UserModelMapper on UserModel {
  UsersCompanion toCompanion() {
    return UsersCompanion.insert(
      id: userId != null ? Value(userId!) : const Value.absent(),
      fullName: fullName,
      dob: dob ?? DateTime(1970, 1, 1),
      gender: gender,
      createdAt: DateTime.now(),
    );
  }
}
