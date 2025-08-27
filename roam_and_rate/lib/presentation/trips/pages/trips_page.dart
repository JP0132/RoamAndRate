import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/trips/pages/view_trip.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';

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
      backgroundColor: "",
      budget: 7000,
      tripId: '',
      userId: '',
      currency: '',
      category: '',
      createdAt: DateTime.now(),
    ),
    TripModel(
      tripName: "Double Wedding",
      location: "Lisbon, Portugal",
      startDate: DateTime(2024, 7, 3),
      endDate: DateTime(2024, 7, 10),
      backgroundColor: "",
      budget: 4000,
      tripId: '',
      userId: '',
      currency: '',
      category: '',
      createdAt: DateTime.now(),
    ),
    TripModel(
      tripName: "First Time Back Lisbon",
      location: "Lisbon, Portugal",
      startDate: DateTime(2023, 7, 3),
      endDate: DateTime(2023, 7, 10),
      backgroundColor: "red",
      budget: 4000,
      tripId: '',
      userId: '',
      currency: '',
      category: '',
      createdAt: DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Trips")),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripLoaded) {
            if (state.trips.isEmpty) {
              return Center(
                child: Text("Create your first trip to get started!"),
              );
            } else {
              return ListView.separated(
                padding: EdgeInsets.all(8),
                itemCount: state.trips.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => {
                      Navigator.pushNamed(
                        context,
                        AppRouter.viewTrip,
                        arguments: ViewTripArguments(
                          tripDetails: state.trips[index],
                        ),
                      ),
                    },
                    child: TripCards(tripModel: state.trips[index]),
                  );
                },
              );
            }
          } else if (state is TripError) {
            return Text("Error: ${state.message}");
          } else {
            return const Text("Something went wrong!");
          }
        },
      ),
    );
  }
}

//  ...cards.map(
//               (card) => InkWell(
//                 onTap:
//                     () => {
//                       Navigator.pushNamed(
//                         context,
//                         AppRouter.viewTrip,
//                         arguments: ViewTripArguments(tripDetails: card),
//                       ),
//                     },
//                 child: TripCards(tripModel: card),
//               ),
//             ),
