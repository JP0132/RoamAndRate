class RatingDetailsModel {
  final String? id;
  final String tripId;
  final String placeName;
  final String location;
  final String category;
  final String status;
  final DateTime? dateVisited;
  final DateTime? datePlanned;
  final DateTime createdAt;
  final String value;
  final List<String> tags;
  final String notes;
  final String image;
  final DateTime? lastUpdated;

  const RatingDetailsModel({
    this.id,
    required this.tripId,
    required this.placeName,
    required this.location,
    required this.category,
    required this.status,
    required this.createdAt,
    this.value = "",
    this.tags = const [],
    this.notes = "",
    this.image = "",
    this.dateVisited,
    this.datePlanned,
    this.lastUpdated
  });

  RatingDetailsModel copyWith({
    String? id,
    String? tripId,
    String? placeName,
    String? location,
    String? category,
    String? status,
    DateTime? dateVisited,
    DateTime? datePlanned,
    DateTime? createdAt,
    String? value,
    List<String>? tags,
    String? notes,
    String? image,
    DateTime? lastUpdated,

  }) {
    return RatingDetailsModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      placeName: placeName ?? this.placeName,
      location: location ?? this.location,
      category: category ?? this.category,
      status: status ?? this.status,
      dateVisited: dateVisited ?? this.dateVisited,
      datePlanned: datePlanned ?? this.datePlanned,
      value: value ?? this.value,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
