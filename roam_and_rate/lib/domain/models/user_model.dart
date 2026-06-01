class UserModel {
  final String? userId;
  final String fullName;
  final String username;
  final DateTime? dob;
  final String currency;
  final String gender;
  final bool admin;
  final DateTime? lastUpdated;

  const UserModel({
    this.userId,
    required this.fullName,
    required this.username,
    required this.currency,
    required this.dob,
    required this.gender,
    required this.admin,
    this.lastUpdated
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? username,
    DateTime? dob,
    String? gender,
    bool? admin,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      admin: admin ?? this.admin,
      currency: currency ?? this.currency,
      fullName: fullName ?? this.fullName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
