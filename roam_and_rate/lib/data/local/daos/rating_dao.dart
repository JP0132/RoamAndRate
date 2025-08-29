import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/tables/ratings.dart';
import '../database.dart';

part 'rating_dao.g.dart';

@DriftAccessor(tables: [Ratings])
class RatingDao extends DatabaseAccessor<AppDatabase> with _$RatingDaoMixin {
  RatingDao(super.db);

  Future<List<Rating>> getAllRatings() => select(ratings).get();

  Stream<List<Rating>> watchAllRatings() => select(ratings).watch();

  Stream<List<Rating>> watchByTrip(String tripId) {
    return (select(ratings)..where((t) => t.tripId.equals(tripId))).watch();
  }

  Future<void> insertRating(RatingsCompanion rating) =>
      into(ratings).insert(rating);

  Future<void> deleteRating(String id) =>
      (delete(ratings)..where((ratingTbl) => ratingTbl.id.equals(id))).go();

  Future<List<Rating>> getRatingsByTripId(String id) => (select(
    ratings,
  )..where((ratingTbl) => ratingTbl.tripId.equals(id))).get();
}
