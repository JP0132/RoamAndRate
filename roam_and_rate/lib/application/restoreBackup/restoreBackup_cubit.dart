// restore_backup_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restoreBackup_state.dart';

class RestoreBackupCubit extends Cubit<RestoreBackupState> {
  RestoreBackupCubit() : super(const RestoreBackupInitial());

  Future<void> restoreBackup(Map<String, dynamic> userData) async {
    emit(const RestoreBackupLoading());

    try {
      emit(const RestoreBackupSuccess());
    } catch (e) {
      emit(RestoreBackupError(e.toString()));
    }
  }
}
