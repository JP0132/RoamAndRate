import 'package:flutter/material.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/models/trip_model.dart';
import 'package:roam_and_rate/pages/trips/view_trip.dart';
import 'package:roam_and_rate/widgets/smooth_transition_page.dart';
import 'package:roam_and_rate/widgets/trip_cards.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<TripModel> cards = [
    TripModel(
      tripName: "Dad Holiday",
      location: "Porto, Portugal",
      startDate: DateTime(2025, 9, 3),
      endDate: DateTime(2025, 9, 10),
      backgroundColor: CustomColours.cardColourBlue,
      budget: 7000,
    ),
    TripModel(
      tripName: "Double Wedding",
      location: "Lisbon, Portugal",
      startDate: DateTime(2024, 7, 3),
      endDate: DateTime(2024, 7, 10),
      backgroundColor: CustomColours.darkSecondary,
      budget: 4000,
    ),
    TripModel(
      tripName: "First Time Back Lisbon",
      location: "Lisbon, Portugal",
      startDate: DateTime(2023, 7, 3),
      endDate: DateTime(2023, 7, 10),
      backgroundColor: CustomColours.darkError,
      budget: 4000,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Trips")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...cards.map(
              (card) => InkWell(
                onTap:
                    () => {
                      Navigator.pushNamed(
                        context,
                        AppRouter.viewTrip,
                        arguments: ViewTripArguments(tripDetails: card),
                      ),
                    },
                child: TripCards(tripModel: card),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
