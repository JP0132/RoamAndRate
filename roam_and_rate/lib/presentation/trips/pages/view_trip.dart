import 'dart:async';

import 'package:flutter/foundation.dart';
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
import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/mappers/expense_mappers.dart';
import 'package:roam_and_rate/data/local/mappers/rating_details_mappers.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/full_expense_card.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/full_rating_card.dart';
import 'package:roam_and_rate/presentation/trips/widgets/trip_overview_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ViewTrip extends StatefulWidget {
  final TripModel tripDetails;
  const ViewTrip({super.key, required this.tripDetails});

  @override
  State<ViewTrip> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<RatingDetailsModel> _ratings = [];
  List<ExpenseModel> _expenses = [];
  List<RatingDetailsModel> _filteredRatings = [];
  List<ExpenseModel> _filteredExpenses = [];
  TripDataState state = TripDataState(expenses: [], ratings: [], ratingsMade: []);
  TripDataState? _latestState;
  final _controller = SuperTooltipController();

  // Track converted costs
  final Map<String, double> _convertedCosts = {};

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterTripData();
    });
  }

  void _filterTripData() {
    if (_searchQuery.isEmpty) {
      _filteredExpenses = _expenses;
      _filteredRatings = _ratings;
    } else if (_searchQuery.toLowerCase().startsWith('tags:')) {
      _filterByTags();
    } else if (_searchQuery.toLowerCase().startsWith('category:')) {
      _filterByCategory();
    } else {
      _generalSearch();
    }
  }

  void _filterByTags() {
    final tags = _searchQuery
        .substring(5)
        .split(',')
        .map((tag) => tag.trim().toLowerCase())
        .toList();

    _filteredExpenses = _expenses.where((expense) {
      final expenseTags = expense.tags.map((tag) => tag.toLowerCase()).toList();
      return tags.any(
        (searchTag) => expenseTags.any((tag) => tag.contains(searchTag)),
      );
    }).toList();

    _filteredRatings = _ratings.where((rating) {
      final ratingTags = rating.tags.map((tag) => tag.toLowerCase()).toList();
      return tags.any(
        (searchTag) => ratingTags.any((tag) => tag.contains(searchTag)),
      );
    }).toList();
  }

  void _filterByCategory() {
    final categories = _searchQuery
        .substring(9)
        .split(',')
        .map((category) => category.trim().toLowerCase())
        .toList();

    _filteredExpenses = _expenses.where((expense) {
      return categories.any(
        (category) => expense.category.toLowerCase().contains(category),
      );
    }).toList();

    _filteredRatings = _ratings.where((rating) {
      return categories.any(
        (category) => rating.category.toLowerCase().contains(category),
      );
    }).toList();
  }

  void _generalSearch() {
    List<String> searchTerms = _searchQuery
        .split(',')
        .map((term) => term.trim().toLowerCase())
        .toList();

    _filteredExpenses = _expenses.where((expense) {
      final expenseNameLower = expense.name.toLowerCase();
      final tagsLower = expense.tags.map((tag) => tag.toLowerCase()).toList();

      return searchTerms.any(
        (term) =>
            expenseNameLower.contains(term) ||
            tagsLower.any((tag) => tag.contains(term)),
      );
    }).toList();

    _filteredRatings = _ratings.where((rating) {
      final ratingsNameLower = rating.placeName.toLowerCase();
      final tagsLower = rating.tags.map((tag) => tag.toLowerCase()).toList();

      return searchTerms.any(
        (term) =>
            ratingsNameLower.contains(term) ||
            tagsLower.any((tag) => tag.contains(term)),
      );
    }).toList();
  }

  // This gets called when conversion completes in FullExpenseCard
  void _onCostConverted(String expenseId, double convertedValue) {
    print("Conversion callback: $expenseId = $convertedValue");

    // Only update if the value changed
    if (_convertedCosts[expenseId] != convertedValue) {
      setState(() {
        _convertedCosts[expenseId] = convertedValue;
        print("Updated _convertedCosts: $_convertedCosts");
      });
    }
  }

  // Calculate total spent including conversions
  double get _totalSpent {
    double total = 0.0;

    for (final expense in _filteredExpenses) {
      // If currencies match, use original paid amount
      if (widget.tripDetails.currency == expense.currency) {
        total += expense.paid;
        print("Same currency: ${expense.name} = ${expense.paid}");
      }
      // If we have a converted value, use it
      else if (_convertedCosts.containsKey(expense.expenseId)) {
        total += _convertedCosts[expense.expenseId]!;
        print(
          "Converted: ${expense.name} = ${_convertedCosts[expense.expenseId]}",
        );
      }
      // Fallback: use original amount (conversion might be in progress)
      else {
        total += expense.paid;
        print("Waiting conversion: ${expense.name} = ${expense.paid}");
      }
    }

    print("FINAL TOTAL: $total");
    return total;
  }

  // Initialize converted costs for expenses with matching currencies
  void _initializeConvertedCosts() {
    for (final expense in _expenses) {
      if (widget.tripDetails.currency == expense.currency) {
        _convertedCosts[expense.expenseId!] = expense.paid;
      }
    }
    print("🏁 Initialized _convertedCosts: $_convertedCosts");
  }

  bool _dataLoaded = false;
  late final StreamSubscription<TripDataState> _tripDataSubscription;

  @override
  void initState() {
    super.initState();
    context.read<TripDataBloc>().add(
      StartWatchingTrip(widget.tripDetails.tripId!),
    );

    // Listen for the loaded state exactly once
    _tripDataSubscription = context.read<TripDataBloc>().stream.listen((state) {
      final hasData =
          state.expenses.isNotEmpty ||
          state.ratings.isNotEmpty ||
          state.ratingsMade.isNotEmpty;

      if (hasData && !_dataLoaded) {
        setState(() {
          state = state;
          _expenses = state.expenses.map((e) => e.toModel())
                        .toList();
          _ratings = state.ratings.map((e) => e.toModel())
                        .toList();;
          
          _dataLoaded = true;
        });

        // Cancel the subscription after first successful load
        _tripDataSubscription.cancel();
      }
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tripDataSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Trip Overview")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TripOverviewCard(tripModel: widget.tripDetails),
            //TripCards(tripModel: widget.tripDetails),
            const SizedBox(height: 20),
    
            // Total spent - uses the getter that calculates on-the-fly
            Text(
              "Total spent: ${_totalSpent.toStringAsFixed(2)} ${widget.tripDetails.currency}",
              style: TextStyle(
                color: CustomColours.darkPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    
            const SizedBox(height: 20),
    
            // Search bar
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColours.darkSurface,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _controller.showTooltip();
                      },
                      child: SuperTooltip(
                        showBarrier: true,
                        popupDirection: TooltipDirection.left,
                        controller: _controller,
                        content: const SizedBox(
                          width: 250,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "The search bar can be used to filter by names and tags.",
                              ),
                              SizedBox(height: 12),
                              Text("Types of searches:"),
                              SizedBox(height: 4),
                              Text("• Used commas to multi-search."),
                              Text(
                                "• Use the keyword 'tags:' to search tags only.",
                              ),
                              Text(
                                "• Use the keyword 'category:' to search categories only.",
                              ),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: CustomColours.darkPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
    
            // Toggle buttons
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
                          "Expenses",
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
                          "Ratings",
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
    
            // Content
             BlocListener<TripDataBloc, TripDataState>(
                listener: (context, state) {
                  _latestState = state;
                  
                  // Update data
                  final newRatings = state.ratings
                      .map((e) => e.toModel())
                      .toList();
                  final newExpenses = state.expenses
                      .map((e) => e.toModel())
                      .toList();
    
                  // Only update if data actually changed
                  if (!listEquals(newExpenses, _expenses) ||
                      !listEquals(newRatings, _ratings)) {
                  setState(() {
                    _ratings = newRatings;
                    _expenses = newExpenses;
                    _filterTripData();
    
                    // Initialize converted costs for matching currencies
                    _initializeConvertedCosts();
                    
                  });
                    
                  }
    
                  // if (_selectedIndex == 0) {
                  //   return _buildRatingsList(state);
                  // } else {
                  //   return _buildExpensesList();
                  // }
                },
                child: Expanded(
                  child: _selectedIndex == 1
                      ? _buildRatingsList(_latestState)
                      : _buildExpensesList(),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildRatingsList(TripDataState? state) {
    if (state == null || _filteredRatings.isEmpty) {
      return const Center(child: Text("No ratings yet"));
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: _filteredRatings.length,
      itemBuilder: (context, index) {
        final rating = _filteredRatings[index];
        final ratingsMade = state.ratingsMade
            .where((rm) => rm.ratingDetailsId == rating.id)
            .toList();

        return FullRatingCard(
          ratingDetails: rating,
          participantRatings: ratingsMade,
        );
      },
    );
  }

  Widget _buildExpensesList() {
    if (_filteredExpenses.isEmpty) {
      return const Center(child: Text("No expenses found"));
    }

    final dates =
        _filteredExpenses
            .map(
              (e) =>
                  DateTime(e.datePaid.year, e.datePaid.month, e.datePaid.day),
            )
            .toSet()
            .toList()
          ..sort((a, b) => a.compareTo(b));

    final sortedExpenses = [..._filteredExpenses]
      ..sort((a, b) => a.datePaid.compareTo(b.datePaid));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dates.length,
      itemBuilder: (context, dateIndex) {
        final date = dates[dateIndex];
        final expensesForDate = sortedExpenses.where(
          (e) =>
              e.datePaid.year == date.year &&
              e.datePaid.month == date.month &&
              e.datePaid.day == date.day,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                DateFormat('EEEE, dd MMM yyyy').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ...expensesForDate.map(
              (expense) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: FullExpenseCard(
                  expenseDetails: expense,
                  tripDetails: widget.tripDetails,
                  onCostConverted: _onCostConverted,
                  convertedCosts: _convertedCosts,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.addRating,
                arguments: AddRatingArguments(
                  tripId: widget.tripDetails.tripId!,
                ),
              ),
              child: const Text("Add Rating"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColours.darkSurface,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.addExpense,
                arguments: AddExpenseArguments(
                  tripId: widget.tripDetails.tripId!,
                ),
              ),
              child: const Text("Add Expense"),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColours.darkSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
