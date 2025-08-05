import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/models/trip_model.dart';

bool isBetweenInclusive(DateTime target, DateTime start, DateTime end) {
  return (target.isAtSameMomentAs(start) || target.isAfter(start)) &&
      (target.isAtSameMomentAs(end) || target.isBefore(end));
}

String getTripStatus(DateTime startDate, DateTime endDate) {
  DateTime currentDate = DateTime.now();
  if (isBetweenInclusive(currentDate, startDate, endDate)) {
    return "CURRENT TRIP";
  }

  if (startDate.isAfter(currentDate)) {
    return "UPCOMING TRIP";
  }

  return "FINISHED TRIP";
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: widget.tripModel.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getTripStatus(widget.tripModel.startDate, widget.tripModel.endDate)}: ${widget.tripModel.tripName}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Text('Balance', style: TextStyle(color: Colors.white)),
              Text(
                "${widget.tripModel.budget}",
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FROM: ${DateFormat('dd/MM/yyyy').format(widget.tripModel.startDate)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "EXP: ${DateFormat('dd/MM/yyyy').format(widget.tripModel.endDate)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
