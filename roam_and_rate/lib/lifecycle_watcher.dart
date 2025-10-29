import 'package:flutter/material.dart';
import 'package:roam_and_rate/data/remote/sync_service.dart';


class LifecycleWatcher extends StatefulWidget {
  final Widget child;
  const LifecycleWatcher({Key? key, required this.child}) : super(key: key);

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  final SyncService _syncService = SyncService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print('📤 App is closing or going to background — syncing...');
      _syncService.syncToServer();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
