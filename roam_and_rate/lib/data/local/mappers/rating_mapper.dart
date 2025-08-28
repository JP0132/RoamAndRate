import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';

extension RatingEntityMapper on Rating {
  RateModel toModel() {
    return RateModel(
      rateId: id,
      tripId: tripId,
      placeName: "",
      location: "",
      category: '',
      status: '',
    );
  }
}

extension RateModelMapper on RateModel {
  RatingsCompanion toCompanion() {
    return RatingsCompanion.insert(
      tripId: tripId,
      placeName: placeName,
      location: location,
      category: category,
      status: status,
      tags: tags,
      rating: Value(rating),
      value: Value(value),
      datePlanned: Value(datePlanned),
      dateVisited: Value(dateVisited),
      notes: Value(notes),
      images: Value(image),
    );
  }
}
