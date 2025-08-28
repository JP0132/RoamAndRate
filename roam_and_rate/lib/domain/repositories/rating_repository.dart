import 'package:roam_and_rate/domain/models/rate_model.dart';

abstract class RatingRepository {
  Future<List<RateModel>> getRatings();
  Stream<List<RateModel>> watchRatings();
  Future<void> addRating(RateModel rating);
  Future<void> deleteRating(String id);
}
