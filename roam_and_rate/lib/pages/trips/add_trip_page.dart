import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/models/date_picker_model.dart';
import 'package:roam_and_rate/widgets/currency_selector.dart';
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
  DateTime? selectedDate = DateTime.now();
  String? selectedCurrency;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Trip")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInputField(
            inputText: "Trip Name",
            inputIcon: FaIcon(FontAwesomeIcons.suitcase),
            controller: _tripNameController,
          ),

          // Location Input field
          CustomInputField(
            inputText: "Location",
            inputIcon: FaIcon(FontAwesomeIcons.locationDot),
            controller: _locationController,
          ),

          // Currency Dropdown
          CustomiseableDropdown<String>(
            items: CurrencyData.fiatCurrenciesCodes,
            hint: "Currency",
            value: selectedCurrency,
            backgroundColor: CustomColours.darkSurface,
            borderColor: Colors.transparent,
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

          // Budget Input Field
          CustomInputField(
            inputText: "Budget",
            inputIcon: FaIcon(FontAwesomeIcons.moneyBill),
            controller: _budgetController,
            inputType: "numbers",
          ),

          InkWell(
            onTap: () => _showCustomStyledPicker(),
            child: Container(
              decoration: BoxDecoration(
                color: CustomColours.darkSurface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.calendar_today,
                        color: CustomColours.darkPrimary,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(selectedDate!),
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),

          CustomiseableDropdown<String>(
            items: Categories.categories.map((cat) => cat.name).toList(),
            hint: "Select Category",
            value: selectedCategory,
            backgroundColor: CustomColours.darkSurface,
            borderColor: Colors.transparent,
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
        ],
      ),
    );
  }

  Future<void> _showCustomStyledPicker() async {
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
}
