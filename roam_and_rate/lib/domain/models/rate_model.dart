class RateModel {
  final String rateId;
  final String tripId;
  final String placeName;
  final String location;
  final String category;
  final String status;
  final double rating;
  final DateTime? dateVisited;
  final DateTime? datePlanned;
  final String value;
  final List<String?> tags;
  final String notes;
  final String image;

  const RateModel({
    required this.rateId,
    required this.tripId,
    required this.placeName,
    required this.location,
    required this.category,
    required this.status,
    this.rating = 0.0,
    this.value = "",
    this.tags = const [],
    this.notes = "",
    this.image = "",
    this.dateVisited,
    this.datePlanned,
  });

  RateModel copyWith({
    String? rateId,
    String? tripId,
    String? placeName,
    String? location,
    String? category,
    String? status,
    double? rating,
    DateTime? dateVisited,
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
      dateVisited: dateVisited ?? this.dateVisited,
      value: value ?? this.value,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      image: image ?? this.image,
    );
  }
}
