import 'package:roam_and_rate/domain/models/user_model.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final UserModel user;
  AddUser(this.user);
}

class DeleteUser extends UserEvent {
  final String userId;
  DeleteUser(this.userId);
}
