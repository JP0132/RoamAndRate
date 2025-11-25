import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';

class RatingContainer extends StatefulWidget {
  final Function selectedParticipants;
  final List<ParticipantModel> participants;
  final List<String>? ratingParticipants;
  final List<double> ratings;
  final bool editMode;
  final Function(Map<String, double>) onRatingsUpdate;
  const RatingContainer({
    super.key,
    required this.selectedParticipants,
    required this.participants,
    required this.ratings,
    required this.onRatingsUpdate,
    this.editMode = false,
    this.ratingParticipants = const [],
  });

  @override
  State<RatingContainer> createState() => _RatingContainerState();
}

class _RatingContainerState extends State<RatingContainer> {
  // Number of ratings
  List<int> widgetIndexes = [];
  List<ParticipantModel?> selectedParticipants = [];
  List<double> ratings = [];

  @override
  void initState() {
    if (widget.editMode) {
      widgetIndexes = List.generate(
        widget.ratings.length,
        (index) => index + 1,
      );
      ratings = List.from(widget.ratings);
      selectedParticipants = widget.ratingParticipants!.map((pId) {
        return widget.participants.firstWhere((p) => p.id == pId);
      }).toList();
    } else {
      widgetIndexes = [1];
      selectedParticipants = List.from(selectedParticipants)..add(null);
      ratings = List.filled(widgetIndexes.length, 0.0);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RatingContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Always update when ratings or participants change, regardless of editMode
    if (oldWidget.ratings != widget.ratings ||
        oldWidget.ratingParticipants != widget.ratingParticipants) {
      setState(() {
        ratings = List.from(widget.ratings);

        if (widget.ratingParticipants != null &&
            widget.ratingParticipants!.isNotEmpty) {
          selectedParticipants = widget.ratingParticipants!.map((pId) {
            return widget.participants.firstWhere(
              (p) => p.id == pId,
              orElse: () => widget.participants.firstWhere(
                (p) => p.particpantName == pId,
                orElse: () => widget.participants.first,
              ),
            );
          }).toList();
        } else {
          selectedParticipants = List.filled(widget.ratings.length, null);
        }

        widgetIndexes = List.generate(widget.ratings.length, (i) => i + 1);
      });
    }
  }

  void addWidget() {
    setState(() {
      widgetIndexes.add(widgetIndexes.length + 1);
      selectedParticipants = List.from(selectedParticipants)..add(null);
      ratings = List.from(ratings)..add(0.0);
    });
  }

  void removeWidget() {
    setState(() {
      widgetIndexes.removeLast();
      selectedParticipants = selectedParticipants.sublist(
        0,
        selectedParticipants.length - 1,
      );
      ratings = ratings.sublist(0, ratings.length - 1);
    });
  }

  void _updateRating(int index, double newRating) {
    setState(() {
      ratings[index] = newRating;
      _sendUpdate();
    });
  }

  void _updateParticipant(int index, ParticipantModel? participant) {
    setState(() {
      selectedParticipants[index] = participant;

      // Only send update if rating is also set
      if (ratings[index] > 0) {
        _sendUpdate();
      }
    });
  }

  // In rating_container.dart, modify the _sendUpdate method:
  void _sendUpdate() {
    // Create a map of participant-rating pairs only when both are set
    final Map<String, double> result = {};
    for (int i = 0; i < selectedParticipants.length; i++) {
      final participant = selectedParticipants[i]?.id;
      final rating = ratings[i];

      // Only include if both participant and rating are set
      if (participant != null && rating > 0) {
        result[participant] = rating;
      }
    }
    widget.onRatingsUpdate(result);
  }

  // In rating_container.dart, update the _sendUpdate method:

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColours.darkSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widgetIndexes.length != 1 ? removeWidget : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColours.darkBackground,
                  disabledBackgroundColor: const Color.fromARGB(
                    255,
                    162,
                    166,
                    182,
                  ),
                  disabledForegroundColor: CustomColours.darkSecondaryText,
                ),

                child: Text(
                  "Remove",
                  style: TextStyle(color: CustomColours.darkError),
                ),
              ),

              ElevatedButton(
                onPressed: widgetIndexes.length < widget.participants.length
                    ? addWidget
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColours.darkBackground,
                ),
                child: Text(
                  "Add",
                  style: TextStyle(color: CustomColours.darkSuccess),
                ),
              ),
            ],
          ),
          Column(
            children: widgetIndexes
                .map((index) => _buildNewRating(index - 1))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRating(int index) {
    List<ParticipantModel> _participants = [];

    return Column(
      children: [
        Text(
          "Rating ${index + 1}",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: CustomColours.darkPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        RatingInput(
          initialRating: ratings[index],
          onRatingChanged: (rating) => _updateRating(index, rating),
        ),
        SizedBox(height: 10),
        BlocBuilder<ParticipantBloc, ParticipantState>(
          builder: (context, state) {
            if (state is ParticipantLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ParticipantLoaded) {
              if (state.participants.isEmpty) {
                return Text("SOMETHING WENT WRONG");
              }

              _participants = state.participants;
              // selectedParticipant = _participants
              //     .where((p) => p.isAdmin)
              //     .first
              //     .particpantName;
              return CustomisableDropdown<String>(
                items: state.participants.map((p) => p.particpantName).toList(),
                hint: "Whose rating?",
                value: selectedParticipants[index]?.particpantName,
                backgroundColour: CustomColours.darkSecondarySurface,
                borderColour: Colors.transparent,
                padding: EdgeInsets.all(20),
                borderRadius: 20,
                menuMaxHeight: 200,
                selectedItemColour: CustomColours.darkPrimary,
                selectedItemTextColour: CustomColours.darkBackground,
                unselectedItemTextColour: Colors.grey[300],

                onChanged: (participantName) {
                  final participant = state.participants.firstWhere(
                    (p) => p.particpantName == participantName,
                  );
                  _updateParticipant(index, participant);
                },
                itemBuilder: (value) => Text(value),
              );
            } else if (state is ParticipantError) {
              return Text("Error: ${state.message}");
            } else {
              return const Text("Something went wrong!");
            }
          },
        ),
      ],
    );
  }
}
