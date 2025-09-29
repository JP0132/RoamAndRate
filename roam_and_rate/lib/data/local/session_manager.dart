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
}
