import 'package:roam_and_rate/domain/models/trip_model.dart';

abstract class TripEvent {}

class AddTrip extends TripEvent {
  final TripModel trip;
  AddTrip(this.trip);
}

class EditTrip extends TripEvent {
  final TripModel trip;
  EditTrip(this.trip);
}

class DeleteTrip extends TripEvent {
  final String tripId;
  DeleteTrip(this.tripId);
}
