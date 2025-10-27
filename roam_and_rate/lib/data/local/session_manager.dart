import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  String? userId;

  String? lastSyncTime;

  bool? backupToDB;

  // Map<String, String>? serverData;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    lastSyncTime = prefs.getString('lastSyncTime');
    backupToDB = prefs.getBool("backupToDB");
  }

  Future<void> setServerData(String serverAddress, String portNo) async {
    print("⚠️ ⚠️ ⚠️  Getting the data $serverAddress $portNo");
    final Map<String, String> serverData = {
      "serverAddress": serverAddress,
      "portNo": portNo,
    };

    final serverDataEncode = jsonEncode(serverData);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("serverData", serverDataEncode);
  }

  Future<Map<String, String>?> getServerData() async {
    final prefs = await SharedPreferences.getInstance();
    final serverDataEncoded = prefs.getString("serverData");

    // No data saved yet
    if (serverDataEncoded == null) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(serverDataEncoded);

      // Convert dynamic map into Map<String, String>
      final Map<String, String> serverData = decoded.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      return serverData;
    } catch (e) {
      print("Failed to decode server data: $e");
      return null;
    }
  }

  Future<void> setBackupToDB(bool backingUp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("backupToDB", backingUp);
  }

  Future<void> setUserId(String id) async {
    userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  Future<void> setLastSyncTime(DateTime newSyncTime) async {
    lastSyncTime = newSyncTime.toIso8601String();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastSyncTime", lastSyncTime!);
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
