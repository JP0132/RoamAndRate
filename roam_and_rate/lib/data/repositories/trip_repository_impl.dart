import 'package:roam_and_rate/data/local/daos/trip_dao.dart';
import 'package:roam_and_rate/data/local/mappers/trip_mappers.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripDao dao;

  TripRepositoryImpl(this.dao);

  @override
  Future<void> addTrip(TripModel trip) async {
    await dao.insertTrip(trip.toCompanion());
  }

  @override
  Future<void> editTrip(TripModel trip) async {
    await dao.updateTrip(trip);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await dao.deleteTrip(id);
  }

  @override
  Future<List<TripModel>> getTrips() async {
    final trips = await dao.getAllTrips();
    return trips.map((trip) => trip.toModel()).toList();
  }

  @override
  Stream<List<TripModel>> watchTrips() {
    return dao.watchAllTrips().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }
}
