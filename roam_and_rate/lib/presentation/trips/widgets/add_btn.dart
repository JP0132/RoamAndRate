import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';

class AddBtn extends StatelessWidget {
  final TripModel tripDetails;
  final String btnText;
  final VoidCallback? onPressed;
  const AddBtn({
    super.key,
    required this.tripDetails,
    required this.btnText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: custom.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.add, fontWeight: FontWeight.bold, color:  custom.primaryText),
            Text(btnText, style: TextStyle(fontWeight: FontWeight.bold, color: custom.primaryText)),
          ],
        ),
      ),
    );
  }
}
