import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/application/rating/ratings_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_container.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/common/customised_date_picker.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_large_textfield.dart';
import 'package:roam_and_rate/presentation/widgets/common/w_tag_field.dart';

class EditRatingPage extends StatefulWidget {
  final RatingDetailsModel rating;
  final RatingsMadeModel? ratingMade;
  final Map<String, Map<String, double>>? participantRatings;
  const EditRatingPage({
    super.key,
    required this.rating,
    this.participantRatings,
    this.ratingMade,
  });

  @override
  State<EditRatingPage> createState() => _EditRatingPageState();
}

class _EditRatingPageState extends State<EditRatingPage> {
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

  List<ParticipantModel> _participants = [];
  Map<String, Map<String, double>> selectedParticipants = {};

  void updateParticipantRatings(Map<String, double> ratings) {
    String ratingToUpdate = selectedStatus == "Plan to Visit"
        ? "expectedRating"
        : "rating";

    setState(() {
      for (var r in ratings.entries) {
        if (selectedParticipants[r.key] == null) {
          selectedParticipants[r.key] = {};
        }
        selectedParticipants[r.key]![ratingToUpdate] = r.value;
      }
    });
  }

  void handleRatingsUpdate(Map<String, double> ratings) {
    String ratingKey = selectedStatus == "Plan to Visit"
        ? "expectedRating"
        : "rating";

    setState(() {
     final updatedParticipants = <String, Map<String, double>>{};

    for (final entry in ratings.entries) {
      updatedParticipants[entry.key] = {
        ratingKey: entry.value,
      };
    }

    selectedParticipants = updatedParticipants;
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
  void initState() {
    super.initState();
    _placeNameController.text = widget.rating.placeName;
    _locationController.text = widget.rating.location;
    _notesController.text = widget.rating.notes;
    selectedCategory = widget.rating.category;
    selectedStatus = widget.rating.status;
    selectedDate = widget.rating.dateVisited ?? DateTime.now();
    selectedValue = widget.rating.value;
    addedTags = widget.rating.tags;
    selectedParticipants = widget.participantRatings != null
        ? widget.participantRatings!
        : {};
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Rating",custom: custom),
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
                // Input field to enter the name of the place
                Text(
                  "Place Name *",
                  style: TextStyle(
                    fontSize: 14,
                    color: custom.primary,
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
                    color: custom.primary,
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
                              color: custom.primary,
                            ),
                          ),
                          CustomisableDropdown<String>(
                            items: Categories.tripCategories.map((e) => e.name).toList(),
                            hint: "Select which category?",
                            value: selectedCategory,
                            backgroundColour: custom.surface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
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
                            selectedItemColour: custom.primary,
                            selectedItemTextColour:
                                custom.background,
                            unselectedItemTextColour: Colors.grey[300],

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
                              color: custom.primary,
                            ),
                          ),
                          CustomisableDropdown<String>(
                            items: statuses,
                            hint: "Select which Status?",
                            value: selectedStatus,
                            backgroundColour: custom.surface,
                            borderColour: Colors.transparent,
                            padding: EdgeInsets.all(20),
                            borderRadius: 20,
                            menuMaxHeight: 200,
                            selectedItemColour: custom.primary,
                            selectedItemTextColour:
                                custom.background,
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
                    "Rating",
                    style: TextStyle(
                      fontSize: 14,
                      color: custom.primary,
                    ),
                  ),

                  // BlocBuilder<RatingsBloc, Ratings()
                  BlocBuilder<ParticipantBloc, ParticipantState>(
                    builder: (context, state) {
                      if (state is ParticipantLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ParticipantLoaded) {
                        if (state.participants.isEmpty) {
                          return Text("SOMETHING WENT WRONG");
                        }

                        _participants = state.participants;

                        List<double> currentRatings = [];
                        List<String> currentRatingParticipants = [];

                        if (selectedStatus == "Plan to Visit") {
                          currentRatings = selectedParticipants.entries
                              .where(
                                (entry) =>
                                    entry.value["expectedRating"] != null,
                              )
                              .map((entry) => entry.value["expectedRating"]!)
                              .toList();
                        } else {
                          currentRatings = selectedParticipants.entries
                              .where((entry) => entry.value["rating"] != null)
                              .map((entry) => entry.value["rating"]!)
                              .toList();
                        }


                        return RatingContainer(
                          key: ValueKey('rating_container_${selectedStatus}'),
                          selectedParticipants: updateParticipantRatings,
                          participants: _participants,
                          ratings: currentRatings,
                          ratingParticipants: selectedParticipants.keys.toList(),
                          editMode: true,
                          onRatingsUpdate: handleRatingsUpdate,
                        );
                      } else if (state is ParticipantError) {
                        return Text("Error: ${state.message}");
                      } else {
                        return const Text("Something went wrong!");
                      }
                    },
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
                                color: custom.primary,
                              ),
                            ),
                            InkWell(
                              onTap: () => _showCustomStyledPicker(),

                              child: Container(
                                decoration: BoxDecoration(
                                  color: custom.surface,

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
                                          color: custom.primary,
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
                                color: custom.primary,
                              ),
                            ),
                            CustomisableDropdown<String>(
                              items: value,
                              hint: "How well priced was it?",
                              value: selectedValue,
                              backgroundColour: custom.surface,
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

                Text(
                  "Tags",
                  style: TextStyle(
                    fontSize: 14,
                    color: custom.primary,
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
                    color: custom.primary,
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
                    if (state is RatingDetailsEdited) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text("Rating created!"),
                          backgroundColor: custom.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is RatingWithParticipantsEdited) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text("Rating created!"),
                          backgroundColor: custom.success,
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

                        RatingDetailsModel updatedRatingDetails = widget.rating
                            .copyWith(
                              placeName: _placeNameController.text.trim(),
                              location: _locationController.text.trim(),
                              category: selectedCategory!,
                              status: selectedStatus!,
                              tags: addedTags,
                              notes: _notesController.text.trim(),
                            );

                        if (!{
                          "Dropped",
                          "On-hold",
                          "",
                          "Plan to Visit",
                        }.contains(selectedStatus)) {
                          Map<String, double> updatedRatingMade = {};
                          selectedParticipants.forEach((participant, rating) {
                            updatedRatingMade[participant] =
                                rating["rating"] ?? 0.0;
                          });
                          RatingDetailsModel updatedRating =
                              updatedRatingDetails.copyWith(
                                dateVisited: selectedDate,
                                value: selectedValue,
                              );
                          context.read<RatingsBloc>().add(
                            EditRatingWithParticipants(
                              updatedRating,
                              updatedRatingMade,
                            ),
                          );
                        } else {
                          // Plan to Visit
                          if (selectedStatus == "Plan to Visit") {
                            Map<String, double> updatedRatingMade = {};
                            selectedParticipants.forEach((participant, rating) {
                              updatedRatingMade[participant] =
                                  rating["expectedRating"] ?? 0.0;
                            });

                            RatingDetailsModel updatedRating =
                                updatedRatingDetails.copyWith(
                                  datePlanned: selectedDate,
                                );
                            context.read<RatingsBloc>().add(
                              EditRatingWithParticipants(
                                updatedRating,
                                updatedRatingMade,
                                expected: true,
                              ),
                            );
                          } else {
                            context.read<RatingsBloc>().add(
                              EditRatingDetails(updatedRatingDetails),
                            );
                          }
                        }
                        if (formValid.values.every((v) => v)) {}
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
