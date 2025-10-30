// restore_backup_state.dart
part of 'restoreBackup_cubit.dart';

@immutable
abstract class RestoreBackupState {
  const RestoreBackupState();
}

class RestoreBackupInitial extends RestoreBackupState {
  const RestoreBackupInitial();
}

class RestoreBackupLoading extends RestoreBackupState {
  const RestoreBackupLoading();
}

class RestoreBackupSuccess extends RestoreBackupState {
  const RestoreBackupSuccess();
}

class RestoreBackupError extends RestoreBackupState {
  final String error;
  const RestoreBackupError(this.error);
}
