import 'package:flutter/material.dart';

class UserModel {
  final String? userId;
  final String fullName;
  final DateTime? dob;
  final String gender;

  const UserModel({
    this.userId,
    required this.fullName,
    required this.dob,
    required this.gender,
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    DateTime? dob,
    String? gender,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
