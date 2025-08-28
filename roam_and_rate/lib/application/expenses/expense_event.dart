import 'package:roam_and_rate/domain/models/expense_model.dart';

abstract class ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;
  AddExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;
  DeleteExpense(this.expenseId);
}
