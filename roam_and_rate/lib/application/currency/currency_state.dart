abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final String convertedValue;
  CurrencyLoaded(this.convertedValue);
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError(this.message);
}
