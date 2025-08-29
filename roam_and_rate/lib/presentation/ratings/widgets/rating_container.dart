import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/presentation/ratings/widgets/rating_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/customiseable_dropdown.dart';

class RatingContainer extends StatefulWidget {
  final List<String> selectedParticipants;
  final List<String> participants;
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
  List<int> widgetIndexes = [1];

  @override
  void initState() {
    widgetIndexes = List.generate(
      widget.selectedParticipants.length,
      (index) => index + 1,
    );
    super.initState();
  }

  void addWidget() {
    setState(() {
      widgetIndexes.add(widgetIndexes.length + 1);
      widget.selectedParticipants.add("");
    });
  }

  void removeWidget() {
    setState(() {
      widgetIndexes.removeLast();
      widget.selectedParticipants.removeLast();
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
        CustomiseableDropdown<String>(
          items: widget.participants,
          hint: "Select which category?",
          value: widget.selectedParticipants[index - 1],
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
              widget.selectedParticipants[index - 1] = participant!;
            });
          },
          itemBuilder: (value) => Text(value),
        ),
      ],
    );
  }
}
