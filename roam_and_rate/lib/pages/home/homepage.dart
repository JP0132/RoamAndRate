import 'package:flutter/material.dart';
import 'package:roam_and_rate/widgets/expense_card.dart';
import 'package:roam_and_rate/widgets/rating_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home"))),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
