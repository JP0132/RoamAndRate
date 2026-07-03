import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';

class SyncService {
  Timer? _timer;
  String? lastSyncTime = SessionManager().lastSyncTime;
  final db = AppDatabase.instance;

  void startSyncTimer() {
    print("⏰⏰⏰⏰ timer started");
    _timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      syncToServer();
    });
  }

  void stopSyncTimer() {
    _timer?.cancel();
  }

  Future<void> syncToServer() async {
    lastSyncTime = null;
    if (lastSyncTime == null) {
      print("⏰⏰⏰⏰ sync started");

      try {
        final unsyncedTrips = await (db.select(db.trips)).get();
        final unsyncedExpenses = await (db.select(db.expenses)).get();
        final unsyncedParticipants = await (db.select(db.participants)).get();
        final unsyncedRatingDetails = await (db.select(db.ratingDetails)).get();
        final unsyncedRatingsMade = await (db.select(db.ratingsMade)).get();
        final unsyncedUsers = await (db.select(db.users)).get();

        print("⏰⏰⏰⏰ got the unsynced data");

        final payload = {
          "trips": unsyncedTrips.map((t) => t.toJson()).toList(),
          "expenses": unsyncedExpenses.map((e) => e.toJson()).toList(),
          "participants": unsyncedParticipants.map((p) => p.toJson()).toList(),
          "ratingDetails": unsyncedRatingDetails
              .map((rd) => rd.toJson())
              .toList(),
          "ratingsMade": unsyncedRatingsMade.map((rm) => rm.toJson()).toList(),
          "users": unsyncedUsers.map((u) => u.toJson()).toList(),
        };

        print("⏰⏰⏰⏰ created the payload");

        final serverAddress = await SessionManager().getServerData();

        await http.post(
          Uri.parse(
            "${serverAddress!["serverAddress"]}:${serverAddress["portNo"]}/sync",
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        );

        print("⏰⏰⏰⏰ post request made");

        await SessionManager().setLastSyncTime(DateTime.now());
      } catch (e) {
        print("$e");
      }
    } else {
      print("⏰⏰⏰⏰ sync timer is not null");

      DateTime? syncTime = DateTime.parse(lastSyncTime!);
    }
  }
}
