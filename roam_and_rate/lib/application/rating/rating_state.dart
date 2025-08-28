import 'package:roam_and_rate/domain/models/rate_model.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingAdded extends RatingState {}

class RatingLoaded extends RatingState {
  final List<RateModel> ratings;
  RatingLoaded(this.ratings);
}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}
