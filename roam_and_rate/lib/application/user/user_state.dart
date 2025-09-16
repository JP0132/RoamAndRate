import 'package:roam_and_rate/domain/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class AdminUserFetched extends UserState {
  final UserModel adminUser;
  AdminUserFetched(this.adminUser);
}

class UserAdded extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
