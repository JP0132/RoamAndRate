import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';

class ViewTrip extends StatefulWidget {
  final TripModel tripDetails;
  const ViewTrip({super.key, required this.tripDetails});

  @override
  State<ViewTrip> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("View Trip")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab to view the expenses and ratings
            ElevatedButton(
              onPressed:
                  () => Navigator.pushNamed(context, AppRouter.addRating),
              child: Text("Add Rating"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  () => Navigator.pushNamed(context, AppRouter.addExpense),
              child: Text("Add Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
