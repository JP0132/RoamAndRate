import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class TagWidget extends StatelessWidget {
  final String label;

  const TagWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: custom.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(label, style: TextStyle(color: custom.background)),
    );
  }
}
