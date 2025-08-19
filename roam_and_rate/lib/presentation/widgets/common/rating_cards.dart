import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/presentation/widgets/common/star_ratings.dart';

class RatingCards extends StatefulWidget {
  final String name;
  final int rating;
  final DateTime dateRated;

  const RatingCards({
    super.key,
    required this.name,
    required this.rating,
    required this.dateRated,
  });

  @override
  State<RatingCards> createState() => _RatingCardsState();
}

class _RatingCardsState extends State<RatingCards> {
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
          ),

          SizedBox(width: 16),

          // Middle - Name and Stars (takes remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                StarRating(rating: widget.rating),
              ],
            ),
          ),

          // Right - Date and Rating Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('EE, dd MMM yyyy').format(widget.dateRated),
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColours.darkSecondaryText,
                ),
              ),
              SizedBox(height: 20),
              Text(
                Helperfunctions.getRatingDescription(widget.rating),
                style: TextStyle(
                  color: CustomColours.darkPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
