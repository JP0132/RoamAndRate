import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/models/trip_model.dart';
import 'package:roam_and_rate/widgets/expense_card.dart';
import 'package:roam_and_rate/widgets/rating_cards.dart';
import 'package:roam_and_rate/widgets/swipeable_card_stack.dart';
import 'package:roam_and_rate/widgets/trip_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: Center(child: Text("Home"))),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SwipeableStack(
            cards: [...cards.map((card) => TripCards(tripModel: card))],
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Ratings"), Text("View All")],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: RatingCards(
                name: "Vasco de Gama",
                rating: 10,
                dateRated: DateTime.now(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Transactions"), Text("View All")],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ExpenseCard(
                transactionName: "Vasco de Gama",
                paid: 56.95,
                datePaid: DateTime.now(),
                type: 'Card',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
