import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';


class SyncService {
  Timer? _timer;
  final lastSyncTime = SessionManager().lastSyncTime;
  final db = AppDatabase.instance;
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'default_url';
  final portnumber = dotenv.env['PORT_NUMBER'] ?? 8000;

  void startSyncTimer(){
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      syncToServer();
    });
  }

  void stopSyncTimer(){
    _timer?.cancel();
  }

  Future<void> syncToServer() async{
    DateTime? syncTime =  DateTime.parse(lastSyncTime!);

    if(syncTime == null){
      final unsyncedTrips = await(db.select(db.trips)).get();
      final unsyncedExpenses = await(db.select(db.expenses)).get();
      final unsyncedParticipants = await(db.select(db.participants)).get();
      final unsyncedRatingDetails = await(db.select(db.ratingDetails)).get();
      final unsyncedRatingsMade = await(db.select(db.ratingsMade)).get();
      final unsyncedUsers = await(db.select(db.users)).get();

      final payload = {
        "trips": unsyncedTrips.map((t) => t.toJson()).toList(),
        "expenses": unsyncedExpenses.map((e) => e.toJson()).toList(),
        "participants": unsyncedParticipants.map((p) => p.toJson()).toList(),
        "ratingDetails": unsyncedRatingDetails.map((rd) => rd.toJson()).toList(),
        "ratingsMade": unsyncedRatingsMade.map((rm) => rm.toJson()).toList(),
        "users": unsyncedUsers.map((u) => u.toJson()).toList(),
      };

      await http.post(
        Uri.parse("$baseUrl:$portnumber/sync"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      await SessionManager().setLastSyncTime(DateTime.now());

 
    }else{
      
    }

  }
}