import 'dart:math';

import 'package:roam_and_rate/core/utils/constants/currency_data.dart';

int toMinor(String value, String currency) {
  int decimalDigits = CurrencyData.getCurrencyDecimalDigits(currency);
  final factor = pow(10, decimalDigits);
  final numeric = value.replaceAll(RegExp(r'[^\d.-]'), '');
  return (double.parse(numeric) * factor).round();
}


double toMajor(int value, String currency)  {
    int decimalDigits = CurrencyData.getCurrencyDecimalDigits(currency);
    return (value / pow(10, decimalDigits));
}

String getExpenseDisplay(int value, String currency){
  int decimalDigits = CurrencyData.getCurrencyDecimalDigits(currency);
  final major =  toMajor(value, currency);

  return major.toStringAsFixed(decimalDigits);

}