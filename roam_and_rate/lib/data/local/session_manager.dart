import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  String? userId;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  Future<void> setUserId(String id) async {
    userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  Future<void> saveRate(String base, String target, double rate) async {
    final prefs = await SharedPreferences.getInstance();
    final rateKey = "$base-$target-rate";
    final timeKey = "$base-$target-time";

    await prefs.setDouble(rateKey, rate);
    await prefs.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
  }

  //  Load rate with 24-hour expiration handling
  Future<double?> getRate(String base, String target) async {
    final prefs = await SharedPreferences.getInstance();
    final rateKey = "$base-$target-rate";
    final timeKey = "$base-$target-time";

    final savedRate = prefs.getDouble(rateKey);
    final savedTime = prefs.getInt(timeKey);

    if (savedRate != null && savedTime != null) {
      final age = DateTime.now().millisecondsSinceEpoch - savedTime;

      if (age < Duration(hours: 24).inMilliseconds) {
        print("✅ Using cached rate from SessionManager for $base → $target");
        return savedRate;
      } else {
        print("⚠️ Rate expired for $base → $target, fetching new one");
        return null;
      }
    }

    return null; // Signal that we should fetch a fresh rate
  }
}
