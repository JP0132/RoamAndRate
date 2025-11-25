import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';

abstract class RatingsEvent {}

class AddRatingDetails extends RatingsEvent {
  final RatingDetailsModel ratingDetails;
  AddRatingDetails(this.ratingDetails);
}

class DeleteRatingDetails extends RatingsEvent {
  final String ratingDetailsId;
  DeleteRatingDetails(this.ratingDetailsId);
}

class EditRatingDetails extends RatingsEvent {
  final RatingDetailsModel ratingDetails;
  EditRatingDetails(this.ratingDetails);
}

class AddRatingsMade extends RatingsEvent {
  final RatingsMadeModel ratingsMade;
  AddRatingsMade(this.ratingsMade);
}

class DeleteRatingsMade extends RatingsEvent {
  final String ratingsMadeId;
  DeleteRatingsMade(this.ratingsMadeId);
}

class DeleteRating extends RatingsEvent {
  final String ratingDetailsId;
  DeleteRating(this.ratingDetailsId);
}

class EditRatingsMade extends RatingsEvent {
  final RatingsMadeModel ratingsMade;
  EditRatingsMade(this.ratingsMade);
}

class AddRatingWithParticipants extends RatingsEvent {
  final RatingDetailsModel ratingDetails;
  final Map<String, double> participantRatings;
  final bool expected;

  AddRatingWithParticipants(this.ratingDetails, this.participantRatings, {this.expected = false});
}

class AddExpectedRatingWithParticipants extends RatingsEvent {
  final RatingDetailsModel ratingDetails;
  final Map<String, double> participantRatings;

  AddExpectedRatingWithParticipants(this.ratingDetails, this.participantRatings);
}

class EditRatingWithParticipants extends RatingsEvent {
  final RatingDetailsModel ratingDetails;
  final Map<String, double> participantRatings;
  final bool expected;


  EditRatingWithParticipants(this.ratingDetails, this.participantRatings, {this.expected = false});
}

class FetchRatingsAndDetails extends RatingsEvent {}
