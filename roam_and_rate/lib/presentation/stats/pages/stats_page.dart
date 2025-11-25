import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_state.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/stats/widgets/expense_pie_chart.dart';
import 'package:roam_and_rate/presentation/stats/widgets/stats_card.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  String selectedTrip = "All";
  List<TripModel> _trips = [];
  List<ExpenseModel> _expenses = [];
  // (no persistent caches needed here)

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    // Ask the RatingsBloc to fetch ratings and details so the page can render stats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<RatingsBloc>().add(FetchRatingsAndDetails());
      } catch (_) {
        // ignore if bloc not provided in this context during tests
      }
      // start entrance animations
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _animatedCard(Widget child, int index, {int total = 6}) {
    final start = (index / total) * 0.6; // spread within first 60%
    final end = (start + 0.35).clamp(0.0, 1.0);
    final curved = CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOut));
    final offsetAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved);
    final opacityAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeIn)));

    return FadeTransition(
      opacity: opacityAnim,
      child: SlideTransition(position: offsetAnim, child: child),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: CustomColours.darkSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Heading
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Overview', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: CustomColours.darkPrimary)),
            ),

            // Trip selector
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 320,
                child: BlocBuilder<TripBloc, TripState>(
                  builder: (context, state) {
                    if (state is TripInitial || state is TripLoading) {
                      return const SizedBox(height: 56, child: Center(child: CircularProgressIndicator()));
                    } else if (state is TripLoaded) {
                      if (state.trips.isEmpty) {
                        return const Text("Create your first trip to get started!");
                      } else {
                        _trips = state.trips;

                        return CustomisableDropdown<String>(
                          items: ["All", ..._trips.map((e) => e.tripId!)],
                          hint: "Filter by trip",
                          value: selectedTrip,
                          backgroundColour: CustomColours.darkSurface,
                          borderColour: Colors.transparent,
                          padding: const EdgeInsets.all(14),
                          borderRadius: 12,
                          menuMaxHeight: 200,
                          selectedItemTextColour: CustomColours.darkPrimary,
                          onChanged: (value) {
                            setState(() {
                              selectedTrip = value!;
                            });
                          },
                          itemBuilder: (id) {
                            if (id == "All") return const Text("All Trips");
                            final trip = _trips.firstWhere((t) => t.tripId == id);
                            return Text(trip.tripName);
                          },
                        );
                      }
                    } else if (state is TripError) {
                      return Text('Error: ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Expenses Section
            Text('Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CustomColours.darkPrimary)),
            const SizedBox(height: 12),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseInitial || state is ExpenseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoaded) {
                  if (state.expenses.isEmpty) return Center(child: Text('No expenses found'));
                  _expenses = state.expenses;
                  if (selectedTrip != "All") {
                    _expenses = _expenses.where((expense) => expense.tripId == selectedTrip).toList();
                  }

                  double totalExpenses = _expenses.fold(0.0, (double sum, item) => sum + item.paid);
                  Map<String, double> categoryExpensesMap = {};
                  for (var expense in _expenses) {
                    categoryExpensesMap.update(expense.category, (v) => v + expense.paid, ifAbsent: () => expense.paid);
                  }

                  var maxEntry = categoryExpensesMap.entries.reduce((a, b) => a.value > b.value ? a : b);
                  var leastEntry = categoryExpensesMap.entries.reduce((a, b) => a.value < b.value ? a : b);

                  // Cards arranged responsively using Wrap
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: '\$${totalExpenses.toStringAsFixed(2)}',
                            icon: Icons.account_balance_wallet,
                            label: 'Total Spent',
                            subtitle: '${_expenses.length} transactions',
                            gradientColors: [Colors.deepPurple, Colors.purpleAccent],
                            sparklineData: _expenses.isNotEmpty
                                ? (() {
                                    final n = min(6, _expenses.length);
                                    final last = _expenses.sublist(_expenses.length - n);
                                    return last.map((e) => e.paid).toList();
                                  })()
                                : null,
                          ), 0)),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: maxEntry.key,
                            icon: Icons.trending_up,
                            label: 'Top Category',
                            subtitle: '\$${maxEntry.value.toStringAsFixed(2)}',
                            gradientColors: [Colors.indigo, Colors.cyan],
                            sparklineData: null,
                          ), 1)),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: leastEntry.key,
                            icon: Icons.trending_down,
                            label: 'Lowest Category',
                            subtitle: '\$${leastEntry.value.toStringAsFixed(2)}',
                            gradientColors: [Colors.teal, Colors.greenAccent],
                            sparklineData: null,
                          ), 2)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Spending by category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: CustomColours.darkPrimary)),
                          const SizedBox(height: 12),
                          ExpensePieChart(categoryExpensesMap: categoryExpensesMap),
                        ],
                      ),
                    ],
                  );
                } else if (state is ExpenseError) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 20),

            // Ratings Section
            Text('Ratings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CustomColours.darkPrimary)),
            const SizedBox(height: 12),
            BlocBuilder<RatingsBloc, RatingsState>(
              builder: (context, state) {
                List<RatingDetailsModel> ratingDetails = [];
                List<RatingsMadeModel> ratingsMade = [];

                if (state is RatingsAndDetailsLoaded) {
                  ratingDetails = state.ratingDetails;
                  ratingsMade = state.ratingsMade;
                } else if (state is RatingDetailsLoaded) {
                  ratingDetails = state.ratingDetails;
                } else if (state is RatingsMadeLoaded) {
                  ratingsMade = state.ratingsMade;
                } else if (state is RatingInitial || state is RatingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RatingError) {
                  return Text('Error: ${state.message}');
                }

                if (ratingDetails.isEmpty || ratingsMade.isEmpty) {
                  return Center(child: Text('No ratings found!'));
                }

                if (selectedTrip != 'All') {
                  final idsForTrip = ratingDetails.where((r) => r.tripId == selectedTrip).map((r) => r.id).toSet();
                  ratingsMade = ratingsMade.where((r) => idsForTrip.contains(r.ratingDetailsId)).toList();
                }

                final detailsById = {for (var d in ratingDetails) d.id: d};
                double sum = 0;
                int count = 0;
                final Map<String, List<double>> perPlaceRatings = {};

                for (var r in ratingsMade) {
                  final detail = detailsById[r.ratingDetailsId];
                  if (detail == null) continue;
                  final value = detail.status == 'Plan to Visit' ? r.expectedRating : r.rating;
                  sum += value;
                  count += 1;
                  perPlaceRatings.putIfAbsent(r.ratingDetailsId, () => []).add(value);
                }

                final overallAvg = count == 0 ? 0.0 : sum / count;

                final averages = perPlaceRatings.entries.map((e) => MapEntry(e.key, e.value.reduce((a, b) => a + b) / e.value.length)).toList();
                averages.sort((a, b) => b.value.compareTo(a.value));

                // rating summary cards
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: overallAvg.toStringAsFixed(2),
                            icon: Icons.star,
                            label: 'Average Rating',
                            subtitle: '${count} ratings',
                            gradientColors: [Colors.orange, Colors.deepOrangeAccent],
                            sparklineData: averages.map((e) => e.value).toList(),
                          ), 3)),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: averages.isNotEmpty ? (detailsById[averages.first.key]?.placeName ?? '-') : '-',
                            icon: Icons.emoji_events,
                            label: 'Top Place',
                            subtitle: averages.isNotEmpty ? averages.first.value.toStringAsFixed(2) : '-',
                            gradientColors: [Colors.blueGrey, Colors.blue],
                            sparklineData: averages.map((e) => e.value).toList(),
                          ), 4)),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: _animatedCard(StatsCard(
                            valueToDisplay: '${ratingDetails.length}',
                            icon: Icons.place,
                            label: 'Places Rated',
                            subtitle: '${averages.length} places',
                            gradientColors: [Colors.pink, Colors.purpleAccent],
                            sparklineData: null,
                          ), 5)),
                        ],
                      ),
                  
                      const SizedBox(height: 12),
                      // Top-rated places list
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: averages.take(5).map((e) {
                              final detail = detailsById[e.key];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(e.value.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                title: Text(detail?.placeName ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(detail?.location ?? ''),
                                trailing: Text(e.value.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w700)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}


