import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class StarRating extends StatelessWidget {
  final int rating; // e.g. 7 means 3 full + 1 half
  final int maxStars;

  const StarRating({super.key, required this.rating, this.maxStars = 5});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating ~/ 2;
    bool hasHalfStar = rating % 2 == 1;

    return Row(
      children: List.generate(maxStars, (index) {
        if (index < fullStars) {
          return const Icon(
            Icons.star,
            color: CustomColours.darkPrimaryVariant,
            size: 20,
          );
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(
            Icons.star_half,
            color: CustomColours.darkPrimaryVariant,
            size: 20,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: CustomColours.darkPrimaryVariant,
            size: 20,
          );
        }
      }),
    );
  }
}
