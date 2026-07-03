import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';

const Map<int, String> ratingDescriptions = {
  10: 'Stellar',
  9: 'Great',
  8: 'V. good',
  7: 'Good',
  6: 'Fine',
  5: 'Average',
  4: 'Bad',
  3: 'Very Bad',
  2: 'Horrible',
  1: 'Avoid',
};

class Helperfunctions {
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNavBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  static String getRatingDescription(int rating) {
    return ratingDescriptions[rating] ?? 'Unrated';
  }

  static IconData? getCatIcon(String category) {
    for (CategoryModel c in Categories.categories) {
      if (c.name == category) {
        return c.icon;
      }
    }
    return FontAwesomeIcons.question;
  }

  static String getParticipantName(List<ParticipantModel> participants, String participantId){
    return participants.firstWhere((p) => p.id == participantId).particpantName;
  }
}
