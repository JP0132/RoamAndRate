import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';
import 'package:roam_and_rate/application/expenses/expense_state.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/repositories/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  StreamSubscription<List<ExpenseModel>>? _subscription;

  ExpenseBloc(this._repository) : super(ExpenseInitial()) {
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<EditExpense>(_onEditExpense);
    

    _subscription = _repository.watchExpenses().listen(
      (expenses) {
        add(_ExpensesUpdated(expenses));
      },
      onError: (error) {
        addError(error, StackTrace.current);
      },
    );
    on<_ExpensesUpdated>((event, emit) {
      emit(ExpenseLoaded(event.expenses));
    });
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      print("📢 Stream emitted ${event.expense.participantId} participants");
      await _repository.addExpense(event.expense);
      emit(ExpenseAdded());
    } catch (e) {
      emit(ExpenseError("Failed to add expense: $e"));
    }
  }

  Future<void> _onEditExpense(
    EditExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      print("📢 Stream emitted ${event.expense} EXPENSES");
      await _repository.editExpense(event.expense);
      emit(ExpenseEdited());
    } catch (e) {
      emit(ExpenseError("Failed to edit expense: $e"));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.deleteExpense(event.expenseId);
      // stream auto-updates
    } catch (e) {
      emit(ExpenseError("Failed to delete expense: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _ExpensesUpdated extends ExpenseEvent {
  final List<ExpenseModel> expenses;
  _ExpensesUpdated(this.expenses);
}
