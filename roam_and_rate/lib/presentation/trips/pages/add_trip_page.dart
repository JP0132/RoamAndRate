import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_event.dart';
import 'package:roam_and_rate/application/trips/trip_state.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/data/local/SessionManager.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? selectedStartDate = DateTime.now();
  DateTime? selectedEndDate = DateTime.now();
  DateTimeRange? selectedRange;
  String? selectedCurrency;
  String? selectedCategory;

  final Map<String, bool> formValid = {
    "tripName": true,
    "location": true,
    "budget": true,
    "selectedRange": true,
    "category": true,
    "currency": true,
  };

  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  void validateDetails() {
    formValid["tripName"] =
        _tripNameController.text.trim().isNotEmpty &&
        _tripNameController.text.length > 1;
    formValid["location"] =
        _locationController.text.trim().isNotEmpty &&
        _locationController.text.length > 1;
    formValid["budget"] =
        isNumeric(_budgetController.text.trim()) ||
        _budgetController.text.trim().isEmpty;
    formValid["date"] =
        selectedRange?.start != null || selectedRange?.end != null;
    formValid["category"] =
        selectedCategory != null && selectedCategory!.isNotEmpty;
    formValid["currency"] =
        selectedCurrency != null && selectedCurrency!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Trip")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Trip Name *",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomInputField(
              inputText: "A memorable trip name",
              inputIcon: FaIcon(FontAwesomeIcons.suitcase),
              controller: _tripNameController,
            ),
            if (formValid["tripName"] == false)
              Text(
                "Trip Name cannot be blank or be less than 2 characters!",
                style: TextStyle(color: Colors.red),
              ),

            SizedBox(height: 20),
            // Location Input field
            Text(
              "Location *",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomInputField(
              inputText: "Where you went",
              inputIcon: FaIcon(FontAwesomeIcons.locationDot),
              controller: _locationController,
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _locationController,
              builder: (context, value, child) {
                return Text(
                  formValid["location"] == true
                      ? ""
                      : "Location cannot be blank!",
                  style: TextStyle(color: CustomColours.darkError),
                );
              },
            ),
            SizedBox(height: 20),
            // Currency Dropdown
            Text(
              "Currency *",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomiseableDropdown<String>(
              items: CurrencyData.fiatCurrenciesNames,
              hint: "What currency did you use",
              value: selectedCurrency,
              backgroundColour: CustomColours.darkSurface,
              borderColour: Colors.transparent,
              padding: EdgeInsets.all(20),
              borderRadius: 20,
              menuMaxHeight: 200,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                });
              },
              itemBuilder: (currency) => Text(currency),
            ),
            Text(
              formValid["currency"] == true ? "" : "Currency cannot be blank!",
              style: TextStyle(color: CustomColours.darkError),
            ),
            SizedBox(height: 20),
            // Budget Input Field
            Text(
              "Budget",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _budgetController,
              builder: (context, value, child) {
                return Text(
                  formValid["budget"] == true
                      ? ""
                      : "Budget can only contain numbers!",
                  style: TextStyle(color: CustomColours.darkError),
                );
              },
            ),
            CustomInputField(
              inputText: "What was your budget",
              inputIcon: FaIcon(FontAwesomeIcons.moneyBill),
              controller: _budgetController,
              numberKeyBoard: true,
              regFilter: Values.decimalOnlyRegExp,
            ),
            SizedBox(height: 20),

            Text(
              "Select trip dates *",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            InkWell(
              onTap: () => _showEnhancedRangeDatePicker(),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColours.darkSurface,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.date_range,
                          color: CustomColours.darkPrimary,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        selectedRange != null
                            ? "${DateFormat('dd/MM/yyyy').format(selectedRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedRange!.end)}"
                            : "Start and End dates",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedRange != null
                              ? Colors.white
                              : CustomColours.darkSecondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              formValid["selectedRange"] == true ? "" : "Date cannot be blank!",
              style: TextStyle(color: CustomColours.darkError),
            ),
            SizedBox(height: 20),
            Text(
              "Category *",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomiseableDropdown<String>(
              items: Categories.categories.map((cat) => cat.name).toList(),
              hint: "Type of trip",
              value: selectedCategory,
              backgroundColour: CustomColours.darkSurface,
              borderColour: Colors.transparent,
              padding: EdgeInsets.all(20),
              borderRadius: 20,
              menuMaxHeight: 200,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              itemBuilder: (category) => Text(category),
            ),
            Text(
              formValid["category"] == true ? "" : "Category cannot be blank!",
              style: TextStyle(color: CustomColours.darkError),
            ),
            SizedBox(height: 50),
            BlocConsumer<TripBloc, TripState>(
              listener: (context, state) {
                if (state is TripAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Trip created!"),
                      backgroundColor: CustomColours.darkSuccess,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is TripError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to create trip: ${state.message}"),
                      backgroundColor: CustomColours.darkError,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TripLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      validateDetails();
                    });
                    if (formValid.values.every((v) => v)) {
                      final TripModel newTrip = TripModel(
                        userId: SessionManager().userId!,
                        tripName: _tripNameController.text.trim(),
                        location: _locationController.text.trim(),
                        currency: selectedCurrency!,
                        category: selectedCategory!,
                        createdAt: DateTime.now(),
                        startDate: selectedRange!.start,
                        endDate: selectedRange!.end,
                        budget: double.parse(_budgetController.text.trim()),
                      );
                      context.read<TripBloc>().add(AddTrip(newTrip));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColours.darkPrimary,
                    foregroundColor: CustomColours.darkBackground,
                    padding: EdgeInsets.all(8.0),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomStyledPicker(DateTime? selectedDate) async {
    final date = await CustomDatePicker.showSingleDatePicker(
      context: context,
      config: DatePickerConfig(
        primaryColor: CustomColours.darkPrimary,
        backgroundColor: CustomColours.darkSurface,
        textColor: CustomColours.darkPrimaryText,
        selectedTextColor: Colors.black,
        disabledTextColor: CustomColours.darkPrimary,
        borderColor: CustomColours.darkBackground,
        todayColor: CustomColours.darkError,
        hoverColor: CustomColours.darkSecondarySurface,
        borderRadius: 20.0,
        headerTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CustomColours.darkPrimary,
        ),
        dayTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        monthTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        yearTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        enableManualEdit: true,
      ),
      initialDate: selectedDate,
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _showEnhancedRangeDatePicker() async {
    final range = await CustomDatePicker.showRangeDatePicker(
      context: context,
      config: DatePickerConfig(
        primaryColor: CustomColours.darkPrimary,
        backgroundColor: CustomColours.darkSurface,
        textColor: CustomColours.darkPrimaryText,
        selectedTextColor: Colors.black,
        disabledTextColor: CustomColours.darkPrimary,
        borderColor: CustomColours.darkBackground,
        todayColor: CustomColours.darkError,
        hoverColor: CustomColours.darkSecondarySurface,
        borderRadius: 20.0,
        headerTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CustomColours.darkPrimary,
        ),
        dayTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        monthTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        yearTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        enableManualEdit: true,
        rangeColor: CustomColours.darkPrimaryVariant,
      ),
      initialRange: selectedRange,
    );

    if (range != null) {
      setState(() {
        selectedRange = range;
      });
    }
  }
}
