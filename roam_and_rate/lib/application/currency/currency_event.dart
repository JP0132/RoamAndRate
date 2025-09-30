abstract class CurrencyEvent {}

class FetchConversionRate extends CurrencyEvent {
  final String base;
  final String target;
  final double value;

  FetchConversionRate(this.base, this.target, this.value);
}
