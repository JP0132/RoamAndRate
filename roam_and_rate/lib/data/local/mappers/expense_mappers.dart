import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';

import 'package:drift/drift.dart';

extension ExpenseEntityMapper on Expense {
  ExpenseModel toModel() {
    return ExpenseModel(
      name: expenseName,
      expenseId: id,
      tripId: tripId,
      paid: paid,
      cost: cost,
      dateTimeAdded: dateAdded,
      datePaid: datePaid,
      currency: currency,
      category: category,
      type: type,
      tags: tags,
      participantId: participantId,
      toBeSplit: toBeSplit,
      image: images!,
      notes: notes!,
      lastUpdated: lastUpdated
    );
  }
}

extension ExpenseModelMapper on ExpenseModel {
  ExpensesCompanion toCompanion() {
    return ExpensesCompanion.insert(
      id: expenseId != null ? Value(expenseId!) : const Value.absent(),
      tripId: tripId,
      participantId: participantId,
      expenseName: name,
      category: category,
      paid: paid,
      cost: cost,
      currency: currency,
      datePaid: datePaid,
      dateAdded: dateTimeAdded,
      type: type,
      tags: tags,
      notes: Value(notes),
      images: Value(image),
      toBeSplit: toBeSplit,
    );
  }
}
