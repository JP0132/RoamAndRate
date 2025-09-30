import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRate {
  final double mid;
  final String base;
  final String target;

  CurrencyRate({required this.mid, required this.base, required this.target});

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return CurrencyRate(
      mid: data['mid'].toDouble(),
      base: data['base'],
      target: data['target'],
    );
  }
}

Future<CurrencyRate?> getExchangeRate(String base, String target) async {
  final url = Uri.parse(
    'https://hexarate.paikama.co/api/rates/latest/$base?target=$target',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CurrencyRate.fromJson(jsonData);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Network error: $e');
  }

  return null;
}

double convertAmount(double amount, CurrencyRate rate) {
  return amount * rate.mid;
}

// Global cache to track failures per currency pair
final Map<String, int> _failureCount = {};

Future<String?> fetchRate(String base, String target, double value) async {
  final key = "$base-$target";

  // Stop retrying after 2 failures
  if (_failureCount[key] != null && _failureCount[key]! >= 2) {
    print("Stopped retrying $key after 2 failures.");
    return null;
  }

  try {
    final rate = await getExchangeRate(
      base.toUpperCase(),
      target.toUpperCase(),
    );

    if (rate != null) {
      final converted = convertAmount(value, rate);
      return converted.toStringAsFixed(2);
    } else {
      throw Exception("Failed to fetch rate");
    }
  } catch (e) {
    _failureCount[key] = (_failureCount[key] ?? 0) + 1; // Track failures
    print("Error fetching $key (Attempt ${_failureCount[key]})");
    return null;
  }
}
