import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/data/local/tables/ratings_made.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/star_ratings.dart';

class RatingCards extends StatefulWidget {
  final String name;
  final String category;
  //final int rating;
  final DateTime? dateRated;
  final List<RatingsMadeModel> ratingsMade;

  const RatingCards({
    super.key,
    required this.name,
    //required this.rating,
    required this.dateRated,
    required this.ratingsMade,
    required this.category,
  });

  @override
  State<RatingCards> createState() => _RatingCardsState();
}

class _RatingCardsState extends State<RatingCards> {
  IconData? getCatIcon(String category) {
    for (CategoryModel c in Categories.expenseCategories) {
      if (c.name == category) {
        return c.icon;
      }
    }
    return FontAwesomeIcons.question;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColours.darkSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          // Left - Circle Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColours.darkPrimary,
            ),
            child: Icon(
              getCatIcon(widget.category),
              color: CustomColours.darkSurface,
            ),
          ),

          SizedBox(width: 16),

          // Middle - Name and Stars (takes remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.dateRated == null
                          ? 'Unrated'
                          : DateFormat(
                              'EE, dd MMM yyyy',
                            ).format(widget.dateRated!),
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColours.darkSecondaryText,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),
                widget.ratingsMade.isEmpty
                    ? Text(
                        'No rating available',
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColours.darkSecondaryText,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: widget.ratingsMade
                            .map(
                              (rm) => Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CustomColours.darkSecondaryText,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StarRating(rating: (rm.rating * 2).toInt()),
                                    Text(
                                      Helperfunctions.getRatingDescription(
                                        (rm.rating * 2).toInt(),
                                      ),
                                      style: TextStyle(
                                        color: CustomColours.darkPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),

                //StarRating(rating: widget.rating),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
