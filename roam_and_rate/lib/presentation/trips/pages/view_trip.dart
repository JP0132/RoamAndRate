import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/tripData/trip_data_bloc.dart';
import 'package:roam_and_rate/application/tripData/trip_data_event.dart';
import 'package:roam_and_rate/application/tripData/trip_data_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/mappers/expense_mappers.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/full_expense_card.dart';
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
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.addExpense,
                arguments: AddExpenseArguments(
                  tripId: widget.tripDetails.tripId!,
                ),
              ),
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
                  // Set<DateTime> dates = {};
                  // dates.addAll(state.expenses.map((e) => e.datePaid).toList());

                  // List<DateTime> sortedDates = dates.toList();
                  // sortedDates.sort((a, b) => a.compareTo(b));

                  // List<Expense> sortedExpenses = state.expenses;
                  // sortedExpenses.sort(
                  //   (a, b) => a.datePaid.compareTo(b.datePaid),
                  // );

                  // First get the unique sorted dates
                  final dates =
                      state.expenses
                          .map(
                            (e) => DateTime(
                              e.datePaid.year,
                              e.datePaid.month,
                              e.datePaid.day,
                            ),
                          )
                          .toSet()
                          .toList()
                        ..sort((a, b) => a.compareTo(b));

                  // Sort all expenses by date
                  final sortedExpenses = [...state.expenses]
                    ..sort((a, b) => a.datePaid.compareTo(b.datePaid));

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: dates.length,
                    itemBuilder: (context, dateIndex) {
                      final date = dates[dateIndex];

                      // All expenses for this date
                      final expensesForDate = sortedExpenses.where(
                        (e) =>
                            e.datePaid.year == date.year &&
                            e.datePaid.month == date.month &&
                            e.datePaid.day == date.day,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Date Header (shown ONCE) ---
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              DateFormat('EEEE, dd MMM yyyy').format(date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // --- All expenses under that date ---
                          ...expensesForDate.map(
                            (expense) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: FullExpenseCard(
                                expenseDetails: expense.toModel(),
                              ),
                            ),
                          ),
                        ],
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
