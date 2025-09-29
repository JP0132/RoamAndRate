class ParticipantModel {
  final String? id;
  final String particpantName;
  final bool isAdmin;
  final DateTime createdAt;

  const ParticipantModel({
    this.id,
    required this.particpantName,
    required this.isAdmin,
    required this.createdAt,
  });

  ParticipantModel copyWith({
    String? id,
    String? particpantName,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      particpantName: particpantName ?? this.particpantName,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
