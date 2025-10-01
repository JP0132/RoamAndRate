abstract class CurrencyEvent {}

class FetchConversionRate extends CurrencyEvent {
  final String expenseId;
  final String base;
  final String target;
  final double value;

  FetchConversionRate(this.expenseId, this.base, this.target, this.value);
}
