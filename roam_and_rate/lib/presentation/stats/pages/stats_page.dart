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
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String selectedTrip = "All";
  List<TripModel> _trips = [];
  List<ExpenseModel> _expenses = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    _trips = state.trips;

                    return CustomisableDropdown<String>(
                      items: ["All", ..._trips.map((e) => e.tripId!)],
                      hint: "Who paid for it?",
                      value: selectedTrip,
                      backgroundColour: CustomColours.darkSurface,
                      borderColour: Colors.transparent,
                      padding: EdgeInsets.all(20),
                      borderRadius: 20,
                      menuMaxHeight: 200,
                      selectedItemTextColour: CustomColours.darkPrimary,
                      onChanged: (value) {
                        setState(() {
                          selectedTrip = value!;
                        });
                      },
                      itemBuilder: (id) {
                        if (id == "All") {
                          return const Text("All Trips");
                        }
                        final trip = _trips.firstWhere((t) => t.tripId == id);
                        return Text(trip.tripName);
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

            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoaded) {
                  if (state.expenses.isEmpty) {
                    return Center(child: Text("No expenses found!"));
                  }
                  _expenses = state.expenses;
                  if (selectedTrip != "All") {
                    _expenses = _expenses
                        .where((expense) => expense.tripId == selectedTrip)
                        .toList();
                  }
                  return Column(
                    children: [
                      Text(
                        "Total Expenses: \$${_expenses.fold(0.0, (double sum, item) => sum + item.paid)}",
                      ),
                      ExpensePieChart(expenses: _expenses),
                    ],
                  );
                } else if (state is ExpenseError) {
                  return Text("Error: ${state.message}");
                } else {
                  return const Text("Something went wrong!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
