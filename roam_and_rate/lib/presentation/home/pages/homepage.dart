import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_state.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_state.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/application/user/user_event.dart';
import 'package:roam_and_rate/application/user/user_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/domain/repositories/user_repository.dart';
import 'package:roam_and_rate/presentation/widgets/common/expense_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/rating_cards.dart';
import 'package:roam_and_rate/presentation/home/widgets/swipeable_card_stack.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _expandedExpenses = false;
  bool _expandedRatings = false;

  @override
  void initState() {
    super.initState();
    context.read<RatingsBloc>().add(FetchRatingsAndDetails());
    //context.read<UserBloc>().add(FetchAdminUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home"))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  // Check if we have any users
                  if (state.users.isEmpty) {
                    return const Text("No users found");
                  }

                  // Find the admin user
                  try {
                    final adminUser = state.users.firstWhere(
                      (user) => user.admin == true,
                    );
                    SessionManager().setUserId(adminUser.userId!);
                    return Text("Welcome, ${adminUser.username}");
                  } catch (e) {
                    return const Text("No admin user found");
                  }
                } else if (state is UserError) {
                  return Text("Error: ${state.message}");
                } else {
                  return const Text("Something went wrong!");
                }
              },
            ),

            BlocBuilder<TripBloc, TripState>(
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
                    print("What I am testing ${state.trips.first.userId}");
                    return SwipeableStack(
                      cards: [
                        ...state.trips.map(
                          (card) => TripCards(tripModel: card),
                        ),
                      ],
                    );
                  }
                } else if (state is TripError) {
                  return Text("Error: ${state.message}");
                } else {
                  return const Text("Something went wrong!");
                }
              },
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Expenses"), Text("View All")],
            ),
            SizedBox(height: 20),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoaded) {
                  if (state.expenses.isEmpty) {
                    return Text("No Expenses found");
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final visibleExpenses = _expandedExpenses
                          ? state.expenses
                          : state.expenses.take(3);
                      return Column(
                        children: [
                          ...visibleExpenses.map(
                            (expense) => ExpenseCard(
                              transactionName: expense.name,
                              type: expense.type,
                              datePaid: expense.datePaid,
                              paid: expense.paid,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is ExpenseError) {
                  return Text("Error: ${state.message}");
                } else {
                  return const Text("Something went wrong!");
                }
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Ratings"), Text("View All")],
            ),
            SizedBox(height: 20),
            BlocBuilder<RatingsBloc, RatingsState>(
              builder: (context, state) {
                if (state is RatingInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RatingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RatingsAndDetailsLoaded) {
                  if (state.ratingDetails.isEmpty) {
                    return Text("No Ratings Made");
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final visibleRating = _expandedRatings
                          ? state.ratingDetails
                          : state.ratingDetails.take(3);

                      return Column(
                        children: [
                          ...visibleRating.map(
                            (rating) => RatingCards(
                              name: rating.placeName,
                              ratingsMade: state.ratingsMade
                                  .where(
                                    (rm) => rm.ratingDetailsId == rating.id,
                                  )
                                  .map((e) => e)
                                  .toList(),
                              dateRated: rating.dateVisited!,
                              category: rating.category,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is RatingError) {
                  return Text("Error: ${state.message}");
                } else {
                  return const Text("Something went wrong!");
                }
              },
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [Text("Ratings"), Text("View All")],
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: RatingCards(
            //       name: "Vasco de Gama",
            //       rating: 10,
            //       dateRated: DateTime.now(),
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [Text("Transactions"), Text("View All")],
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ExpenseCard(
            //       transactionName: "Vasco de Gama",
            //       paid: 56.95,
            //       datePaid: DateTime.now(),
            //       type: 'Card',
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
