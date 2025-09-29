import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/mappers/ratings_made_mappers.dart';
import 'package:roam_and_rate/data/local/tables/ratings_made.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import '../database.dart';

part 'ratings_made_dao.g.dart';

@DriftAccessor(tables: [RatingsMade])
class RatingsMadeDao extends DatabaseAccessor<AppDatabase>
    with _$RatingsMadeDaoMixin {
  RatingsMadeDao(super.db);

  Future<List<RatingsMadeData>> getAllRatingsMade() =>
      select(ratingsMade).get();

  Stream<List<RatingsMadeData>> watchAllRatingsMade() =>
      select(ratingsMade).watch();

  Future<void> insertRatingsMade(RatingsMadeCompanion rating) async {
    print("${rating.participantId} ${rating.ratingDetailsId}");
    await into(ratingsMade).insert(rating);
  }

  Future<void> deleteRatingsMade(String id) =>
      (delete(ratingsMade)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> updateRatingsMade(RatingsMadeModel rating) {
    return (update(
      ratingsMade,
    )..where((tbl) => tbl.id.equals(rating.id!))).write(rating.toCompanion());
  }

  Future<List<RatingsMadeData>> getRatingsMadeByDetailsId(
    String ratingDetailsId,
  ) => (select(
    ratingsMade,
  )..where((tbl) => tbl.ratingDetailsId.equals(ratingDetailsId))).get();

  Future<List<RatingsMadeData>> getRatingsMadeByParticipantId(
    String participantId,
  ) => (select(
    ratingsMade,
  )..where((tbl) => tbl.participantId.equals(participantId))).get();
}
