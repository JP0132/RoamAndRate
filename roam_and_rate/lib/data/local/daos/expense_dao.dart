import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/mappers/expense_mappers.dart';
import 'package:roam_and_rate/data/local/tables/expenses.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import '../database.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  Stream<List<Expense>> watchByTrip(String tripId) {
    return (select(expenses)..where((t) => t.tripId.equals(tripId))).watch();
  }

  Future<void> insertExpense(ExpensesCompanion expense) {
      print("🤯🤯🤯🤯🤯🤯 ${expense.targetPaidAmountMinor.toString()}");
      return into(expenses).insert(expense);
  }

  Future<void> deleteExpense(String id) =>
      (delete(expenses)..where((expenseTbl) => expenseTbl.id.equals(id))).go();

  Future<void> updateExpense(ExpenseModel expense) {
    return (update(expenses)..where((tbl) => tbl.id.equals(expense.expenseId!)))
        .write(expense.toCompanion());
  }

  Future<List<Expense>> getExpensesByTripId(String id) => (select(
    expenses,
  )..where((expenseTbl) => expenseTbl.tripId.equals(id))).get();
}
