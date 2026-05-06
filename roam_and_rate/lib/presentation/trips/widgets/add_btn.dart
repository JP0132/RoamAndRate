import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
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
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColours.darkSurface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.add, fontWeight: FontWeight.bold),
            Text(btnText, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
