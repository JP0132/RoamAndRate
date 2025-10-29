import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
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
          "${serverAddress!["serverAddress"]}:${serverAddress["portNo"]}/getUsersData",
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
            //_newDb = true;
          });
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
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showCancelDialog();
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int? selectedIndex; // track selected backup

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CustomColours.darkSurface,
              title: const Text("Do you want to start fresh?"),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Text(
                  "No backup will be restored, you will start with a empty database.",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, // disable button if nothing selected
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      SmoothTransitionPage(context, EnterUserDetails()),
                  child: const Text('Start New'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // TODO: Create the endpoint in fastapi and handle the restoring here.
  Future<void> _restoreBackup(Map<String, dynamic> userData) async {
    try {
      // final serverAddress = await _sessionManager.getServerData();

      // final response = await http.post(
      //   Uri.parse(
      //     '${serverAddress!["serverAddress"]}:${serverAddress["portNo"]}/restore',
      //   ),
      // );

      // if (response.statusCode == 200) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Backup restored successfully")),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Failed to restore backup")),
      //   );
      // }

      UserModel user = UserModel(
        fullName: userData["fullName"],
        username: userData["username"],
        dob: DateTime.parse(userData["dob"]),
        gender: userData["gender"],
        admin: userData["admin"],
        userId: userData["id"],
      );

      List<dynamic> tripsData = userData["trips"];
      List<dynamic> participantData = userData["participants"];

      List<TripModel> trips = [];
      List<ParticipantModel> participants = [];
      List<ExpenseModel> expenses = [];
      List<RatingsMadeModel> ratingsMade = [];
      List<RatingDetailsModel> ratingDetails = [];

      for (var t in tripsData) {
        print("⚠️ ⚠️ ⚠️$t");
        print('${t['tripName']} - ${t['location']}');

        TripModel currentTrip = TripModel(
          tripId: t["id"],
          userId: userData["id"],
          tripName: t["tripName"],
          location: t["location"],
          currency: t["currency"],
          backgroundColor: t["bgColour"],
          budget: t["budget"],
          category: t["category"],
          createdAt: DateTime.parse(t["createdAt"]),
          startDate: DateTime.parse(t["startDate"]),
          endDate: DateTime.parse(t["endDate"]),
          lastUpdated: DateTime.parse(t["lastUpdated"]),
        );
        trips.add(currentTrip);

        List<dynamic> expensesData = t["expenses"];
        List<dynamic> ratingDetailsData = t["ratingDetails"];

        if (expensesData.isNotEmpty) {
          for (var e in expensesData) {
            ExpenseModel currentExpense = ExpenseModel(
              expenseId: e["id"],
              name: e["expenseName"],
              tripId: t["id"],
              participantId: e["participantId"],
              paid: e["paid"],
              cost: e["cost"],
              dateTimeAdded: e["dateAdded"],
              datePaid: e["datePaid"],
              currency: e["currency"],
              toBeSplit: e[""],
              category: e["category"],
              type: e["paymentType"],
              notes: e["notes"],
              image: e["images"],
              tags: e["tags"],
              lastUpdated: e["lastUpdated"],
            );

            expenses.add(currentExpense);
          }
        }

        if (ratingDetailsData.isNotEmpty) {
          for (var rd in ratingDetailsData) {
            RatingDetailsModel currentRD = RatingDetailsModel(
              id: rd["id"],
              tripId: t["id"],
              placeName: rd["ratingName"],
              location: rd["location"],
              category: rd["category"],
              status: rd["status"],
              createdAt: rd["createdAt"],
              tags: rd["tags"],
              image: rd["images"],
              value: rd["value"],
              dateVisited: rd["dateVisited"],
              datePlanned: rd["datePlanned"],
              lastUpdated: rd["lastUpdated"]
            );


            ratingDetails.add(currentRD);

            if (rd["ratingsMade"].isNotEmpty) {
              for (var rm in rd["ratingsMade"]) {
                RatingsMadeModel currentRM = RatingsMadeModel(
                  particpantId: rm["participantId"],
                  ratingDetailsId: rd["id"],
                  createdAt: rm["createdAt"],
                  rating: rm["rating"],
                  expectedRating: rm["expectedRating"],
                  lastUpdated: rm["lastUpdated"],
                );

                ratingsMade.add(currentRM);

              }
            }
          }
        }
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
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No backup has been found!",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          SmoothTransitionPage(context, EnterUserDetails()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColours.darkPrimary,
                        foregroundColor: CustomColours.darkBackground,
                        padding: EdgeInsets.all(8.0),
                      ),
                      child: Text(
                        "Start fresh",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
