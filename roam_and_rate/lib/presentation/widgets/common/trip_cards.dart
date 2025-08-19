import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';

bool isBetweenInclusive(DateTime target, DateTime start, DateTime end) {
  return (target.isAtSameMomentAs(start) || target.isAfter(start)) &&
      (target.isAtSameMomentAs(end) || target.isBefore(end));
}

String getTripStatus(DateTime startDate, DateTime endDate) {
  DateTime currentDate = DateTime.now();
  // Trip is ongoing
  if (isBetweenInclusive(currentDate, startDate, endDate)) {
    return "assets/images/icons/direct-flight.png";
  }

  // Trip is upcoming
  if (startDate.isAfter(currentDate)) {
    return "assets/images/icons/time-left.png";
  }

  // Trip is done
  return "assets/images/icons/flag.png";
}

class TripCards extends StatefulWidget {
  final TripModel tripModel;
  const TripCards({super.key, required this.tripModel});

  @override
  State<TripCards> createState() => _TripCardsState();
}

class _TripCardsState extends State<TripCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: widget.tripModel.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.tripModel.tripName,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColours.darkPrimary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      getTripStatus(
                        widget.tripModel.startDate,
                        widget.tripModel.endDate,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            const Text('Balance', style: TextStyle(color: Colors.white)),

            SizedBox(height: 4),

            Text(
              "${widget.tripModel.budget}",
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "FROM: ${DateFormat('dd/MM/yyyy').format(widget.tripModel.startDate)}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Flexible(
                  child: Text(
                    "EXP: ${DateFormat('dd/MM/yyyy').format(widget.tripModel.endDate)}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
