class ParticipantModel {
  final String? id;
  final String particpantName;
  final bool isAdmin;
  final String userId;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const ParticipantModel({
    this.id,
    required this.particpantName,
    required this.isAdmin,
    required this.createdAt,
    required this.userId,
    this.lastUpdated
  });

  ParticipantModel copyWith({
    String? id,
    String? particpantName,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? lastUpdated,

  }) {
    return ParticipantModel(
      id: id ?? this.id,
      particpantName: particpantName ?? this.particpantName,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      lastUpdated: lastUpdated ?? this.lastUpdated, 
      userId: userId ?? this.userId,
    );
  }
}
