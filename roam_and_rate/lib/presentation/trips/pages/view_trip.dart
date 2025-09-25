import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';
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
import 'package:roam_and_rate/data/local/tables/rating_details.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/full_expense_card.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/full_rating_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/expense_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/rating_cards.dart';
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

  double _totalSpent = 0;

  List<RatingDetailsModel> _ratings = [];
  List<ExpenseModel> _expenses = [];

  List<RatingDetailsModel> _filteredRatings = [];
  List<ExpenseModel> _filteredExpenses = [];
  final _controller = SuperTooltipController();
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterTripData();
    });
  }

  void makeTooltip() {
    _controller.showTooltip();
  }

  // void _filterTripData() {
  //   List<String> searchTerms = _searchQuery
  //       .split(',')
  //       .map((term) => term.trim().toLowerCase())
  //       .toList();

  //   if (_searchQuery.isEmpty) {
  //     _filteredExpenses = _expenses;
  //     _filteredRatings = _ratings;
  //   } else {
  //     _filteredExpenses = _expenses.where((expense) {
  //       final expenseNameLower = expense.name.toLowerCase();
  //       // final searchQueryLower = _searchQuery.toLowerCase();

  //       final tagsLower = expense.tags.map((tag) => tag.toLowerCase()).toList();
  //       return searchTerms.any(
  //         (term) =>
  //             expenseNameLower.contains(term) ||
  //             tagsLower.any((tag) => tag.contains(term)),
  //       );
  //     }).toList();
  //     _filteredRatings = _ratings.where((rating) {
  //       final ratingsNameLower = rating.placeName.toLowerCase();
  //       // final searchQueryLower = _searchQuery.toLowerCase();

  //       final tagsLower = rating.tags.map((tag) => tag.toLowerCase()).toList();
  //       return searchTerms.any(
  //         (term) =>
  //             ratingsNameLower.contains(term) ||
  //             tagsLower.any((tag) => tag.contains(term)),
  //       );
  //     }).toList();
  //   }
  //   if (_filteredExpenses.isNotEmpty) {
  //     _calculateTotalSpent();
  //   } else {
  //     // Keep the initial total amount if the filter yields no results
  //     _totalSpent = widget.tripDetails.budget;
  //   }
  // }

  void _filterTripData() {
    if (_searchQuery.isEmpty) {
      _filteredExpenses = _expenses;
      _filteredRatings = _ratings;
      _calculateTotalSpent();
      return;
    }

    // Check for specific search patterns
    if (_searchQuery.toLowerCase().startsWith('tags:')) {
      _filterByTags();
    } else if (_searchQuery.toLowerCase().startsWith('category:')) {
      _filterByCategory();
    } else {
      _generalSearch();
    }

    if (_filteredExpenses.isNotEmpty) {
      _calculateTotalSpent();
    }
  }

  void _filterByTags() {
    // Extract tags from search query (remove "tags:" prefix and trim)
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
    // Extract categories from search query (remove "category:" prefix and trim)
    final categories = _searchQuery
        .substring(9)
        .split(',')
        .map((category) => category.trim().toLowerCase())
        .toList();

    // For expenses, you might not have a category field. Adjust based on your data model
    _filteredExpenses = _expenses.where((expense) {
      // If expenses have categories, use this:
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

  void _updateTotalSpent(double newTotal) {
    // Schedule the setState to happen after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _totalSpent = newTotal;
        });
      }
    });
  }

  void _calculateTotalSpent() {
    _totalSpent = _filteredExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.paid,
    );
    _updateTotalSpent(_totalSpent);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final db = AppDatabase.instance;
        return TripDataBloc(
          ExpenseDao(db),
          RatingDetailsDao(db),
          RatingsMadeDao(db),
        )..add(StartWatchingTrip(widget.tripDetails.tripId!));
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Trip Details")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TripCards(tripModel: widget.tripDetails),
              SizedBox(height: 20),

              Text(
                "Total spent: $_totalSpent",
                style: TextStyle(
                  color: CustomColours.darkPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

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
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await _controller.showTooltip();
                        },
                        child: SuperTooltip(
                          showBarrier: true,
                          popupDirection: TooltipDirection.left,
                          controller: _controller,
                          content: SizedBox(
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
              SizedBox(height: 20),

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
                    _ratings = state.ratings.map((e) => e.toModel()).toList();
                    _expenses = state.expenses.map((e) => e.toModel()).toList();
                    _filterTripData();
                    if (_selectedIndex == 0) {
                      if (_filteredRatings.isEmpty) {
                        return const Center(child: Text("No ratings yet"));
                      }

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12),
                        itemCount: _filteredRatings.length,
                        itemBuilder: (context, index) {
                          final rating = _filteredRatings[index];
                          //print("😭😭😭 ${state.ratingsMade.first.rating}");
                          final ratingsMade = state.ratingsMade
                              .where((rm) => rm.ratingDetailsId == rating.id)
                              .map((e) => e)
                              .toList();

                          // return RatingCards(
                          //   name: rating.placeName,
                          //   rating: int.parse((0.0 * 2).truncate().toString()),
                          //   dateRated: rating.dateVisited ?? DateTime.now(),
                          // );
                          return FullRatingCard(
                            ratingDetails: rating,
                            participantRatings: ratingsMade,
                          );
                        },
                      );
                    } else {
                      if (_filteredExpenses.isEmpty) {
                        return const Center(child: Text("No expenses found"));
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
                        _filteredExpenses
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
                    final sortedExpenses = [..._filteredExpenses]
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
                                child: FullExpenseCard(expenseDetails: expense),
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tab to view the expenses and ratings
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRouter.addRating,
                    arguments: AddRatingArguments(
                      tripId: widget.tripDetails.tripId!,
                    ),
                  ),
                  child: Text("Add Rating"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColours.darkSurface,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRouter.addExpense,
                    arguments: AddExpenseArguments(
                      tripId: widget.tripDetails.tripId!,
                    ),
                  ),
                  child: Text("Add Expense", style: TextStyle()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColours.darkSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
