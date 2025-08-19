import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  DateTime? selectedDate = DateTime.now();

  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  String? selectedValue = "";

  final List<String> categories = [
    "Food & Drink",
    "Toursit Attraction",
    "Accomadation",
    "Shopping",
    "Nature & Outdoors",
    "Wellness",
    "Other",
  ];
  String? selectedCategory;

  String? selectedCurrency;

  List<String> addedTags = [];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void handleTagsChanged(List<String> tags) {
    addedTags = tags;
    setState(() {
      addedTags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Expense")),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _showPickOptionsDialog(context),
        backgroundColor: CustomColours.darkPrimary,
        foregroundColor: CustomColours.darkBackground,
        child: FaIcon(FontAwesomeIcons.camera, size: 35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input field to enter the name of the place
              Text(
                "Expense Name",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              CustomInputField(
                inputText: "Where you spent it?",
                inputIcon: FaIcon(FontAwesomeIcons.earthEurope),
                controller: _expenseNameController,
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  // How much you paid
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paid",
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColours.darkPrimary,
                          ),
                        ),
                        CustomInputField(
                          inputText: "Paid",
                          inputIcon: FaIcon(FontAwesomeIcons.moneyBill),
                          controller: _paidController,
                          numberKeyBoard: true,
                          regFilter: Values.decimalOnlyRegExp,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10), // Space between containers
                  // How much it costed
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cost",
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColours.darkPrimary,
                          ),
                        ),
                        CustomInputField(
                          inputText: "Cost",
                          inputIcon: FaIcon(FontAwesomeIcons.moneyBill1Wave),
                          controller: _costController,
                          numberKeyBoard: true,
                          regFilter: Values.decimalOnlyRegExp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Text(
                "Currency",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
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

              Row(
                children: [
                  // Select the date you visted
                  // TODO: If status is marked as planned then disable the field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColours.darkPrimary,
                          ),
                        ),
                        CustomiseableDropdown<String>(
                          items: categories,
                          hint: "Select which category?",
                          value: selectedCategory,
                          backgroundColour: CustomColours.darkSurface,
                          borderColour: Colors.transparent,
                          padding: EdgeInsets.all(20),
                          borderRadius: 20,
                          menuMaxHeight: 200,
                          selectedItemTextColour: CustomColours.darkPrimary,
                          unselectedItemTextColour: Colors.grey[300],
                          selectedTextOverflow: TextOverflow.ellipsis,
                          selectedTextMaxLines: 1,
                          onChanged: (category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          itemBuilder: (value) => Text(value),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10), // Space between containers
                  // Dropdown to select the value, if the cost was worth it
                  // TODO: Add dollar symbols
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date Paid",
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColours.darkPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () => _showCustomStyledPicker(),

                          child: Container(
                            decoration: BoxDecoration(
                              color: CustomColours.darkSurface,

                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
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
                                  padding: const EdgeInsets.all(5.0),

                                  child: Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(selectedDate!),

                                    textAlign: TextAlign.justify,

                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text(
                "Tags",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              WTagField(onTagsChanged: handleTagsChanged, addedTags: addedTags),
              SizedBox(height: 20),
              Text(
                "Notes",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              WLargeTextfield(hintText: "Notes", controller: _notesController),
              SizedBox(height: 20),
              Center(child: _image == null ? Text("") : Image.file(_image!)),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColours.darkPrimary,
                    foregroundColor: CustomColours.darkBackground,
                    padding: EdgeInsets.all(10.0),
                  ),
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
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
