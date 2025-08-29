class RatingsMadeModel {
  final String id;
  final String particpantId;
  final String ratingDetailsId;
  final double rating;
  final double expectedRating;

  const RatingsMadeModel({
    required this.id,
    required this.particpantId,
    required this.ratingDetailsId,
    this.rating = 0.0,
    this.expectedRating = 0.0,
  });

  RatingsMadeModel copyWith({
    String? id,
    String? particpantId,
    String? ratingDetailsId,
    double? rating,
    double? expectedRating,
  }) {
    return RatingsMadeModel(
      id: id ?? this.id,
      particpantId: particpantId ?? this.id,
      ratingDetailsId: ratingDetailsId ?? this.ratingDetailsId,
      rating: rating ?? this.rating,
      expectedRating: expectedRating ?? this.expectedRating,
    );
  }
}
