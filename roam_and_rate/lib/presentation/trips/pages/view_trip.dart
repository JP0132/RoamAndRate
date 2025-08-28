import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/trips/widgets/tab_item.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
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
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Trip Details")),
      body: Column(
        children: [
          TripCards(tripModel: widget.tripDetails),

          // Tab to view the expenses and ratings
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.addRating),
            child: Text("Add Rating"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.addExpense),
            child: Text("Add Expense"),
          ),
          const SizedBox(height: 12),
          // Toggle buttons (Ratings / Expenses)
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Ratings",
                        style: TextStyle(color: Colors.black),
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
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Expenses",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _selectedIndex == 0
                ? ListView(
                    children: const [
                      ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text("Vasco de Gama"),
                        subtitle: Text("Fri, 05 April 2024"),
                        trailing: Text(
                          "Masterpiece",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text("Ramiro"),
                        subtitle: Text("Fri, 05 April 2024"),
                        trailing: Text(
                          "Bad",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: const [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.moneyBill),
                        title: Text("Hotel Booking"),
                        subtitle: Text("Fri, 05 April 2024"),
                        trailing: Text("- \$120"),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.utensils),
                        title: Text("Dinner"),
                        subtitle: Text("Sat, 06 April 2024"),
                        trailing: Text("- \$45"),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
