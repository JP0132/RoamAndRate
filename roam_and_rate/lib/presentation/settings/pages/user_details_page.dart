import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/application/user/user_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/common/customised_date_picker.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
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

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Scaffold(
      appBar: AppBar(title: Text("User's Details"), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                // Check if we have any users
                if (state.users.isEmpty) {
                  return const Text("No users found");
                }

                // Find the admin user
                try {
                  final adminUser = state.users.firstWhere(
                    (user) => user.admin == true,
                  );

                  _nameController.text = adminUser.fullName;
                  _usernameController.text = adminUser.username;
                  selectedGender = adminUser.gender;
                  selectedDate = adminUser.dob;

                  return Column(
                    children: [
                      Center(
                        child: Text(
                          "Enter Your Details",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 14,
                          color: custom.primary,
                        ),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: custom.primary,
                        ),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: custom.primary,
                        ),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: custom.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomisableDropdown<String>(
                        items: genderOptions,
                        value: selectedGender,
                        backgroundColour: custom.surface,
                        borderColour: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        borderRadius: 20,
                        hint: 'Select your gender',
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        itemBuilder: (gender) => Text(gender),
                        menuMaxHeight: 100,
                      ),
                      Text(
                        formValid["gender"] == true
                            ? ""
                            : "Gender cannot be blank!",
                        style: TextStyle(color: custom.error),
                      ),
                    ],
                  );
                } catch (e) {
                  return const Text("No admin user found");
                }
              } else if (state is UserError) {
                return Text("Error: ${state.message}");
              } else {
                return const Text("Something went wrong!");
              }
            },
          ),
        ),
      ),
    );
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
