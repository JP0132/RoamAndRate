import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/rating/rating_bloc.dart';
import 'package:roam_and_rate/application/rating/rating_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_container.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';

class AddRatingPage extends StatefulWidget {
  const AddRatingPage({super.key});

  @override
  State<AddRatingPage> createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  DateTimeRange? selectedRange;

  double _currentRating = 0.0;

  final List<String> statuses = [
    "Plan to Visit",
    "Visited",
    "On-hold",
    "Dropped",
    "Revisiting",
  ];
  String? selectedStatus = "";

  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  String? selectedValue = "";

  final List<String> categories = [
    "Food & Drink",
    "Tourist Attraction",
    "Accommodation",
    "Shopping",
    "Nature & Outdoors",
    "Wellness",
    "Other",
  ];

  String? selectedCategory;

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

  final Map<String, bool> formValid = {
    "place name": true,
    "location": true,
    "category": true,
    "status": true,
    "date": true,
  };

  void validateDetails() {
    // formValid["tripName"] =
    //     _tripNameController.text.trim().isNotEmpty &&
    //     _tripNameController.text.length > 1;
    // formValid["location"] =
    //     _locationController.text.trim().isNotEmpty &&
    //     _locationController.text.length > 1;
    // formValid["budget"] =
    //     isNumeric(_budgetController.text.trim()) ||
    //     _budgetController.text.trim().isEmpty;
    // formValid["date"] =
    //     selectedRange?.start != null || selectedRange?.end != null;
    // formValid["category"] =
    //     selectedCategory != null && selectedCategory!.isNotEmpty;
    // formValid["currency"] =
    //     selectedCurrency != null && selectedCurrency!.isNotEmpty;
  }

  String getStatusLabel(String? status) {
    if (status == "Visited") return "Date Visited *";
    if (status == "Revisiting") return "Date Revisited *";
    if (status == "Plan to Visit") return "Planned Date *";
    return "Rating"; // default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Rating")),
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
                "Place Name *",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              CustomInputField(
                inputText: "Place Name",
                inputIcon: FaIcon(FontAwesomeIcons.earthEurope),
                controller: _placeNameController,
              ),
              SizedBox(height: 20),

              // Input field to enter the location/address of the place
              Text(
                "Location *",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColours.darkPrimary,
                ),
              ),
              CustomInputField(
                inputText: "Location",
                inputIcon: FaIcon(FontAwesomeIcons.locationDot),
                controller: _locationController,
              ),

              SizedBox(height: 20),

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
                        CustomiseableDropdown<String>(
                          items: categories,
                          hint: "Select which category?",
                          value: selectedCategory,
                          backgroundColour: CustomColours.darkSurface,
                          borderColour: Colors.transparent,
                          padding: EdgeInsets.all(20),
                          borderRadius: 20,
                          menuMaxHeight: 200,
                          selectedItemColour: CustomColours.darkPrimary,
                          selectedItemTextColour: CustomColours.darkBackground,
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
                          "Status *",
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColours.darkPrimary,
                          ),
                        ),
                        CustomiseableDropdown<String>(
                          items: statuses,
                          hint: "What is the status?",
                          value: selectedStatus,
                          backgroundColour: CustomColours.darkSurface,
                          borderColour: Colors.transparent,
                          padding: EdgeInsets.all(20),
                          borderRadius: 20,
                          menuMaxHeight: 200,
                          selectedTextOverflow: TextOverflow.ellipsis,
                          selectedTextMaxLines: 1,
                          selectedTextColour: Colors.deepPurple,
                          selectedTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (stat) {
                            setState(() {
                              selectedStatus = stat;
                            });
                          },
                          itemBuilder: (stat) => Text(stat),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              if (!{"Dropped", "On-hold", ""}.contains(selectedStatus)) ...[
                Text(
                  "Rating",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColours.darkPrimary,
                  ),
                ),
                RatingContainer(
                  selectedParticipants: [""],
                  participants: ["You", "person 1", "person 2"],
                  ratings: [0.0],
                ),
                // RatingInput(
                //   initalRating: 0,
                //   onRatingChanged: (newRating) {
                //     setState(() {
                //       _currentRating = newRating;
                //     });
                //   },
                // ),
                SizedBox(height: 20),

                Row(
                  children: [
                    // Select the date you visted
                    // TODO: If status is marked as planned then disable the field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getStatusLabel(selectedStatus),
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

                    SizedBox(width: 10), // Space between containers
                    // Dropdown to select the value, if the cost was worth it
                    // TODO: Add dollar symbols
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Value",
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColours.darkPrimary,
                            ),
                          ),
                          CustomiseableDropdown<String>(
                            items: value,
                            hint: "How well priced was it?",
                            value: selectedValue,
                            backgroundColour: CustomColours.darkSurface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            itemBuilder: (value) => Text(value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],

              // Select the rating of the place
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
              Center(
                child: _image == null
                    ? Text("No Image added")
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Stack(
                          children: [
                            Image.file(_image!),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => {
                                    setState(() {
                                      _image = null;
                                    }),
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 50),
              BlocConsumer<RatingBloc, RatingState>(
                listener: (context, state) {
                  if (state is RatingAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Rating created!"),
                        backgroundColor: CustomColours.darkSuccess,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is RatingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to create trip: ${state.message}",
                        ),
                        backgroundColor: CustomColours.darkError,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is RatingLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        validateDetails();
                      });
                      if (formValid.values.every((v) => v)) {}
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
