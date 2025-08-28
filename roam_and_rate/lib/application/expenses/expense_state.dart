import 'package:roam_and_rate/domain/models/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseAdded extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> trips;
  ExpenseLoaded(this.trips);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}
