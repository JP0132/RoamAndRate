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
import 'package:roam_and_rate/presentation/expenses/widgets/chevron_toggle.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/numpad.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/option_widget.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/common/dashed_border_container.dart';
import 'package:roam_and_rate/presentation/widgets/common/sub_headings.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/show_custom_styled_picker.dart';

class AddExpensePage extends StatefulWidget {
  final TripModel tripDetails;
  final List<ParticipantModel> participants;
  const AddExpensePage({
    super.key,
    required this.tripDetails,
    required this.participants,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final  sessionManager = SessionManager();
  String? userCurrency = "";

  String _convertedAmount = "0.00";
  String _converstionRate = "";

  DateTime? selectedDate = DateTime.now();
  bool toBeSplit = false;
  bool isBudget = true;
  bool isPayeeSelectorOpen = false;

  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  final List<String> types = ["card", "cash", "bank transfer"];

  List<ParticipantModel> _participants = [];
  String selectedParticipant = "";
  List<ParticipantModel> selectedSplitParticipants = [];

  ParticipantModel? selectedPayee;

  String? selectedCategory;
  String? selectedType;
  String? selectedCurrency;

  List<String> addedTags = [];

  String _lastPaidValue = "";

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.tripDetails.currency;
    userCurrency = sessionManager.userCurrency;

    final admin = widget.participants.firstWhere(
      (p) => p.isAdmin,
      orElse: () => widget.participants.first,
    );
    selectedPayee = admin;
    selectedSplitParticipants.add(admin);

    print("🥶🥶🥶🥶 ${selectedSplitParticipants.first.particpantName}");

    _paidController.addListener(() {
      _updateConversion();

      if (_costController.text.isEmpty ||
          _costController.text == _lastPaidValue) {
        _costController.text = _paidController.text;
      }
      _lastPaidValue = _paidController.text;
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
      target: userCurrency!.toUpperCase(),
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
      appBar: CustomAppBar(title: "New Expense", custom: custom),
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
                    color: custom.surface.withValues(alpha: 0.6),
                    border: Border.all(color: custom.surface),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "AMOUNT PAID",
                              style: TextStyle(
                                color: custom.secondaryText.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
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
                              borderColour: custom.secondaryText,
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

                      Row(
                        children: [
                          Text(
                            CurrencyData.currencySymbolFromCode(
                              selectedCurrency!,
                            ),
                            style: TextStyle(
                              color: custom.secondaryText,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _paidController,
                              readOnly: true,
                              style: TextStyle(
                                color: custom.primaryText,
                                fontSize: 40,
                              ),
                              decoration: InputDecoration(
                                hintText: "Paid Amount",
                                hintStyle: TextStyle(
                                  color: custom.secondaryText,
                                ),
                                contentPadding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                iconColor: custom.primary,
                                filled: false,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(color: custom.primary),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Converted to  ${userCurrency!.toUpperCase()}",
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

                SubHeadings(custom: custom, text: "COST BREAKDOWN"),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: custom.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: custom.secondarySurface),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("LISTED COST"),
                            CustomInputField(
                              inputText: "0.00",
                              controller: _costController,
                              numberKeyBoard: true,
                              regFilter: Values.decimalOnlyRegExp,
                              inputFieldColour: custom.secondarySurface,
                              inputPadding: 0,

                              prefix: Text(
                                CurrencyData.currencySymbolFromCode(
                                  selectedCurrency!,
                                ),
                                style: TextStyle(
                                  color: custom.primaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              formValid["cost"] == true
                                  ? ""
                                  : "Cost cannot be blank!",
                              style: TextStyle(color: custom.error),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: custom.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: custom.secondarySurface),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PAID"),
                            CustomInputField(
                              inputText: "0.00",
                              controller: _paidController,
                              numberKeyBoard: true,
                              regFilter: Values.decimalOnlyRegExp,
                              inputFieldColour: custom.secondarySurface,
                              inputPadding: 0,
                              isReadOnly: true,
                              prefix: Text(
                                CurrencyData.currencySymbolFromCode(
                                  selectedCurrency!,
                                ),
                                style: TextStyle(
                                  color: custom.primaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              formValid["paid"] == true
                                  ? ""
                                  : "Paid cannot be blank!",
                              style: TextStyle(color: custom.error),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Category Selection
                SubHeadings(custom: custom, text: "Category"),

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
                              color: selectedCategory == e.name
                                  ? custom
                                        .categoryColours[e.name.toLowerCase()]!
                                        .withValues(alpha: 0.2)
                                  : custom.surface.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: selectedCategory == e.name
                                  ? Border.all(
                                      color:
                                          custom.categoryColours[e.name
                                              .toLowerCase()]!,
                                    )
                                  : Border.all(color: custom.surface),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: custom
                                        .categoryColours[e.name.toLowerCase()]!
                                        .withValues(alpha: 0.3),
                                    border: Border.all(
                                      color:
                                          custom.categoryColours[e.name
                                              .toLowerCase()]!,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FaIcon(
                                    e.icon,
                                    size: 30,
                                    color: custom
                                        .categoryColours[e.name.toLowerCase()],
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

                // Details Section - Expense Name, Date Paid, Payment Method and Location
                SubHeadings(custom: custom, text: "Details"),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: custom.surface.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: custom.surface),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
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
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.alignLeft,
                                  color: custom.icon,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "EXPENSE NAME",
                                    style: TextStyle(
                                      color: custom.secondaryText,
                                    ),
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
                        SizedBox(height: 12),
                        Divider(color: custom.primary, thickness: 2),
                        Row(
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
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.locationDot,
                                  color: custom.icon,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 4,
                                      left: 2,
                                    ),
                                    child: Text(
                                      "LOCATION",
                                      style: TextStyle(
                                        color: custom.secondaryText,
                                        fontSize: 12,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  CustomInputField(
                                    inputText: "Where you spent it?",
                                    inputFieldColour: custom.secondarySurface,
                                    controller: _locationController,
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
                        SizedBox(height: 12),
                        Divider(color: custom.primary, thickness: 2),
                        Row(
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
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.calendar,
                                  color: custom.icon,
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => ShowPicker.showCustomStyledPicker(
                                  context,
                                  selectedDate,
                                  _setDate,
                                ),

                                child: Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: custom.surface,

                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "DATE",
                                              style: TextStyle(
                                                color: custom.secondaryText,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                'dd/MM/yyyy',
                                              ).format(selectedDate!),

                                              textAlign: TextAlign.justify,

                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          color: custom.icon,
                                        ),
                                      ],
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
                          ],
                        ),
                        Divider(color: custom.primary, thickness: 2),
                        const SizedBox(height: 10),
                        Text(
                          "PAYMENT TYPE",
                          style: TextStyle(color: custom.secondaryText),
                        ),
                        GridView.count(
                          crossAxisCount: 3,
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.5,
                          children: types
                              .map(
                                (type) => GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedType = type),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedType == type
                                          ? custom.secondarySurface
                                          : custom.secondarySurface.withValues(
                                              alpha: 0.6,
                                            ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                        color: selectedType == type
                                            ? custom.primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        type.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: custom.primary),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
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
                ),

                const SizedBox(height: 20),

                SubHeadings(custom: custom, text: "Options"),
                const SizedBox(height: 5),

                OptionWidget(
                  custom: custom,
                  icon: FontAwesomeIcons.arrowsSplitUpAndLeft,
                  action: Switch(
                    value: toBeSplit,
                    onChanged: (bool value) {
                      setState(() {
                        toBeSplit = value;
                      });
                    },
                  ),
                  title: 'Split Expense',
                  subtitle: 'Divide this cost between people',
                  expanded: _buildSplitExpanded(custom),
                  expandedState: toBeSplit,
                ),
                SizedBox(height: 10),
                OptionWidget(
                  custom: custom,
                  icon: FontAwesomeIcons.wallet,
                  action: Switch(
                    value: isBudget,
                    onChanged: (bool value) {
                      setState(() {
                        isBudget = value;
                      });
                    },
                  ),
                  title: 'Include in Budget',
                  subtitle: 'Count this towards your budget',
                  expanded: Column(),
                  expandedState: isBudget,
                ),

                OptionWidget(
                  custom: custom,
                  icon: FontAwesomeIcons.solidCircleUser,
                  action: IconButton(
                    onPressed: () {
                      setState(() {
                        isPayeeSelectorOpen = !isPayeeSelectorOpen;
                      });
                    },
                    icon: ChevronToggle(isExpanded: isPayeeSelectorOpen),
                  ),
                  title: 'Who Paid?',
                  subtitle: selectedPayee!.particpantName,
                  expanded: Column(),
                  expandedState: isPayeeSelectorOpen,
                ),
                const SizedBox(height: 10),

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

                SubHeadings(custom: custom, text: "Tags"),

                WTagField(
                  onTagsChanged: handleTagsChanged,
                  addedTags: addedTags,
                ),
                SizedBox(height: 20),

                SubHeadings(custom: custom, text: "Notes"),

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
                            isNotBudget: !isBudget,
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

  double get _splitAmountPerPerson {
    final paid = double.tryParse(_paidController.text) ?? 0.0;

    if (selectedSplitParticipants.isEmpty) {
      return 0.0;
    }

    return paid / selectedSplitParticipants.length;
  }

  double get _splitConvertedPerPerson {
    final paidConverted = double.tryParse(_convertedAmount) ?? 0.0;

    if (selectedSplitParticipants.isEmpty) {
      return 0.0;
    }

    return paidConverted / selectedSplitParticipants.length;
  }

  Widget _buildSplitExpanded(CustomColours custom) {
    String splitAmount = "";

    void showParticipantsDialog() {
      final rootContext = context;

      showDialog(
        context: rootContext,
        builder: (dialogContext) {
          final tempSelected = List.of(selectedSplitParticipants);

          return StatefulBuilder(
            builder: (context, setDialogState) {
              final isEmpty = tempSelected.isEmpty;

              return AlertDialog(
                title: SubHeadings(custom: custom, text: "Split Among?"),

                content: SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView.builder(
                    itemCount: widget.participants.length,
                    itemBuilder: (context, index) {
                      final participant = widget.participants[index];

                      final isSelected = tempSelected.any(
                        (p) => p.id == participant.id,
                      );

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setDialogState(() {
                            if (isSelected) {
                              tempSelected.removeWhere(
                                (p) => p.id == participant.id,
                              );
                            } else {
                              tempSelected.add(participant);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? custom.success
                                  : custom.primary.withValues(alpha: .3),
                              width: 1.2,
                            ),
                            color: isSelected
                                ? custom.success.withValues(alpha: 0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                child: Text(
                                  participant.particpantName
                                      .substring(0, 1)
                                      .toUpperCase(),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  participant.particpantName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              if (isSelected)
                                Icon(Icons.check_circle, color: custom.success),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Cancel"),
                  ),

                  TextButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            setState(() {
                              selectedSplitParticipants
                                ..clear()
                                ..addAll(tempSelected);
                            });

                            Navigator.pop(dialogContext);
                          },
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Split among", style: TextStyle(color: custom.secondaryText)),
            Text(
              " ${selectedSplitParticipants.length}",
              style: TextStyle(color: custom.primaryText),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...selectedSplitParticipants.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: custom.secondarySurface,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: custom.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                p.particpantName.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: custom.secondarySurface, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(p.particpantName, style: TextStyle(color: custom.primaryText, fontWeight: FontWeight.bold, fontSize: 18),),
                            SizedBox(width: 4,),
                            p.isAdmin ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: custom.secondary.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(child: Text(" ${p.isAdmin ? "YOU" : ""}", style: TextStyle(color: custom.primaryText, fontSize: 10),)),
                            ) : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "${CurrencyData.currencySymbolFromCode(selectedCurrency!)} ${_splitAmountPerPerson.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: custom.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${CurrencyData.currencySymbolFromCode(userCurrency!.toUpperCase())}${_splitConvertedPerPerson.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: custom.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => showParticipantsDialog(),
          child: DashedBorderContainer(
            borderColour: custom.primary,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: custom.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: FaIcon(FontAwesomeIcons.plus)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Add/Remove a person"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
