import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/presentation/get_started/pages/enter_user_details.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';

class RestoreDbBackup extends StatefulWidget {
  const RestoreDbBackup({super.key});

  @override
  State<RestoreDbBackup> createState() => _RestoreDbBackupState();
}

class _RestoreDbBackupState extends State<RestoreDbBackup> {
  bool _isChecking = true; // show spinner while checking
  bool _backUpFound = false;
  bool _newDb = false;
  final _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _checkBackupStatus();
  }

  Future<void> _checkBackupStatus() async {
    try {
      final serverAddress = await _sessionManager.getServerData();

      final response = await http.get(
        Uri.parse(
          "${serverAddress!["serverAddress"]}:${serverAddress["portNo"]}/getUsers",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> users = data['users'];
        print(users);
        if (users.isEmpty) {
          setState(() {
            _backUpFound = false;
            _isChecking = false;
            _newDb = true;
          });

          SmoothTransitionPage(context, EnterUserDetails());
        } else {
          setState(() {
            _backUpFound = true;
            _isChecking = false;
            _newDb = false;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showBackupDialog(users);
          });
        }
      } else {
        setState(() {
          _backUpFound = false;
          _isChecking = false;
        });
      }
    } catch (e) {
      // Handle network or server errors
      setState(() {
        _isChecking = false;
      });
      debugPrint("Error checking backup: $e");
    }
  }

  void _showBackupDialog(List<dynamic> users) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int? selectedIndex; // track selected backup

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CustomColours.darkSurface,
              title: const Text("Backup(s) Found"),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.separated(
                  itemCount: users.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Text(
                        "These are the backups that have been found. "
                        "Select one to restore your data.",
                      );
                    }

                    final user = users[index - 1];
                    final isSelected = selectedIndex == index - 1;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index - 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CustomColours.darkPrimary.withValues(alpha: 0.3)
                              : CustomColours.darkBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? CustomColours.darkPrimary.withValues(
                                    alpha: 0.3,
                                  )
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? CustomColours.darkPrimary.withValues(
                                      alpha: 0.3,
                                    )
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(user["username"])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: selectedIndex != null
                      ? () {
                          Navigator.pop(context);
                          _restoreBackup(users[selectedIndex!]);
                        }
                      : null, // disable button if nothing selected
                  child: const Text('Yes, Restore'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // TODO: Create the endpoint in fastapi and handle the restoring here.
  Future<void> _restoreBackup(Map<String, dynamic> user) async {
    try {
      final serverAddress = await _sessionManager.getServerData();

      final response = await http.post(
        Uri.parse(
          '${serverAddress!["serverAddress"]}:${serverAddress["portNo"]}/restore',
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Backup restored successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to restore backup")),
        );
      }
    } catch (e) {
      debugPrint("Error restoring backup: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Network error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isChecking
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text("Checking for backup..."),
                ],
              )
            : _backUpFound
            ? const Text("Backup found — waiting for user response...")
            : const Text("No backup found."),
      ),
    );
  }
}
