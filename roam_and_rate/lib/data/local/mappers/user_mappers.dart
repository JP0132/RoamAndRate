import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';

extension UserEntityMapper on User {
  UserModel toModel() {
    return UserModel(
      userId: id,
      fullName: fullName,
      username: username,
      dob: dob,
      gender: gender,
      admin: admin,
      lastUpdated: lastUpdated, currency: currency,
    );
  }
}

extension UserModelMapper on UserModel {
  UsersCompanion toCompanion() {
    return UsersCompanion.insert(
      id: userId != null ? Value(userId!) : const Value.absent(),
      fullName: fullName,
      username: username,
      dob: dob ?? DateTime(1970, 1, 1),
      gender: gender,
      createdAt: DateTime.now(),
      admin: admin,
    );
  }
}
