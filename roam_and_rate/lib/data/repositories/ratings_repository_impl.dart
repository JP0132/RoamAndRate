import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/local/mappers/rating_details_mappers.dart';
import 'package:roam_and_rate/data/local/mappers/ratings_made_mappers.dart';
import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';
import 'package:roam_and_rate/domain/repositories/ratings_repository.dart';
import 'package:uuid/uuid.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  final RatingDetailsDao ratingDetailsDao;
  final RatingsMadeDao ratingsMadeDao;

  RatingsRepositoryImpl(this.ratingDetailsDao, this.ratingsMadeDao);

  @override
  Future<void> addRatingDetails(RatingDetailsModel ratingDetails) async {
    // final id = ratingDetails.id ?? const Uuid().v4();
    // final withId = ratingDetails.copyWith(id: id);
    print("🚀 Repository.addRatingWithParticipants called");
    if (ratingDetails.id == null) {
      String id = const Uuid().v4();
      final upadtedRD = ratingDetails.copyWith(id: id);
      await ratingDetailsDao.insertRatingDetails(upadtedRD.toCompanion());
    } else {
      await ratingDetailsDao.insertRatingDetails(ratingDetails.toCompanion());
    }
  }

  @override
  Future<void> deleteRatingDetails(String id) async {
    await ratingDetailsDao.deleteRatingDetails(id);
  }

  @override
  Future<void> editRatingDetails(RatingDetailsModel ratingDetails) async {
    await ratingDetailsDao.updateRatingDetails(ratingDetails);
  }

  @override
  Future<List<RatingDetailsModel>> getRatingDetails() async {
    final ratingDetails = await ratingDetailsDao.getAllRatingDetails();
    return ratingDetails.map((detail) => detail.toModel()).toList();
  }

  @override
  Stream<List<RatingDetailsModel>> watchRatingDetails() {
    return ratingDetailsDao.watchAllRatingDetails().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }

  @override
  Future<void> addRatingsMade(RatingsMadeModel ratingsMade) async {
    await ratingsMadeDao.insertRatingsMade(ratingsMade.toCompanion());
  }

  @override
  Future<void> deleteRatingsMade(String id) async {
    await ratingsMadeDao.deleteRatingsMade(id);
  }

  @override
  Future<void> editRatingsMade(RatingsMadeModel ratingsMade) async {
    await ratingsMadeDao.updateRatingsMade(ratingsMade);
  }

  RatingsMadeModel fromDataToModel(RatingsMadeData data) {
    return RatingsMadeModel(
      id: data.id,
      particpantId: data.participantId,
      ratingDetailsId: data.ratingDetailsId,
      createdAt: data.createdAt,
      expectedRating: data.expectedRating!,
      rating: data.rating!,
    );
  }

  @override
  Future<List<RatingsMadeModel>> getRatingsMade() async {
    final ratingsMade = await ratingsMadeDao.getAllRatingsMade();
    return ratingsMade.map((rating) => fromDataToModel(rating)).toList();
  }

  @override
  Stream<List<RatingsMadeModel>> watchRatingsMade() {
    return ratingsMadeDao.watchAllRatingsMade().map(
      (rows) => rows.map((e) => fromDataToModel(e)).toList(),
    );
  }

  @override
  Future<void> addRatingWithParticipants(
    RatingDetailsModel ratingDetails,
    Map<String, double> participantRatings,
  ) async {
    print("🚀 Repository.addRatingWithParticipants called");
    print("😂😂 AM HERE");
    final ratingDetailsId = ratingDetails.id ?? const Uuid().v4();
    final ratingDetailsWithId = ratingDetails.copyWith(id: ratingDetailsId);

    print("😂😂😂😂 ratingDetails: ${ratingDetailsWithId.placeName}");

    // First, add the rating details
    await addRatingDetails(ratingDetailsWithId);
    // await ratingDetailsDao.insertRatingDetails(

    // );

    print("😂😂 ratingDetailsid: ${ratingDetailsWithId.id}");

    // Then, add all the participant ratings
    for (final entry in participantRatings.entries) {
      print("😂😂 id: ${entry.key} ${entry.value}");
      final ratingsMade = RatingsMadeModel(
        particpantId: entry.key,
        ratingDetailsId: ratingDetailsId,
        rating: entry.value,
        expectedRating: 0.0,
        createdAt: DateTime.now(),
      );

      await ratingsMadeDao.insertRatingsMade(ratingsMade.toCompanion());
    }
  }

  @override
  Future<List<RatingsMadeModel>> getRatingsMadeByRatingDetailsId(
    String ratingDetailsId,
  ) async {
    final ratingsMade = await ratingsMadeDao.getAllRatingsMade();
    return ratingsMade
        .where((rm) => rm.id == ratingDetailsId)
        .map((r) => fromDataToModel(r))
        .toList();
  }
}
