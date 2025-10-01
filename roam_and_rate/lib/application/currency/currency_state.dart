abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {
  CurrencyLoading();
}

class CurrencyLoaded extends CurrencyState {
  final Map<String, String>
  conversions; // key: expenseId, value: converted amount
  CurrencyLoaded(this.conversions);
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}
