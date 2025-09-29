import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:drift/drift.dart';

extension TripEntityMapper on Trip {
  TripModel toModel() {
    return TripModel(
      tripId: id,
      userId: userId,
      tripName: tripName,
      location: location,
      currency: currency,
      category: category,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      budget: budget,
      notes: notes,
      backgroundColor: bgColour,
    );
  }
}

extension TripModelMapper on TripModel {
  TripsCompanion toCompanion() {
    return TripsCompanion.insert(
      id: tripId != null ? Value(tripId!) : const Value.absent(),
      userId: userId,
      tripName: tripName,
      location: location,
      currency: currency,
      budget: budget,
      category: category,
      bgColour: backgroundColor,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
    );
  }
}
