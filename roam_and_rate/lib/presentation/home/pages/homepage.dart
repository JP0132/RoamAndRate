import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/application/user/user_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/domain/repositories/user_repository.dart';
import 'package:roam_and_rate/presentation/widgets/common/expense_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/rating_cards.dart';
import 'package:roam_and_rate/presentation/home/widgets/swipeable_card_stack.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';

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
      tripId: '',
    ),
    TripModel(
      tripName: "Double Wedding",
      location: "Lisbon, Portugal",
      startDate: DateTime(2024, 7, 3),
      endDate: DateTime(2024, 7, 10),
      backgroundColor: CustomColours.darkSecondary,
      budget: 4000,
      tripId: '',
    ),
    TripModel(
      tripName: "First Time Back Lisbon",
      location: "Lisbon, Portugal",
      startDate: DateTime(2023, 7, 3),
      endDate: DateTime(2023, 7, 10),
      backgroundColor: CustomColours.darkError,
      budget: 4000,
      tripId: '',
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
           BlocProvider(
              create: (context) => UserBloc(
                context.read<UserRepository>(),
              ),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserInitial) {
                      return const Center(child: CircularProgressIndicator());
                  } else if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                  } else if (state is UserLoaded) {
                      return Text("Welcome, ${state.users.first.fullName}");
                  } else if (state is UserError) {
                      return Text("Error: ${state.message}");
                  } else {
                      return const Text("Something went wrong!");
                  }
                }
              ),
            ),

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
