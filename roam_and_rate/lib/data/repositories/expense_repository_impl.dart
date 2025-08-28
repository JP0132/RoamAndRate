import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/mappers/expense_mappers.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDao dao;

  ExpenseRepositoryImpl(this.dao);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await dao.insertExpense(expense.toCompanion());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await dao.deleteExpense(id);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final trips = await dao.getAllExpenses();
    return trips.map((trip) => trip.toModel()).toList();
  }

  @override
  Stream<List<ExpenseModel>> watchExpenses() {
    return dao.watchAllExpenses().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }
}
