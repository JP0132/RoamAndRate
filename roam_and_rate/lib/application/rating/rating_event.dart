import 'package:roam_and_rate/domain/models/rate_model.dart';

abstract class RatingEvent {}

class AddRating extends RatingEvent {
  final RateModel rating;
  AddRating(this.rating);
}

class DeleteRating extends RatingEvent {
  final String ratingId;
  DeleteRating(this.ratingId);
}
