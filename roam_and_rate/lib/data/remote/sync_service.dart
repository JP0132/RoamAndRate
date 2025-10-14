import 'dart:async';

import 'package:roam_and_rate/data/local/session_manager.dart';

class SyncService {
  Timer? _timer;
  final lastSyncTime = SessionManager().lastSyncTime;

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

    }else{
      
    }

  }
}