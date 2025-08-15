import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/models/date_picker_model.dart';
import 'package:roam_and_rate/widgets/custom_input_field.dart';
import 'package:roam_and_rate/widgets/customiseable_dropdown.dart';
import 'package:roam_and_rate/widgets/customised_date_picker.dart';

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
              "Trip Name",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomInputField(
              inputText: "A memorable trip name",
              inputIcon: FaIcon(FontAwesomeIcons.suitcase),
              controller: _tripNameController,
            ),
            SizedBox(height: 20),
            // Location Input field
            Text(
              "Location",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
            ),
            CustomInputField(
              inputText: "Where you went",
              inputIcon: FaIcon(FontAwesomeIcons.locationDot),
              controller: _locationController,
            ),
            SizedBox(height: 20),
            // Currency Dropdown
            Text(
              "Currency",
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
            SizedBox(height: 20),
            // Budget Input Field
            Text(
              "Budget",
              style: TextStyle(fontSize: 14, color: CustomColours.darkPrimary),
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
              "Select trip dates",
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
                          color:
                              selectedRange != null
                                  ? Colors.white
                                  : CustomColours.darkSecondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Category",
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
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColours.darkPrimary,
                foregroundColor: CustomColours.darkBackground,
                padding: EdgeInsets.all(8.0),
              ),
              child: Text(
                "Submit",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
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
