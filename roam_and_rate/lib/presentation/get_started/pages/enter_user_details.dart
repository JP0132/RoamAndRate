import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/application/user/user_event.dart';
import 'package:roam_and_rate/application/user/user_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/user_model.dart';
import 'package:roam_and_rate/presentation/widgets/bottom_nav/bottom_navbar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';

class EnterUserDetails extends StatefulWidget {
  const EnterUserDetails({super.key});

  @override
  State<EnterUserDetails> createState() => _EnterUserDetailsState();
}

class _EnterUserDetailsState extends State<EnterUserDetails> {
  DateTime? selectedDate;
  String? selectedGender;
  final TextEditingController _nameController = TextEditingController();

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Other',
    'Prefer not to say',
  ];
  final Map<String, bool> formValid = {
    "name": true,
    "date": true,
    "gender": true,
  };

  void handleSubmit() async {
    setState(() {
      validateDetails();
    });
    // Check if all values are true
    if (formValid.values.every((v) => v)) {
      // All fields are valid, proceed
      final UserModel newUser = UserModel(
        fullName: _nameController.text,
        dob: selectedDate,
        gender: selectedGender!,
      );

      context.read<UserBloc>().add(AddUser(newUser));
      SmoothTransitionPage(context, CustomBottomNavbar());
    }
  }

  void validateDetails() {
    formValid["name"] =
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
      body: Padding(
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
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
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
                    style: TextStyle(color: CustomColours.darkError),
                  );
                },
              ),
              SizedBox(height: 30),
              Text(
                "Date of Birth",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              SizedBox(height: 10),
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
                style: TextStyle(color: CustomColours.darkError),
              ),
              SizedBox(height: 30),
              Text(
                "Gender",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              SizedBox(height: 10),
              CustomiseableDropdown<String>(
                items: genderOptions,
                value: selectedGender,
                backgroundColour: CustomColours.darkSurface,
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
                menuMaxHeight: 200,
              ),
              Text(
                formValid["gender"] == true ? "" : "Gender cannot be blank!",
                style: TextStyle(color: CustomColours.darkError),
              ),
              SizedBox(height: 50),

              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User created!"),
                        backgroundColor: CustomColours.darkSuccess,
                      ),
                    );
                    SmoothTransitionPage(context, CustomBottomNavbar());
                  } else if (state is UserError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to create user: ${state.message}",
                        ),
                        backgroundColor: CustomColours.darkError,
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
                          fullName: _nameController.text,
                          dob: selectedDate,
                          gender: selectedGender!,
                        );
                        context.read<UserBloc>().add(AddUser(newUser));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColours.darkPrimary,
                      foregroundColor: CustomColours.darkBackground,
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

              // ElevatedButton(
              //   onPressed: () => handleSubmit(),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: CustomColours.darkPrimary,
              //     foregroundColor: CustomColours.darkBackground,
              //     padding: EdgeInsets.all(8.0),
              //   ),
              //   child: Text(
              //     "Submit",
              //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              //   ),
              // ),
            ],
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
