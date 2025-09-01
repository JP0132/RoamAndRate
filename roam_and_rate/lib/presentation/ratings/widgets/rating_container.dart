import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';

class RatingContainer extends StatefulWidget {
  final Function selectedParticipants;
  final List<ParticipantModel> participants;
  final List<double> ratings;
  const RatingContainer({
    super.key,
    required this.selectedParticipants,
    required this.participants,
    required this.ratings,
  });

  @override
  State<RatingContainer> createState() => _RatingContainerState();
}

class _RatingContainerState extends State<RatingContainer> {
  // Number of ratings
  List<int> widgetIndexes = [1];

  @override
  void initState() {
    widgetIndexes = List.generate(
      widget.participants.length,
      (index) => index + 1,
    );
    super.initState();
  }

  void addWidget() {
    setState(() {
      widgetIndexes.add(widgetIndexes.length + 1);
    });
  }

  void removeWidget() {
    setState(() {
      widgetIndexes.removeLast();
    });
  }

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
              if (widgetIndexes.length != 1)
                ElevatedButton(
                  onPressed: removeWidget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColours.darkBackground,
                  ),
                  child: Text(
                    "Remove",
                    style: TextStyle(color: CustomColours.darkError),
                  ),
                ),
              if (widgetIndexes.length < widget.participants.length)
                ElevatedButton(
                  onPressed: addWidget,
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
                .map((index) => _buildNewRating(index))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRating(int index) {
    List<ParticipantModel> _participants = [];
    String? selectedParticipantName;

    return Column(
      children: [
        Text(
          "Rating $index",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: CustomColours.darkPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        RatingInput(initalRating: 0),
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
              return CustomiseableDropdown<String>(
                items: state.participants.map((p) => p.particpantName).toList(),
                hint: "Whose rating?",
                value: selectedParticipantName,
                backgroundColour: CustomColours.darkSecondarySurface,
                borderColour: Colors.transparent,
                padding: EdgeInsets.all(20),
                borderRadius: 20,
                menuMaxHeight: 200,
                selectedItemColour: CustomColours.darkPrimary,
                selectedItemTextColour: CustomColours.darkBackground,
                unselectedItemTextColour: Colors.grey[300],
                selectedTextOverflow: TextOverflow.ellipsis,
                selectedTextMaxLines: 1,
                onChanged: (participant) {
                  setState(() {
                    widget.selectedParticipants(state.participants[index - 1]);
                  });
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
