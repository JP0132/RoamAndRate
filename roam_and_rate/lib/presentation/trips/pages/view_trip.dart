import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/tripData/trip_data_bloc.dart';
import 'package:roam_and_rate/application/tripData/trip_data_event.dart';
import 'package:roam_and_rate/application/tripData/trip_data_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/trips/widgets/tab_item.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/expense_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/rating_cards.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';

class ViewTrip extends StatefulWidget {
  final TripModel tripDetails;
  const ViewTrip({super.key, required this.tripDetails});

  @override
  State<ViewTrip> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {
  int _selectedIndex = 0;

  List<RateModel> _ratings = [];
  List<ExpenseModel> _expenses = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final db = AppDatabase.instance;
        return TripDataBloc(ExpenseDao(db), RatingDao(db))
          ..add(StartWatchingTrip(widget.tripDetails.tripId!));
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Trip Details")),
        body: Column(
          children: [
            TripCards(tripModel: widget.tripDetails),

            // Tab to view the expenses and ratings
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.addRating),
              child: Text("Add Rating"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.addExpense),
              child: Text("Add Expense"),
            ),
            const SizedBox(height: 12),
            // Toggle buttons (Ratings / Expenses)
            SizedBox(
              height: 40,

              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? CustomColours.darkPrimary
                              : CustomColours.darkSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Ratings",
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? CustomColours.darkSurface
                                : CustomColours.darkPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? CustomColours.darkPrimary
                              : CustomColours.darkSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Expenses",
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? CustomColours.darkSurface
                                : CustomColours.darkPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<TripDataBloc, TripDataState>(
                builder: (context, state) {
                  if (_selectedIndex == 0) {
                    if (state.ratings.isEmpty) {
                      return const Center(child: Text("No ratings yet"));
                    }
                    return ListView.builder(
                      itemCount: state.ratings.length,
                      itemBuilder: (context, index) {
                        final rating = state.ratings[index];
                        return RatingCards(
                          name: rating.placeName,
                          rating: int.parse(
                            (rating.rating! * 2).truncate() as String,
                          ),
                          dateRated: rating.dateVisited!,
                        );
                      },
                    );
                  } else {
                    if (state.expenses.isEmpty) {
                      return const Center(child: Text("No expenses yet"));
                    }
                  }
                  return ListView.builder(
                    itemCount: state.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = state.expenses[index];
                      return ExpenseCard(
                        transactionName: expense.expenseName,
                        type: expense.type,
                        datePaid: expense.datePaid,
                        paid: expense.paid,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
