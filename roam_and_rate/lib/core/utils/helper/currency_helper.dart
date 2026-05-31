// optimized_currency_helper.dart
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';

class CurrencyHelper {
  static final CurrencyHelper _instance = CurrencyHelper._internal();
  factory CurrencyHelper() => _instance;
  CurrencyHelper._internal();

  final SessionManager _sessionManager = SessionManager();
  final Map<String, Future<String?>> _pendingRequests = {};
  final Map<String, String> _resultCache = {};

  Future<String?> getConvertedAmount({
    required String base,
    required String target,
    required double value,
  }) async {
    final cacheKey = "${base}_${target}_$value";
    print('✅ getConvertedAmount: $cacheKey');

    if (_resultCache.containsKey(cacheKey)) {
      print('✅ Returning cached result: ${_resultCache[cacheKey]}');
      return _resultCache[cacheKey];
    }

    if (_pendingRequests.containsKey(cacheKey)) {
      print('✅ Returning pending request for: $cacheKey');
      return _pendingRequests[cacheKey];
    }

    print('✅ Creating new request for: $cacheKey');
    final request = _performConversion(base, target, value);
    _pendingRequests[cacheKey] = request;

    final result = await request;
    _pendingRequests.remove(cacheKey);

    if (result != null) {
      _resultCache[cacheKey] = result;
      print('✅ Cached new result: $result');
    } else {
      print('❌ Conversion failed for: $cacheKey');
    }

    return result;
  }

  Future<String?> _performConversion(
    String base,
    String target,
    double value,
  ) async {
    try {
      print('✅ Checking session manager for rate: $base -> $target');
      double? rate = await _sessionManager.getRate(base, target);

      if (rate == null) {
        print('✅ Fetching new rate from API: $base -> $target');
        final currencyRate = await getExchangeRate(base, target);
        if (currencyRate != null) {
          rate = currencyRate.mid;
          print('✅ Saving new rate: $rate');
          await _sessionManager.saveRate(base, target, rate);
        } else {
          print('❌ API returned null for $base -> $target');
          return null;
        }
      } else {
        print('✅ Using cached rate: $rate');
      }

      final converted = convertAmount(value, rate).toStringAsFixed(2);
      print('✅ Converted $value $base to $converted $target');
      return converted;
    } catch (e) {
      print('❌ Error in _performConversion: $e');
      return null;
    }
  }

  // Clear cache if needed (e.g., when currency rates might have changed)
  void clearCache() {
    _resultCache.clear();
    _pendingRequests.clear();
  }

  // Preload common conversions
  Future<void> preloadCommonRates(List<String> bases, String target) async {
    for (final base in bases) {
      // This will cache the rates in SessionManager
      await getConvertedAmount(base: base, target: target, value: 1.0);
    }
  }
}
