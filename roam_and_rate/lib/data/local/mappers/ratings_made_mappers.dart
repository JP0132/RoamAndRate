import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';

extension RatingsMadeModelMapper on RatingsMadeModel {
  RatingsMadeModel toModel() {
    return RatingsMadeModel(
      id: id,
      particpantId: particpantId,
      ratingDetailsId: ratingDetailsId,
      createdAt: createdAt,
      expectedRating: expectedRating,
      rating: rating,
    );
  }

  RatingsMadeCompanion toCompanion() {
    return RatingsMadeCompanion.insert(
      ratingDetailsId: ratingDetailsId,
      participantId: particpantId,
      createdAt: createdAt,
      rating: Value(rating),
      expectedRating: Value(expectedRating),
    );
  }
}
