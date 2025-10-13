class RatingsMadeModel {
  final String? id;
  final String particpantId;
  final String ratingDetailsId;
  final double rating;
  final double expectedRating;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const RatingsMadeModel({
    this.id,
    required this.particpantId,
    required this.ratingDetailsId,
    required this.createdAt,
    this.rating = 0.0,
    this.expectedRating = 0.0,
    this.lastUpdated
  });

  RatingsMadeModel copyWith({
    String? id,
    String? particpantId,
    String? ratingDetailsId,
    double? rating,
    double? expectedRating,
    DateTime? createdAt,
    DateTime? lastUpdated,

  }) {
    return RatingsMadeModel(
      id: id ?? this.id,
      particpantId: particpantId ?? this.particpantId,
      ratingDetailsId: ratingDetailsId ?? this.ratingDetailsId,
      rating: rating ?? this.rating,
      expectedRating: expectedRating ?? this.expectedRating,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
