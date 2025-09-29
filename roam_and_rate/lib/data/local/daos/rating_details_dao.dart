import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/mappers/rating_details_mappers.dart';
import 'package:roam_and_rate/data/local/tables/rating_details.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import '../database.dart';

part 'rating_details_dao.g.dart';

@DriftAccessor(tables: [RatingDetails])
class RatingDetailsDao extends DatabaseAccessor<AppDatabase>
    with _$RatingDetailsDaoMixin {
  RatingDetailsDao(super.db);

  Future<List<RatingDetail>> getAllRatingDetails() =>
      select(ratingDetails).get();

  Stream<List<RatingDetail>> watchAllRatingDetails() =>
      select(ratingDetails).watch();

  Stream<List<RatingDetail>> watchByTrip(String tripId) {
    return (select(
      ratingDetails,
    )..where((t) => t.tripId.equals(tripId))).watch();
  }

  Future<void> insertRatingDetails(RatingDetailsCompanion ratingDetail) async {
    print("😂😂 IN THE DAO ratingDetailsid: ${ratingDetail.id}");
    await into(ratingDetails).insert(ratingDetail);
  }

  Future<void> deleteRatingDetails(String id) =>
      (delete(ratingDetails)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateRatingDetails(RatingDetailsModel ratingDetail) {
    return (update(ratingDetails)
          ..where((tbl) => tbl.id.equals(ratingDetail.id!)))
        .write(ratingDetail.toCompanion());
  }

  Future<List<RatingDetail>> getRatingDetailsByTripId(String id) =>
      (select(ratingDetails)..where((tbl) => tbl.tripId.equals(id))).get();
}
