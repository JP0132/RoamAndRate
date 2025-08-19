import 'package:flutter/material.dart';

class TripModel {
  final String tripId;
  final String tripName;
  final String location;
  final String currency;
  final double budget;
  final String category;
  final String notes;
  final String images;
  final Color backgroundColor;
  final DateTime startDate;
  final DateTime endDate;

  const TripModel({
    required this.tripId,
    required this.tripName,
    required this.location,
    this.currency = "",
    this.budget = 0,
    this.category = "Travel",
    this.notes = "",
    this.images = "",
    required this.startDate,
    required this.endDate,
    this.backgroundColor = Colors.white,
  });

  TripModel copyWith({
    String? tripId,
    String? location,
    String? tripName,
    String? currency,
    double? budget,
    String? category,
    String? notes,
    String? images,
    Color? backgroundColor,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TripModel(
      tripId: tripId ?? this.tripId,
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
    );
  }
}
