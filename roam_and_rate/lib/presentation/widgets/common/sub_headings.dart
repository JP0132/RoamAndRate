import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class SubHeadings extends StatelessWidget {
  const SubHeadings({
    super.key,
    
    required this.custom, required this.text,
  });
  final String text;
  final CustomColours custom;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: custom.secondaryText,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
      ),
    );
  }
}
