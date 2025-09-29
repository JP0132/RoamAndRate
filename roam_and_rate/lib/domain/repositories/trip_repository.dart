import '../models/trip_model.dart';

abstract class TripRepository {
  Future<List<TripModel>> getTrips();
  Stream<List<TripModel>> watchTrips();
  Future<void> addTrip(TripModel trip);
  Future<void> deleteTrip(String id);
}
