import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_event.dart';
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
  final Function? onDelete;
  const TripCards({super.key, required this.tripModel, this.onDelete});

  @override
  State<TripCards> createState() => _TripCardsState();
}

class _TripCardsState extends State<TripCards> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(widget.tripModel.tripId ?? ''),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder(
            builder: (con) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.editTrip,
                    arguments: EditTripArguments(
                      tripDetails: widget.tripModel, 
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.pencil,
                  color: Colors.white,
                  size: 25,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              return ElevatedButton.icon(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Trip?"),
                      content: const Text(
                        "Are you sure you want to delete this trip, this action is irreversible?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<TripBloc>().add(
                              DeleteTrip(widget.tripModel.tripId!),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Trip deleted successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            widget.onDelete!(widget.tripModel.tripId);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                label: Text(""),
                icon: FaIcon(FontAwesomeIcons.trash),
              );
            },
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: widget.tripModel.backgroundColor == "red"
              ? CustomColours.darkError
              : CustomColours.darkSurface,
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
      ),
    );
  }
}
