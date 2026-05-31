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
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/constants/values.dart';
import 'package:roam_and_rate/core/utils/helper/currency_helper.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/numpad.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/show_custom_styled_picker.dart';

class AddExpensePage extends StatefulWidget {
  final TripModel tripDetails;
  const AddExpensePage({super.key, required this.tripDetails});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final SessionManager _sessionManager = SessionManager();

  String _convertedAmount = "0.00";
  String _converstionRate = "";

  DateTime? selectedDate = DateTime.now();
  bool toBeSplit = false;
  bool isNotBudget = false;

  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  final List<String> types = ["card", "cash", "bank transfer"];

  List<ParticipantModel> _participants = [];
  String selectedParticipant = "";

  String? selectedCategory;
  String? selectedType;
  String? selectedCurrency;

  List<String> addedTags = [];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.tripDetails.currency;
    _paidController.addListener(() {
      _updateConversion();
    });
  }

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

  void _setDate(DateTime date) async => setState(() => selectedDate = date);

  double _amount = 0.0;

  Future<void> _updateConversion() async {
    final amount = double.tryParse(_paidController.text);

    if (amount == null) {
      setState(() {
        _convertedAmount = "0.00";
      });
      return;
    }

    final result = await CurrencyHelper().getConvertedAmount(
      base: selectedCurrency!.toUpperCase(),
      target: widget.tripDetails.currency.toUpperCase(),
      value: amount,
    );

    if (mounted) {
      setState(() {
        _convertedAmount = result ?? "0.00";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Expense")),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _showPickOptionsDialog(context),
        backgroundColor: custom.primary,
        foregroundColor: custom.background,
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
                Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: custom.surface,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Amount Paid",
                              style: TextStyle(
                                color: custom.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomisableDropdown<String>(
                              items: CurrencyData.fiatCurrenciesCodes,
                              hint: "What currency did you use?",
                              value: selectedCurrency,
                              backgroundColour: custom.surface,
                              selectedItemTextColour: custom.surface,
                              unselectedItemTextColour: custom.primary,
                              selectedItemColour: custom.primary,
                              borderColour: custom.primary,
                              padding: EdgeInsets.all(5),
                              borderRadius: 20,
                              menuMaxHeight: 200,
                              onChanged: (value) {
                                setState(() {
                                  // final code = CurrencyData.getCodeFromName(
                                  //   value!,
                                  // );
                                  selectedCurrency = value;
                                  _updateConversion();
                                });
                              },
                              itemBuilder: (currency) => Text(currency),
                            ),
                          ),
                        ],
                      ),

                      TextFormField(
                        controller: _paidController,
                        readOnly: true,
                        style: TextStyle(color: custom.primary, fontSize: 30),
                        decoration: InputDecoration(
                          hintText: "Paid Amount",
                          hintStyle: TextStyle(color: custom.secondaryText),
                          icon: FaIcon(FontAwesomeIcons.dollarSign),
                          iconColor: custom.primary,
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),

                      Divider(color: custom.primary),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Converted to  ${widget.tripDetails.currency}",
                                style: TextStyle(
                                  color: custom.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                " ≈ $_convertedAmount",
                                style: TextStyle(
                                  color: custom.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Numpad(controller: _paidController),

                SizedBox(height: 20),
                // Input field to enter the name of the place
                Text(
                  "Expense Name *",
                  style: TextStyle(fontSize: 14, color: custom.primary),
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
                  style: TextStyle(color: custom.error),
                ),
                SizedBox(height: 20), // Space between containers
                // How much it costed
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cost *",
                      style: TextStyle(fontSize: 14, color: custom.primary),
                    ),
                    CustomInputField(
                      inputText: "Cost",
                      inputIcon: FaIcon(FontAwesomeIcons.moneyBill1Wave),
                      controller: _costController,
                      numberKeyBoard: true,
                      regFilter: Values.decimalOnlyRegExp,
                    ),
                    Text(
                      formValid["cost"] == true ? "" : "Cost cannot be blank!",
                      style: TextStyle(color: custom.error),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text("CATEGORY", style: TextStyle(color: custom.secondaryText)),

                GridView.count(
                  primary: false,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),
                  children: Categories.categories
                      .map(
                        (e) => GestureDetector(
                          onTap: () => setState(() {
                            selectedCategory = e.name;
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: custom.surface,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: selectedCategory == e.name
                                  ? Border.all(color: custom.primary)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: custom.primary,
                                    border: Border.all(color: custom.primary),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FaIcon(
                                    e.icon,
                                    size: 30,
                                    color: custom.surface,
                                  ),
                                ),
                                Text(e.name),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Text(
                  formValid["category"] == true
                      ? ""
                      : "Category cannot be blank!",
                  style: TextStyle(color: custom.error),
                ),

                SizedBox(height: 20),
                Text("DETAILS", style: TextStyle(color: custom.secondaryText)),
                Container(
                  decoration: BoxDecoration(
                    color: custom.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: custom.secondarySurface,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child:  Center(child: FaIcon(FontAwesomeIcons.alignLeft, color: custom.icon,)),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "EXPENSE NAME",
                                style: TextStyle(color: custom.secondaryText),
                              ),
                              CustomInputField(
                                inputText: "What you spent it on?",
                                inputFieldColour: custom.secondarySurface,
                                controller: _expenseNameController,
                                inputPadding: 4,
                              ),

                              if (formValid["expenseName"] != true)
                                Text(
                                  "Name cannot be blank!",
                                  style: TextStyle(color: custom.error),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
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
                              color: custom.primary,
                            ),
                          ),
                          CustomisableDropdown<String>(
                            items: types,
                            hint: "Select payment type",
                            value: selectedType,
                            backgroundColour: custom.surface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            selectedItemTextColour: custom.primary,
                            unselectedItemTextColour: custom.primaryText,

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
                            style: TextStyle(color: custom.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Will this expense be splitted?",
                  style: TextStyle(fontSize: 14, color: custom.primary),
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
                  "Do you want to include it in your budget?",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                Switch(
                  value: isNotBudget,
                  onChanged: (bool value) {
                    setState(() {
                      isNotBudget = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Who paid for it? *",
                  style: TextStyle(fontSize: 14, color: custom.primary),
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
                        backgroundColour: custom.surface,
                        borderColour: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        borderRadius: 20,
                        menuMaxHeight: 200,
                        selectedItemTextColour: custom.primary,
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
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                InkWell(
                  onTap: () => ShowPicker.showCustomStyledPicker(
                    context,
                    selectedDate,
                    _setDate,
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      color: custom.surface,

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
                              color: custom.primary,
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
                  style: TextStyle(color: custom.error),
                ),

                SizedBox(height: 20),

                Text(
                  "Tags",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                WTagField(
                  onTagsChanged: handleTagsChanged,
                  addedTags: addedTags,
                ),
                SizedBox(height: 20),
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 14, color: custom.primary),
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
                        SnackBar(
                          content: Text("Expense created!"),
                          backgroundColor: custom.success,
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
                          backgroundColor: custom.error,
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
                            tripId: widget.tripDetails.tripId!,
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
                            isNotBudget: isNotBudget,
                          );

                          context.read<ExpenseBloc>().add(
                            AddExpense(newExpense),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: custom.primary,
                        foregroundColor: custom.background,
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
}
