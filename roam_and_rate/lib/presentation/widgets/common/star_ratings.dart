import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class StarRating extends StatelessWidget {
  final int rating; // e.g. 7 means 3 full + 1 half
  final int maxStars;

  const StarRating({super.key, required this.rating, this.maxStars = 5});

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    int fullStars = rating ~/ 2;
    bool hasHalfStar = rating % 2 == 1;

    return Row(
      children: List.generate(maxStars, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: custom.primaryVariant, size: 20);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: custom.primaryVariant, size: 20);
        } else {
          return Icon(
            Icons.star_border,
            color: custom.primaryVariant,
            size: 20,
          );
        }
      }),
    );
  }
}
