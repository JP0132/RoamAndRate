import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';

abstract class RatingsRepository {
  Future<List<RatingDetailsModel>> getRatingDetails();
  Stream<List<RatingDetailsModel>> watchRatingDetails();
  Future<void> addRatingDetails(RatingDetailsModel ratingDetails);
  Future<void> deleteRatingDetails(String id);
  Future<void> editRatingDetails(RatingDetailsModel ratingDetails);

  Future<List<RatingsMadeModel>> getRatingsMade();
  Stream<List<RatingsMadeModel>> watchRatingsMade();
  Future<void> addRatingsMade(RatingsMadeModel ratingsMade);
  Future<void> deleteRatingsMade(String id);
  Future<void> editRatingsMade(RatingsMadeModel ratingsMade);
  Future<List<RatingsMadeModel>> getRatingsMadeByRatingDetailsId(
    String ratingDetailsId,
  );

  Future<void> addRatingWithParticipants(
    RatingDetailsModel ratingDetails,
    Map<String, double> participantRatings,
  );
}
