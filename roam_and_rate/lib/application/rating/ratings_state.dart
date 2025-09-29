import 'package:roam_and_rate/domain/models/rating_details_model.dart';
import 'package:roam_and_rate/domain/models/ratings_made_model.dart';

abstract class RatingsState {}

class RatingInitial extends RatingsState {}

class RatingLoading extends RatingsState {}

class RatingDetailsAdded extends RatingsState {}

class RatingDetailsEdited extends RatingsState {}

class RatingsMadeAdded extends RatingsState {}

class RatingsMadeEdited extends RatingsState {}

class RatingWithParticipantsAdded extends RatingsState {}

class RatingWithParticipantsEdited extends RatingsState {}

class RatingDeleted extends RatingsState {}

class RatingDetailsLoaded extends RatingsState {
  final List<RatingDetailsModel> ratingDetails;
  RatingDetailsLoaded(this.ratingDetails);
}

class RatingsMadeLoaded extends RatingsState {
  final List<RatingsMadeModel> ratingsMade;
  RatingsMadeLoaded(this.ratingsMade);
}

class RatingError extends RatingsState {
  final String message;
  RatingError(this.message);
}

class RatingsAndDetailsLoaded extends RatingsState {
  final List<RatingDetailsModel> ratingDetails;
  final List<RatingsMadeModel> ratingsMade;

  RatingsAndDetailsLoaded(this.ratingDetails, this.ratingsMade);
}
