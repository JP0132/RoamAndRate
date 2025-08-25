import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/tables/expenses.dart';
import '../database.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  Future<void> insertExpense(ExpensesCompanion expense) =>
      into(expenses).insert(expense);

  Future<void> deleteExpense(String id) =>
      (delete(expenses)..where((expenseTbl) => expenseTbl.id.equals(id))).go();

  Future<List<Expense>> getExpensesByTripId(String id) => (select(
    expenses,
  )..where((expenseTbl) => expenseTbl.tripId.equals(id))).get();
}
