import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:super_tooltip/super_tooltip.dart';

class RatingInput extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const RatingInput({
    super.key,
    required this.onRatingChanged,
    required this.initialRating,
  });

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  double _currentRating = 0.0;
  final _controller = SuperTooltipController();

  final List<String> defaultRatingDescriptions = [
    'Stellar',
    'Great',
    'V. good',
    'Good',
    'Fine',
    'Average',
    'Bad',
    'Very Bad',
    'Horrible',
    'Avoid',
  ];

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _handleStarTap(int starIndex) {
    setState(() {
      double newRating;
      double starValue = starIndex + 1.0;

      // Check if this is the same star that was last tapped
      if (_currentRating == starValue - 0.5) {
        // Second tap on same star - fill it completely
        newRating = starValue;
      } else {
        // First tap on star - fill previous stars completely and this one half
        newRating = starValue - 0.5;
      }

      _currentRating = newRating;
      widget.onRatingChanged(_currentRating);
    });
  }

  void makeTooltip() {
    _controller.showTooltip();
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: custom.secondarySurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => _handleStarTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: _buildStar(index),
                ),
              );
            }),
          ),
          SizedBox(width: 10),
          Column(
            children: [
              Text(
                "${(_currentRating * 2).truncate()} / 10",
                style: TextStyle(
                  fontSize: 14,
                  color: custom.primaryText,
                ),
              ),
              Text(
                Helperfunctions.getRatingDescription(
                  (_currentRating * 2).truncate(),
                ),
                style: TextStyle(
                  color: custom.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              await _controller.showTooltip();
            },
            child: SuperTooltip(
              controller: _controller,
              content: SizedBox(
                width: 250, // Fixed width to prevent overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Star examples
                    Row(
                      children: [
                        Icon(
                          Icons.star_half,
                          color: custom.primary,
                          size: 20,
                        ),
                        Text(" = 1 point"),
                        SizedBox(width: 15),
                        Icon(
                          Icons.star,
                          color: custom.primary,
                          size: 20,
                        ),
                        Text(" = 2 points"),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Instructions
                    Text(
                      "How to rate:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text("• Tap once to half fill (1 point)"),
                    Text("• Tap twice to fill completely (2 points)"),

                    SizedBox(height: 12),

                    // Rating descriptions
                    Text(
                      "Rating meanings:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),

                    // Use Container with height constraint instead of ListView
                    SizedBox(
                      height: 200, // Fixed height
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: defaultRatingDescriptions.reversed
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                int rating = entry.key + 1;
                                String description = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "$rating - $description",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Icon(
                Icons.info_outline,
                color: custom.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    double starValue = index + 1.0;

    if (_currentRating >= starValue) {
      // Full star
      return Icon(
        Icons.star,
        size: 40,
        color: custom.primaryVariant,
      );
    } else if (_currentRating >= starValue - 0.5) {
      // Half star
      return Icon(
        Icons.star_half,
        size: 40,
        color: custom.primaryVariant,
      );
    } else {
      // Empty star
      return Icon(
        Icons.star_border,
        size: 40,
        color: custom.primaryVariant,
      );
    }
  }
}

// Widget emptyStars(Color colour) {

//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: List.generate(
//       5,
//       (index) => InkWell(
//         onTap: () => {if (index > 0) {}},
//         child: Icon(
//           Icons.star_border,
//           color: custom.primaryVariant,
//           size: 40,
//         ),
//       ),
//     ),
//   );
// }
