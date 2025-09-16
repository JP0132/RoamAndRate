import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/domain/repositories/user_repository.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  StreamSubscription<List<UserModel>>? _subscription;

  UserBloc(this.repository) : super(UserInitial()) {
    // Listen to DB changes
    on<AddUser>(_onAddUser);
    on<DeleteUser>(_onDeleteUser);
    on<FetchAdminUser>(_onFetchAdminUser);

    _subscription = repository.watchUsers().listen(
      (users) {
        add(_UsersUpdated(users));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );

    // Internal event that just updates state
    on<_UsersUpdated>((event, emit) {
      emit(UserLoaded(event.users));
    });
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      await repository.addUser(event.user);
      emit(UserAdded());
    } catch (e) {
      emit(UserError("Failed to add user: $e"));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await repository.deleteUser(event.userId);
      // stream auto-updates
    } catch (e) {
      emit(UserError("Failed to delete user: $e"));
    }
  }

  Future<void> _onFetchAdminUser(FetchAdminUser event, Emitter<UserState> emit) async {
    try {
      final adminUser = await repository.fetchAdminUser();
      emit(AdminUserFetched(adminUser));
    } catch (e) {
      emit(UserError("Failed to fetch admin user: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// Internal event (not exposed to UI)
class _UsersUpdated extends UserEvent {
  final List<UserModel> users;
  _UsersUpdated(this.users);
}
