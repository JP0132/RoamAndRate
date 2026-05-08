import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_event.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/tag_widget.dart';

class FullRatingCard extends StatefulWidget {
  final RatingDetailsModel ratingDetails;
  final List<RatingsMadeData> participantRatings;
  final List<ParticipantModel> participants;
  const FullRatingCard({
    super.key,
    required this.ratingDetails,
    required this.participantRatings,
    required this.participants,
  });

  @override
  State<FullRatingCard> createState() => _FullRatingCardState();
}

class _FullRatingCardState extends State<FullRatingCard> {
  bool _expanded = false;

  double _calculateAverageRating() {
    if (widget.participantRatings.isEmpty) return 0.0;
    final total = widget.participantRatings.fold<double>(
      0.0,
      (sum, r) =>
          sum +
          (widget.ratingDetails.status == "Plan to Visit"
              ? r.expectedRating ?? 0.0
              : r.rating ?? 0.0),
    );
    return total / widget.participantRatings.length;
  }

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
  Widget build(BuildContext context) {
    final avgRating = _calculateAverageRating();
    return Slidable(
      key: Key(widget.ratingDetails.id!),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder(
            builder: (con) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.editRating,
                    arguments: EditRatingArguments(
                      rating: widget.ratingDetails,
                      participantRatings: {
                        for (var r in widget.participantRatings)
                          r.participantId: {
                            "expectedRating": r.expectedRating ?? 0.0,
                            "rating": r.rating ?? 0.0,
                          },
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.pencil,
                  color: Colors.white,
                  size: 25,
                ),
              );
            },
          ),
          Builder(
            builder: (con) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: CustomColours.darkSurface,
                      title: const Text("Delete Rating?"),
                      content: const Text(
                        "Are you sure you want to delete this rating? This action is irreversible.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<RatingsBloc>().add(
                              DeleteRating(widget.ratingDetails.id!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Rating deleted successfully!'),
                                backgroundColor: CustomColours.darkSuccess,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: CustomColours.darkError),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                  size: 25,
                ),
              );
            },
          ),
        ],
      ),

      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CustomColours.darkSurface,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Left - Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: CustomColours.darkPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    Helperfunctions.getCatIcon(widget.ratingDetails.category),
                    color: CustomColours.darkBackground,
                  ),
                ),

                const SizedBox(width: 16),

                // Place Name + Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ratingDetails.placeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CustomColours.darkSecondarySurface,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          widget.ratingDetails.status == "Plan to Visit"
                              ? DateFormat(
                                  'EE, dd MMM yyyy',
                                ).format(widget.ratingDetails.datePlanned!)
                              : widget.ratingDetails.dateVisited != null
                              ? DateFormat(
                                  'EE, dd MMM yyyy',
                                ).format(widget.ratingDetails.dateVisited!)
                              : "No date provided",
                          style: const TextStyle(
                            fontSize: 12,
                            color: CustomColours.darkSecondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right - Avg Rating
                Column(
                  children: [
                    Text(
                      (avgRating * 2).toStringAsFixed(1),
                      style: const TextStyle(
                        color: CustomColours.darkSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "Avg",
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColours.darkSecondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  widget.ratingDetails.status == "Plan to Visit"
                      ? "Your Expected Ratings"
                      : "Your Ratings",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
              ),
            ),

            // Participant Ratings
            if (widget.participantRatings.isNotEmpty)
              Column(
                children: widget.participantRatings.asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final pRating = entry.value;
                  final participantName = widget.participants.firstWhere(
                    (pn) => pn.id == pRating.participantId,
                  );
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == widget.participantRatings.length - 1
                          ? 0
                          : 4,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 60, child: Text(participantName.particpantName)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...List.generate(5, (starIdx) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                    ),
                                    child: _buildStar(
                                      starIdx,
                                      widget.ratingDetails.status ==
                                              "Plan to Visit"
                                          ? pRating.expectedRating ?? 0.0
                                          : pRating.rating ?? 0.0,
                                    ),
                                  );
                                }),
                                SizedBox(width: 10),
                                widget.ratingDetails.status == "Plan to Visit"
                                    ? Text(
                                        "${(pRating.expectedRating! * 2).truncate()} / 10",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CustomColours.darkPrimaryText,
                                        ),
                                      )
                                    : Text(
                                        "${(pRating.rating! * 2).truncate()} / 10",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CustomColours.darkPrimaryText,
                                        ),
                                      ),
                              ],
                            ),

                            const Spacer(),
                            Text(
                              widget.ratingDetails.status == "Plan to Visit"
                                  ? Helperfunctions.getRatingDescription(
                                      (pRating.expectedRating! * 2).truncate(),
                                    )
                                  : Helperfunctions.getRatingDescription(
                                      (pRating.rating! * 2).truncate(),
                                    ),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: CustomColours.darkPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: CustomColours.darkPrimary,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 8),

            // Tags
            LayoutBuilder(
              builder: (context, constraints) {
                final visibleTags = _expanded
                    ? widget.ratingDetails.tags
                    : widget.ratingDetails.tags.take(3).toList();

                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    ...visibleTags.map((tag) => TagWidget(label: tag)),
                    if (widget.ratingDetails.tags.length > 3)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColours.darkPrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int index, double currentRating) {
    double starValue = index + 1.0;

    if (currentRating >= starValue) {
      // Full star
      return Icon(
        Icons.star,
        size: 25,
        color: CustomColours.darkPrimaryVariant,
      );
    } else if (currentRating >= starValue - 0.5) {
      // Half star
      return Icon(
        Icons.star_half,
        size: 25,
        color: CustomColours.darkPrimaryVariant,
      );
    } else {
      // Empty star
      return Icon(
        Icons.star_border,
        size: 25,
        color: CustomColours.darkPrimaryVariant,
      );
    }
  }
}
