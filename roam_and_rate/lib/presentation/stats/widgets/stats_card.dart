import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class StatsCard extends StatelessWidget {
  final String valueToDisplay;
  final IconData icon;
  final String label;

  const StatsCard({
    super.key,
    required this.valueToDisplay,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CustomColours.darkPrimary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: CustomColours.darkPrimary),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColours.darkPrimary,
            ),
          ),
          Text(
            valueToDisplay,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColours.darkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}