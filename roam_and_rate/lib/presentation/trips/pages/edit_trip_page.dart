import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_event.dart';
import 'package:roam_and_rate/application/trips/trip_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';

class EditTripPage extends StatefulWidget {
  final TripModel tripDetails;
  const EditTripPage({super.key, required this.tripDetails});

  @override
  State<EditTripPage> createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? selectedStartDate = DateTime.now();
  DateTime? selectedEndDate = DateTime.now();
  DateTimeRange? selectedRange;
  String? selectedCurrency;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _tripNameController.text = widget.tripDetails.tripName;
    _locationController.text = widget.tripDetails.location;
    _budgetController.text = widget.tripDetails.budget.toString();
    selectedCategory = widget.tripDetails.category;
    selectedCurrency = widget.tripDetails.currency;
    selectedStartDate = widget.tripDetails.startDate;
    selectedEndDate = widget.tripDetails.endDate;
    selectedRange = DateTimeRange(
      start: widget.tripDetails.startDate,
      end: widget.tripDetails.endDate,
    );
  }

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
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Trip",custom: custom),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Trip Name *",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
              ),
              CustomInputField(
                inputText: "A memorable trip name",
                inputIcon: FaIcon(FontAwesomeIcons.suitcase),
                controller: _tripNameController,
              ),
              if (formValid["tripName"] == false)
                Text(
                  "Trip Name cannot be blank or be less than 2 characters!",
                  style: TextStyle(color: custom.error),
                ),

              SizedBox(height: 20),
              // Location Input field
              Text(
                "Location *",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
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
                    style: TextStyle(color: custom.error),
                  );
                },
              ),
              SizedBox(height: 20),
              // Currency Dropdown
              Text(
                "Currency *",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
              ),
              CustomisableDropdown<String>(
                items: CurrencyData.fiatCurrenciesNames,
                hint: "What currency did you use",
                value: selectedCurrency != null
                    ? CurrencyData.getNameFromCode(selectedCurrency!)
                    : null,
                backgroundColour: custom.surface,
                selectedItemTextColour: custom.background,
                selectedItemColour: custom.primary,
                borderColour: Colors.transparent,
                padding: EdgeInsets.all(20),
                borderRadius: 20,
                menuMaxHeight: 200,
                onChanged: (value) {
                  setState(() {
                    final code = CurrencyData.getCodeFromName(value!);
                    selectedCurrency = code;
                  });
                },
                itemBuilder: (currency) => Text(currency),
              ),
              Text(
                formValid["currency"] == true
                    ? ""
                    : "Currency cannot be blank!",
                style: TextStyle(color: custom.error),
              ),
              SizedBox(height: 20),
              // Budget Input Field
              Text(
                "Budget",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _budgetController,
                builder: (context, value, child) {
                  return Text(
                    formValid["budget"] == true
                        ? ""
                        : "Budget can only contain numbers!",
                    style: TextStyle(color: custom.error),
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
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
              ),
              InkWell(
                onTap: () => _showEnhancedRangeDatePicker(),
                child: Container(
                  decoration: BoxDecoration(
                    color: custom.surface,
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
                            color: custom.primary,
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
                                : custom.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                formValid["selectedRange"] == true
                    ? ""
                    : "Date cannot be blank!",
                style: TextStyle(color: custom.error),
              ),
              SizedBox(height: 20),
              Text(
                "Category *",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primary,
                ),
              ),
              CustomisableDropdown<String>(
                items: Categories.tripCategories
                    .map((cat) => cat.name)
                    .toList(),
                hint: "Type of trip",
                value: selectedCategory,
                backgroundColour: custom.surface,
                borderColour: Colors.transparent,
                padding: EdgeInsets.all(20),
                selectedItemColour: custom.primary,
                selectedItemTextColour: custom.background,
                borderRadius: 20,
                menuMaxHeight: 100,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                itemBuilder: (category) => Text(category),
              ),
              Text(
                formValid["category"] == true
                    ? ""
                    : "Category cannot be blank!",
                style: TextStyle(color: custom.error),
              ),
              SizedBox(height: 50),
              BlocConsumer<TripBloc, TripState>(
                listener: (context, state) {
                  final custom = Theme.of(context).extension<CustomColours>()!;
                  if (state is TripEdited) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Trip Edited!"),
                        backgroundColor: custom.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is TripError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to create trip: ${state.message}",
                        ),
                        backgroundColor: custom.error,
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
                        TripModel updatedTrip = widget.tripDetails.copyWith(
                          tripName: _tripNameController.text.trim(),
                          location: _locationController.text.trim(),
                          currency: selectedCurrency!,
                          category: selectedCategory!,
                          createdAt: DateTime.now(),
                          startDate: selectedRange!.start,
                          endDate: selectedRange!.end,
                          budget: double.parse(_budgetController.text.trim()),
                        );

                        context.read<TripBloc>().add(EditTrip(updatedTrip));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: custom.primary,
                      foregroundColor: custom.background,
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEnhancedRangeDatePicker() async {
    final custom = Theme.of(context).extension<CustomColours>()!;

    final range = await CustomDatePicker.showRangeDatePicker(
      context: context,
      config: DatePickerConfig(
        primaryColor: custom.primary,
        backgroundColor: custom.surface,
        textColor: custom.primaryText,
        selectedTextColor: Colors.black,
        disabledTextColor: custom.primary,
        borderColor: custom.background,
        todayColor: custom.error,
        hoverColor: custom.secondarySurface,
        borderRadius: 20.0,
        headerTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: custom.primary,
        ),
        dayTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        monthTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        yearTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        enableManualEdit: true,
        rangeColor: custom.primaryVariant,
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
