import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_event.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/application/user/user_event.dart';
import 'package:roam_and_rate/application/user/user_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/presentation/widgets/bottom_nav/bottom_navbar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EnterUserDetails extends StatefulWidget {
  const EnterUserDetails({super.key});

  @override
  State<EnterUserDetails> createState() => _EnterUserDetailsState();
}

class _EnterUserDetailsState extends State<EnterUserDetails> {
  DateTime? selectedDate;
  String? selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Other',
    'Prefer not to say',
  ];
  final Map<String, bool> formValid = {
    "name": true,
    "username": true,
    "date": true,
    "gender": true,
  };

  void validateDetails() {
    formValid["name"] =
        _nameController.text.trim().isNotEmpty &&
        _nameController.text.length > 1;
    formValid["username"] =
        _nameController.text.trim().isNotEmpty &&
        _nameController.text.length > 1;
    formValid["date"] = checkValidDOB();
    formValid["gender"] = selectedGender != null && selectedGender!.isNotEmpty;
  }

  bool checkValidDOB() {
    if (selectedDate != null) {
      DateTime currentDate = DateTime.now();
      DateTime minValidDate = DateTime(
        currentDate.year - 12,
        currentDate.month,
        currentDate.day,
      );
      return selectedDate!.isBefore(minValidDate) ||
          selectedDate!.isAtSameMomentAs(minValidDate);
    }
    return false;
  }

  void checkIfFormSubmitted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset(
              "assets/images/logo/logopurple.png",
              height: 120,
              width: 120,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),

                // ...formValid.entries.map(
                //   (entry) => Text("${entry.key}, ${entry.value}"),
                // ),
                Center(
                  child: Text(
                    "Enter Your Details",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Full Name",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                SizedBox(height: 10),
                CustomInputField(
                  inputText: "Full Name",
                  inputIcon: FaIcon(FontAwesomeIcons.solidCircleUser),
                  controller: _nameController,
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _nameController,
                  builder: (context, value, child) {
                    return Text(
                      formValid["name"] == true
                          ? ""
                          : "Name cannot be blank or be less than 2 characters!",
                      style: TextStyle(color: custom.error),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "Username",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                SizedBox(height: 10),
                CustomInputField(
                  inputText: "Username",
                  inputIcon: FaIcon(FontAwesomeIcons.solidCircleUser),
                  controller: _usernameController,
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _usernameController,
                  builder: (context, value, child) {
                    return Text(
                      formValid["username"] == true
                          ? ""
                          : "Username cannot be blank or be less than 2 characters!",
                      style: TextStyle(color: custom.error),
                    );
                  },
                ),
                SizedBox(height: 30),
                Text(
                  "Date of Birth",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => _showCustomStyledPicker(),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            selectedDate == null
                                ? "Select your birth date"
                                : DateFormat(
                                    'EEEE, dd MMMM yyyy',
                                  ).format(selectedDate!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  formValid["date"] == true
                      ? ""
                      : "DOB cannot be blank or must be 12 or over!",
                  style: TextStyle(color: custom.error),
                ),
                SizedBox(height: 30),
                Text(
                  "Gender",
                  style: TextStyle(fontSize: 14, color: custom.primary),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CustomisableDropdown<String>(
                    items: genderOptions,
                    hint: "What is your gender?",
                    value: selectedGender,
                    backgroundColour: custom.surface,
                    selectedItemTextColour: custom.background,
                    selectedItemColour: custom.primary,
                    borderColour: Colors.transparent,
                    padding: EdgeInsets.all(20),
                    borderRadius: 20,
                    menuMaxHeight: 120,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    itemBuilder: (currency) => Text(currency),
                  ),
                ),
                Text(
                  formValid["gender"] == true ? "" : "Gender cannot be blank!",
                  style: TextStyle(color: custom.error),
                ),
                SizedBox(height: 50),

                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserLoaded) {
                      // Check if our newly added user is in the list
                      try {
                        final newUser = state.users.firstWhere(
                          (user) => user.username == _usernameController.text,
                        );

                        SessionManager().setUserId(newUser.userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User created!"),
                            backgroundColor: custom.success,
                          ),
                        );
                        SmoothTransitionPage(context, CustomBottomNavbar());
                      } catch (e) {
                        // User not found in the list yet, wait for next update
                      }
                    } else if (state is UserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to create user: ${state.message}",
                          ),
                          backgroundColor: custom.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          validateDetails();
                        });
                        if (formValid.values.every((v) => v)) {
                          final UserModel newUser = UserModel(
                            userId: const Uuid().v4(),
                            fullName: _nameController.text,
                            username: _usernameController.text,
                            dob: selectedDate,
                            gender: selectedGender!,
                            admin: true,
                          );
                          checkIfFormSubmitted();
                          context.read<UserBloc>().add(AddUser(newUser));
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
      ),
    );
  }

  // Basic Single Date Picker

  Future<void> _showEnhancedSingleDatePicker() async {
    final date = await CustomDatePicker.showSingleDatePicker(
      context: context,
      config: DatePickerConfig(
        primaryColor: Colors.blue,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        selectedTextColor: Colors.white,
        todayColor: Colors.orange,
        hoverColor: Colors.grey.shade100,
        enableManualEdit: true,
      ),
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _showCustomStyledPicker() async {
    final custom = Theme.of(context).extension<CustomColours>()!;
    final date = await CustomDatePicker.showSingleDatePicker(
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
