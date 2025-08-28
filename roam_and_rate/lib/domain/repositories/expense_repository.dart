import 'package:roam_and_rate/domain/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseModel>> getExpenses();
  Stream<List<ExpenseModel>> watchExpenses();
  Future<void> addExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}
