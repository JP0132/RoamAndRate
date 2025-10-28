import 'package:flutter/material.dart';

class TripModel {
  final String? tripId;
  final String userId;
  final String tripName;
  final String location;
  final String currency;
  final double budget;
  final String category;
  final String? notes;
  final String? images;
  final String backgroundColor;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const TripModel({
    this.tripId,
    required this.userId,
    required this.tripName,
    required this.location,
    required this.currency,
    this.budget = 0,
    required this.category,
    required this.createdAt,
    this.notes = "",
    this.images = "",
    required this.startDate,
    required this.endDate,
    this.backgroundColor = "default",
    this.lastUpdated
  });

  TripModel copyWith({
    String? tripId,
    String? userId,
    String? location,
    String? tripName,
    String? currency,
    double? budget,
    String? category,
    String? notes,
    String? images,
    String? backgroundColor,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? lastUpdated,


  }) {
    return TripModel(
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      location: location ?? this.location,
      tripName: tripName ?? this.tripName,
      currency: currency ?? this.currency,
      budget: budget ?? this.budget,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
