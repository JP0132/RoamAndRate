import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_event.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_container.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/date_picker/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';

class AddRatingPage extends StatefulWidget {
  final String tripId;
  const AddRatingPage({super.key, required this.tripId});

  @override
  State<AddRatingPage> createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  // List that will be used to store user's participants
  List<ParticipantModel> _participants = [];
  bool _participantsLoaded = false;
  late final StreamSubscription _participantSubscription;

/// Initializes the state of the widget.
/// Requests the participants of the trip and listens for the
/// loaded state exactly once. When the state is loaded, it
/// sets the participants and cancels the subscription.
  @override
  void initState() {
    super.initState();
    // Request participants
    context.read<ParticipantBloc>().add(LoadParticipants());

    // Listen for the loaded state exactly once
    _participantSubscription = context.read<ParticipantBloc>().stream.listen((
      state,
    ) {
      if (state is ParticipantLoaded && !_participantsLoaded) {
        setState(() {
          _participants = state.participants;
          _participantsLoaded = true;
        });
        _participantSubscription.cancel();
      }
    });
  }

  @override
  void dispose() {
    _participantSubscription.cancel();
    super.dispose();
  }

  // TextEditingControllers that will be used to collect user input
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // DateTime that will be used to collect user's date entry
  DateTime? selectedDate = DateTime.now();
  DateTimeRange? selectedRange;

  // Variable that will be used to store user's rating
  double _currentRating = 0.0;

  // Constant list that will be used for the ratings status dropdown
  final List<String> statuses = [
    "Plan to Visit",
    "Visited",
    "On-hold",
    "Dropped",
    "Revisiting",
  ];
  String? selectedStatus = "";

  // Constant list that will be used for the ratings value dropdown
  final List<String> value = ["Cheap", "Just Right", "Expensive"];
  String? selectedValue = "";

  final List<String> categories = [
    "Food & Drink",
    "Tourist Attraction",
    "Accommodation",
    "Shopping",
    "Nature",
    "Wellness",
    "Other",
  ];
  String? selectedCategory;

  // List that will be used to store user's tags
  List<String> addedTags = [];

  // Variable that will be used to store user's image
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Function that will be used to pick user's image
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function that will be used to show user's image
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

  // Function that will be used to handle user's tags
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

  // Map that will be used to store user's and participant ratings
  Map<String, double> selectedParticipants = {};
  void updateParticipantRatings(Map<String, double> ratings) {
    //print("😂😂😂😂adas ${selectedParticipants["Sejal"]}");
    setState(() {
      selectedParticipants = ratings;
    });
  }

  void handleRatingsUpdate(Map<String, double> ratings) {
    setState(() {
      selectedParticipants = ratings;
    });

    // print("Received ratings update:");
    // if (ratings.isEmpty) {
    //   print("  No ratings received");
    // } else {
    //   ratings.forEach((participant, rating) {
    //     print("  ${participant.particpantName}: $rating");
    //   });
    // }
    // print("Total entries: ${ratings.length}");
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
                          CustomisableDropdown<String>(
                            items: categories,
                            hint: "Select which category?",
                            value: selectedCategory,
                            backgroundColour: CustomColours.darkSurface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            selectedItemColour: CustomColours.darkPrimary,
                            selectedItemTextColour:
                                CustomColours.darkBackground,
                            unselectedItemTextColour: Colors.grey[300],
                            //selectedItemTextSize: selectedCategory == "Accommodation" ? 12 : 16,
                            selectedItemBuilder: (value) => Text(
                              value,
                              style: TextStyle(
                                fontSize:
                                    selectedCategory == "Accommodation" ||
                                        selectedCategory == "Tourist Attraction"
                                    ? 12
                                    : 16,
                              ),
                            ),
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
                          CustomisableDropdown<String>(
                            items: statuses,
                            hint: "Select which Status?",
                            value: selectedStatus,
                            backgroundColour: CustomColours.darkSurface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            selectedItemColour: CustomColours.darkPrimary,
                            selectedItemTextColour:
                                CustomColours.darkBackground,
                            unselectedItemTextColour: Colors.grey[300],

                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
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

                if (!{"Dropped", "On-hold", ""}.contains(selectedStatus)) ...[
                  Text(
                    selectedStatus == "Plan to Visit"
                        ? "Expected Rating"
                        : "Rating",
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColours.darkPrimary,
                    ),
                  ),

                  RatingContainer(
                      selectedParticipants: updateParticipantRatings,
                      participants: _participants,
                      onRatingsUpdate: handleRatingsUpdate
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
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),

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
                            CustomisableDropdown<String>(
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
                BlocConsumer<RatingsBloc, RatingsState>(
                  listener: (context, state) {
                    if (state is RatingDetailsAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Rating created!"),
                          backgroundColor: CustomColours.darkSuccess,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is RatingWithParticipantsAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Rating created!"),
                          backgroundColor: CustomColours.darkSuccess,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
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
                        print("🥶🥶🥶🥶");
                        RatingDetailsModel newRatingDetails =
                            RatingDetailsModel(
                              tripId: widget.tripId,
                              placeName: _placeNameController.text.trim(),
                              location: _locationController.text.trim(),
                              category: selectedCategory!,
                              status: selectedStatus!,
                              tags: addedTags,
                              notes: _notesController.text.trim(),
                              createdAt: DateTime.now(),
                            );
                        if (!{
                          "Dropped",
                          "On-hold",
                          "",
                          "Plan to Visit",
                        }.contains(selectedStatus)) {
                          print("👹👹👹👹");
                          Map<String, double> newRatingMade = {};
                          print(selectedParticipants);
                          selectedParticipants.forEach((participant, rating) {
                            print("😂😂😂😂😂😂😂😂🎯 ${rating.toString()}");
                            newRatingMade[participant] = rating;
                          });
                          RatingDetailsModel updatedRatingDetails =
                              newRatingDetails.copyWith(
                                dateVisited: selectedDate,
                                value: selectedValue,
                              );
                          context.read<RatingsBloc>().add(
                            AddRatingWithParticipants(
                              updatedRatingDetails,
                              newRatingMade,
                            ),
                          );
                        } else {
                          if (selectedStatus == "Plan to Visit") {
                            Map<String, double> newPlanRatingMade = {};
                            selectedParticipants.forEach((participant, rating) {
                              newPlanRatingMade[participant] = rating;
                            });

                            RatingDetailsModel updatedRatingDetails =
                                newRatingDetails.copyWith(
                                  datePlanned: selectedDate,
                                );
                            context.read<RatingsBloc>().add(
                              AddRatingWithParticipants(
                                updatedRatingDetails,
                                newPlanRatingMade,
                                expected: true,
                              ),
                            );
                          } else {
                            context.read<RatingsBloc>().add(
                              AddRatingDetails(newRatingDetails),
                            );
                          }
                        }
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
