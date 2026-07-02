import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/application/tripData/trip_data_bloc.dart';
import 'package:roam_and_rate/application/tripData/trip_data_event.dart';
import 'package:roam_and_rate/application/tripData/trip_data_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/helper/currency_helper.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/mappers/expense_mappers.dart';
import 'package:roam_and_rate/data/local/mappers/rating_details_mappers.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/helpers/expense_helper_functions.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/full_expense_card.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/full_rating_card.dart';
import 'package:roam_and_rate/presentation/trips/classes/tabitem.dart';
import 'package:roam_and_rate/presentation/trips/pages/segmented_switcher.dart';
import 'package:roam_and_rate/presentation/trips/widgets/add_btn.dart';
import 'package:roam_and_rate/presentation/trips/widgets/trip_overview_card.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';
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

  final sessionManager = SessionManager();
  String? userCurrency = "";

  List<RatingDetailsModel> _ratings = [];
  List<ExpenseModel> _expenses = [];
  List<RatingDetailsModel> _filteredRatings = [];
  List<ExpenseModel> _filteredExpenses = [];
  TripDataState state = TripDataState(
    expenses: [],
    ratings: [],
    ratingsMade: [],
  );
  TripDataState? _latestState;
  final _controller = SuperTooltipController();

  bool _isConverting = false;

  // Track converted costs
  Map<String, double> _convertedCosts = {};

  late StreamSubscription<List<ConnectivityResult>> _connectivitySub;

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

  Map<String, double> _calculateTotals() {
    double budgetTotal = 0.0;
    double paidTotal = 0.0;
    double userCurrencyTotal = 0.0;

    for (final expense in _filteredExpenses) {
      final double amount = _getConvertedOrPaid(expense);
      final double userCurrAmount = _getUserCurrencyTotal(expense);
      print("Expense: ${expense.name} = $amount");
      // All expenses
      paidTotal += amount;
      userCurrencyTotal += userCurrAmount;
      print("Paid total: $paidTotal");
      if (!expense.isNotBudget) {
        // Only budget expenses
        budgetTotal += amount;
      }
    }

    return {
      "budgetTotal": budgetTotal,
      "paidTotal": paidTotal,
      "userCurrencyTotal": userCurrencyTotal,
    };
  }

  double _getConvertedOrPaid(ExpenseModel expense) {
    if (expense.exchangeRate != 1.0)
      return toMajor(expense.targetPaidAmountMinor!, expense.targetCurrency!);

    // if (widget.tripDetails.currency == expense.baseCurrency && userCurrency == expense.baseCurrency) return toMajor(expense.basePaidAmountMinor!, expense.baseCurrency!);
    // if (_convertedCosts.containsKey(expense.expenseId))
    //   return _convertedCosts[expense.expenseId]!;

    return toMajor(expense.basePaidAmountMinor!, expense.baseCurrency!);

    //return expense.paid;
  }

  double _getUserCurrencyTotal(ExpenseModel expense) {
    if (expense.exchangeRate != 1.0)
      return toMajor(expense.targetPaidAmountMinor!, expense.targetCurrency!);
    // if(userCurrency == expense.currency) return expense.paid;
    // if (_convertedCosts.containsKey("user_${expense.expenseId}")) {
    //   return _convertedCosts["user_${expense.expenseId}"]!;
    // }
    return toMajor(expense.basePaidAmountMinor!, expense.baseCurrency!);
    //return expense.paid;
  }

  // Initialize converted costs for expenses with matching currencies
  // void _initializeConvertedCosts() {
  //   for (final expense in _expenses) {
  //     if (widget.tripDetails.currency == expense.currency) {
  //       _convertedCosts[expense.expenseId!] = expense.paid;
  //     }
  //   }
  //   print("🏁 Initialized _convertedCosts: $_convertedCosts");
  // }

  bool _dataLoaded = false;

  Future<void> _convertPendingExpenses() async {
    if (_isConverting) return;

    final pending = _expenses
        .where((e) => e.conversionStatus == 'pending')
        .toList();

    if (pending.isEmpty) return;

    setState(() {
      _isConverting = true;
    });

    for (final expense in pending) {
      try {
        final targetCurrency = expense.targetCurrency!;
        final baseCurrency = expense.baseCurrency!;
        final basePaidAmount = toMajor(
          expense.basePaidAmountMinor!,
          expense.baseCurrency!,
        );
        final baseCostAmount = toMajor(
          expense.baseCostAmountMinor!,
          expense.baseCurrency!,
        );

        final result = targetCurrency == baseCurrency
            ? 1.0
            : await CurrencyHelper().getExchangeRateCached(
                base: baseCurrency,
                target: targetCurrency,
              );

        if (result != null) {
          final convertedPaidAmount = basePaidAmount * result;
          final convertedCostAmount = baseCostAmount * result;

          final convertedPaidMinor = toMinor(
            convertedPaidAmount.toString(),
            targetCurrency,
          );
          final convertedCostMinor = toMinor(
            convertedCostAmount.toString(),
            targetCurrency,
          );

          final updatedExpense = expense.copyWith(
            targetPaidAmountMinor: convertedPaidMinor,
            targetCostAmountMinor: convertedCostMinor,
            exchangeRate: result,
            conversionStatus: 'completed',
          );

          context.read<ExpenseBloc>().add(EditExpense(updatedExpense));
        }
      } catch (e) {
        debugPrint("Conversion still failing for ${expense.expenseId}: $e");
      }
    }
    if (mounted) setState(() => _isConverting = false);
  }

  @override
  void initState() {
    super.initState();

    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
    if (result.isNotEmpty && result.first != ConnectivityResult.none) {
      _convertPendingExpenses();
    }});

    context.read<TripDataBloc>().add(
      StartWatchingTrip(widget.tripDetails.tripId!),
    );

    userCurrency = SessionManager().userCurrency;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _connectivitySub.cancel();
    super.dispose();
  }

  void _onSelectIndex(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    // final totals = _calculateTotals();
    // final _totalBudgetSpent = totals["budgetTotal"];
    // final _totalPaidSpent = totals["paidTotal"];

    // print("Total budget spent: $_totalBudgetSpent");
    // print("Total paid spent: $_totalPaidSpent");

    return MultiBlocListener(
      listeners: [
        BlocListener<TripDataBloc, TripDataState>(
          listener: (context, state) {
            _latestState = state;

            final newRatings = state.ratings.map((e) => e.toModel()).toList();

            final newExpenses = state.expenses.map((e) => e.toModel()).toList();

            if (!listEquals(newExpenses, _expenses) ||
                !listEquals(newRatings, _ratings)) {
              setState(() {
                _ratings = newRatings;
                _expenses = newExpenses;

                _filterTripData();
              });

              _convertPendingExpenses();
            }
          },
        ),
      ],
      child: BlocBuilder<ParticipantBloc, ParticipantState>(
        builder: (context, participantState) {
          if (participantState is ParticipantLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (participantState is! ParticipantLoaded) {
            return const Scaffold(
              body: Center(child: Text("Failed to load participants")),
            );
          }

          final participants = participantState.participants;

          final totals = _calculateTotals();

          final totalBudgetSpent = totals["budgetTotal"] ?? 0.0;
          final totalPaidSpent = totals["paidTotal"] ?? 0.0;
          final totalUserCurrencySpent = totals["userCurrencyTotal"] ?? 0.0;

          return Scaffold(
            appBar: CustomAppBar(title: "Trip Overview", custom: custom),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TripOverviewCard(
                    tripModel: widget.tripDetails,
                    totalSpent: totalPaidSpent,
                    totalBudgetSpent: totalBudgetSpent,
                    totalUserCurrencySpent: totalUserCurrencySpent,
                    userCurrency: userCurrency,
                  ),
                  //TripCards(tripModel: widget.tripDetails),
                  const SizedBox(height: 20),

                  const SizedBox(height: 10),

                  // Search bar
                  Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: custom.surface,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: custom.primary),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: custom.primary,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: custom.primary,
                                ),
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
                              content: SizedBox(
                                width: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "The search bar can be used to filter by names and tags.",
                                      style: TextStyle(
                                        color: custom.primaryText,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Types of searches:",
                                      style: TextStyle(
                                        color: custom.primaryText,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "• Used commas to multi-search.",
                                      style: TextStyle(
                                        color: custom.primaryText,
                                      ),
                                    ),
                                    Text(
                                      "• Use the keyword 'tags:' to search tags only.",
                                      style: TextStyle(
                                        color: custom.primaryText,
                                      ),
                                    ),
                                    Text(
                                      "• Use the keyword 'category:' to search categories only.",
                                      style: TextStyle(
                                        color: custom.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: custom.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text("Total User Currency Spent: $totalUserCurrencySpent"),

                  SegmentedSwitcher(
                    items: [
                      TabItem(title: "Expenses", count: _expenses.length),
                      TabItem(title: "Ratings", count: _ratings.length),
                    ],
                    onTabSelected: _onSelectIndex,
                    selectedIndex: _selectedIndex,
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
                        });

                        _convertPendingExpenses();
                      }
                    },
                    child: Expanded(
                      child: _selectedIndex == 1
                          ? _buildRatingsList(participants)
                          : _buildExpensesList(participants),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomButtons(participants),
          );
        },
      ),
    );
  }

  Widget _buildRatingsList(List<ParticipantModel> participants) {
    if (_filteredRatings.isEmpty) {
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
          participants: participants,
        );
      },
    );
  }

  Widget _buildExpensesList(List<ParticipantModel> participants) {
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
            ...expensesForDate.map(
              (expense) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: FullExpenseCard(
                  expenseDetails: expense,
                  tripDetails: widget.tripDetails,
                  onCostConverted: _onCostConverted,
                  convertedCosts: _convertedCosts,
                  participantName: participants
                      .firstWhere((p) => p.id == expense.participantId)
                      .particpantName,
                  participants: participants,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons(List<ParticipantModel> particpant) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AddBtn(
              tripDetails: widget.tripDetails,
              btnText: "Add Expense",
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.addExpense,
                arguments: AddExpenseArguments(
                  tripDetails: widget.tripDetails,
                  participants: particpant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AddBtn(
              tripDetails: widget.tripDetails,
              btnText: "Add Rating",
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.addRating,
                arguments: AddRatingArguments(
                  tripId: widget.tripDetails.tripId!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
