import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';
import 'package:roam_and_rate/application/expenses/expense_state.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';

class AddExpensePage extends StatefulWidget {
  final String tripId;
  const AddExpensePage({super.key, required this.tripId});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  DateTime? selectedDate = DateTime.now();
  bool toBeSplit = false;

  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  final List<String> types = ["card", "cash", "bank transfer"];

  List<ParticipantModel> _participants = [];
  String selectedParticipant = "";

  final List<String> categories = [
    "Food & Drink",
    "Tourist Attraction",
    "Accommodation",
    "Shopping",
    "Nature & Outdoors",
    "Transport",
    "Wellness",
    "Other",
  ];
  String? selectedCategory;
  String? selectedType;
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
      builder: (context) => SafeArea(
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

  final Map<String, bool> formValid = {
    "expenseName": true,
    "paid": true,
    "cost": true,
    "category": true,
    "currency": true,
    "datePaid": true,
    "type": true,
  };

  void validateDetails() {
    formValid["expenseName"] =
        _expenseNameController.text.trim().isNotEmpty &&
        _expenseNameController.text.length > 1;
    formValid["paid"] =
        isNumeric(_paidController.text.trim()) ||
        _paidController.text.trim().isNotEmpty;
    formValid["cost"] =
        isNumeric(_costController.text.trim()) ||
        _costController.text.trim().isEmpty;
    formValid["datePaid"] = selectedDate != null;
    formValid["category"] =
        selectedCategory != null && selectedCategory!.isNotEmpty;
    formValid["currency"] =
        selectedCurrency != null && selectedCurrency!.isNotEmpty;
    formValid["type"] = selectedType != null && selectedType!.isNotEmpty;
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input field to enter the name of the place
                Text(
                  "Expense Name *",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                CustomInputField(
                  inputText: "What you spent it on?",
                  inputIcon: FaIcon(FontAwesomeIcons.earthEurope),
                  controller: _expenseNameController,
                ),
                Text(
                  formValid["expenseName"] == true
                      ? ""
                      : "Name cannot be blank!",
                  style: TextStyle(color: CustomColours.darkError),
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
                            "Paid *",
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
                          Text(
                            formValid["paid"] == true
                                ? ""
                                : "Paid cannot be blank!",
                            style: TextStyle(color: CustomColours.darkError),
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
                            "Cost *",
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
                          Text(
                            formValid["cost"] == true
                                ? ""
                                : "Cost cannot be blank!",
                            style: TextStyle(color: CustomColours.darkError),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text(
                  "Currency *",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                CustomisableDropdown<String>(
                  items: CurrencyData.fiatCurrenciesNames,
                  hint: "What currency did you use",
                  value: selectedCurrency,
                  backgroundColour: CustomColours.darkSurface,
                  selectedItemTextColour: CustomColours.darkPrimary,
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
                  formValid["currency"] == true
                      ? ""
                      : "Currency cannot be blank!",
                  style: TextStyle(color: CustomColours.darkError),
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
                            "Category *",
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColours.darkPrimary,
                            ),
                          ),
                          CustomisableDropdown<String>(
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

                            onChanged: (category) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            itemBuilder: (value) => Text(value),
                          ),
                          Text(
                            formValid["category"] == true
                                ? ""
                                : "Category cannot be blank!",
                            style: TextStyle(color: CustomColours.darkError),
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
                            "Payment Type *",
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColours.darkPrimary,
                            ),
                          ),
                          CustomisableDropdown<String>(
                            items: types,
                            hint: "Select payment type",
                            value: selectedType,
                            backgroundColour: CustomColours.darkSurface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            selectedItemTextColour: CustomColours.darkPrimary,
                            unselectedItemTextColour: Colors.grey[300],

                            onChanged: (type) {
                              setState(() {
                                selectedType = type;
                              });
                            },
                            itemBuilder: (value) => Text(value),
                          ),
                          Text(
                            formValid["type"] == true
                                ? ""
                                : "Type cannot be blank!",
                            style: TextStyle(color: CustomColours.darkError),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Will this expense be splitted?",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                Switch(
                  value: toBeSplit,
                  onChanged: (bool value) {
                    setState(() {
                      toBeSplit = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Who paid for it? *",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),

                BlocBuilder<ParticipantBloc, ParticipantState>(
                  builder: (context, state) {
                    if (state is ParticipantLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ParticipantLoaded) {
                      if (state.participants.isEmpty) {
                        return Text("SOMETHING WENT WRONG");
                      }

                      _participants = state.participants;
                      if (!_participants.any(
                        (p) => p.id == selectedParticipant,
                      )) {
                        final admin = _participants.firstWhere(
                          (p) => p.isAdmin,
                          orElse: () => _participants.first,
                        );
                        selectedParticipant = admin.id!;
                      }
                      return CustomisableDropdown<String>(
                        items: _participants.map((p) => p.id!).toList(),
                        hint: "Who paid for it?",
                        value: selectedParticipant,
                        backgroundColour: CustomColours.darkSurface,
                        borderColour: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        borderRadius: 20,
                        menuMaxHeight: 200,
                        selectedItemTextColour: CustomColours.darkPrimary,
                        onChanged: (value) {
                          setState(() {
                            selectedParticipant = value!;
                          });
                        },
                        itemBuilder: (id) {
                          final participant = _participants.firstWhere(
                            (p) => p.id == id,
                          );
                          return Text(participant.particpantName);
                        },
                      );
                    } else if (state is ParticipantError) {
                      return Text("Error: ${state.message}");
                    } else {
                      return const Text("Something went wrong!");
                    }
                  },
                ),
                SizedBox(height: 20),

                Text(
                  "Date Paid *",
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
                          padding: const EdgeInsets.all(5.0),

                          child: Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate!),

                            textAlign: TextAlign.justify,

                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  formValid["datePaid"] == true
                      ? ""
                      : "Date Paid cannot be blank!",
                  style: TextStyle(color: CustomColours.darkError),
                ),

                SizedBox(height: 20),

                Text(
                  "Tags",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                WTagField(
                  onTagsChanged: handleTagsChanged,
                  addedTags: addedTags,
                ),
                SizedBox(height: 20),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                WLargeTextfield(
                  hintText: "Notes",
                  controller: _notesController,
                ),
                SizedBox(height: 20),
                Center(child: _image == null ? Text("") : Image.file(_image!)),
                SizedBox(height: 50),
                BlocConsumer<ExpenseBloc, ExpenseState>(
                  listener: (context, state) {
                    if (state is ExpenseAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Expense created!"),
                          backgroundColor: CustomColours.darkSuccess,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is ExpenseError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to create expense: ${state.message}",
                          ),
                          backgroundColor: CustomColours.darkError,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ExpenseLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          validateDetails();
                        });
                        if (formValid.values.every((v) => v)) {
                          ExpenseModel newExpense = ExpenseModel(
                            name: _expenseNameController.text.trim(),
                            tripId: widget.tripId,
                            participantId: selectedParticipant,
                            paid: double.parse(_paidController.text.trim()),
                            cost: double.parse(_costController.text.trim()),
                            dateTimeAdded: DateTime.now(),
                            datePaid: selectedDate!,
                            currency: selectedCurrency!,
                            toBeSplit: toBeSplit,
                            category: selectedCategory!,
                            type: selectedType!,
                            notes: _notesController.text.isNotEmpty
                                ? _notesController.text
                                : "",
                            tags: addedTags.isNotEmpty ? addedTags : [],
                          );

                          context.read<ExpenseBloc>().add(
                            AddExpense(newExpense),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColours.darkPrimary,
                        foregroundColor: CustomColours.darkBackground,
                        padding: EdgeInsets.all(8.0),
                      ),
                      child: Text(
                        "SUBMIT",
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
