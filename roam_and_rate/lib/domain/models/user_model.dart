class UserModel {
  final String? userId;
  final String fullName;
  final String username;
  final DateTime? dob;
  final String gender;
  final bool admin;

  const UserModel({
    this.userId,
    required this.fullName,
    required this.username,
    required this.dob,
    required this.gender,
    required this.admin,
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? username,
    DateTime? dob,
    String? gender,
    bool? admin,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      admin: admin ?? this.admin,
      fullName: fullName ?? this.fullName,
    );
  }
}
