import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChevronToggle extends StatelessWidget {
  final bool isExpanded;

  const ChevronToggle({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0.0, // 0.25 = 90 degrees
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: FaIcon(FontAwesomeIcons.chevronRight, size: 20),
    );
  }
}