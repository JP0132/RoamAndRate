class RateModel {
  final String rateId;
  final String tripId;
  final String placeName;
  final String location;
  final String category;
  final String status;
  final double rating;
  final double expectedRating;
  final DateTime? dateVisited;
  final DateTime? datePlanned;
  final DateTime createdAt;
  final String value;
  final List<String> tags;
  final String notes;
  final String image;

  const RateModel({
    required this.rateId,
    required this.tripId,
    required this.placeName,
    required this.location,
    required this.category,
    required this.status,
    required this.createdAt,
    this.rating = 0.0,
    this.value = "",
    this.tags = const [],
    this.notes = "",
    this.image = "",
    this.dateVisited,
    this.datePlanned,
    this.expectedRating = 0.0,
  });

  RateModel copyWith({
    String? rateId,
    String? tripId,
    String? placeName,
    String? location,
    String? category,
    String? status,
    double? rating,
    double? expectedRating,
    DateTime? dateVisited,
    DateTime? datePlanned,
    DateTime? createdAt,
    String? value,
    List<String>? tags,
    String? notes,
    String? image,
  }) {
    return RateModel(
      rateId: rateId ?? this.rateId,
      tripId: tripId ?? this.tripId,
      placeName: placeName ?? this.placeName,
      location: location ?? this.location,
      category: category ?? this.category,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      expectedRating: expectedRating ?? this.expectedRating,
      dateVisited: dateVisited ?? this.dateVisited,
      datePlanned: datePlanned ?? this.datePlanned,
      value: value ?? this.value,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
