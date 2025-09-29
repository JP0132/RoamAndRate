import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';

extension RatingDetailsEntityMapper on RatingDetail {
  RatingDetailsModel toModel() {
    return RatingDetailsModel(
      id: id,
      tripId: tripId,
      placeName: placeName,
      location: location,
      category: category,
      status: status,
      createdAt: createdAt,
      value: value!,
      tags: tags,
      notes: notes!,
      datePlanned: datePlanned,
      dateVisited: dateVisited,
    );
  }
}

extension RatingDetailsMapper on RatingDetailsModel {
  RatingDetailsCompanion toCompanion() {
    return RatingDetailsCompanion.insert(
      id: Value(id!),
      tripId: tripId,
      placeName: placeName,
      location: location,
      category: category,
      status: status,
      tags: tags,
      value: Value(value),
      datePlanned: datePlanned != null
          ? Value(datePlanned!)
          : const Value.absent(),
      dateVisited: dateVisited != null
          ? Value(dateVisited!)
          : const Value.absent(),
      notes: Value(notes),
      images: Value(image),
      createdAt: createdAt,
    );
  }
}
