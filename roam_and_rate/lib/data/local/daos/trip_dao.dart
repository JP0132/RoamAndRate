import 'package:drift/drift.dart';
import 'package:roam_and_rate/data/local/tables/trips.dart';
import '../database.dart';

part 'trip_dao.g.dart';

@DriftAccessor(tables: [Trips])
class TripDao extends DatabaseAccessor<AppDatabase> with _$TripDaoMixin {
  TripDao(AppDatabase db) : super(db);

  Future<List<Trip>> getAllTrips() => select(trips).get();

  Stream<List<Trip>> watchAllTrips() => select(trips).watch();

  Future<void> insertTrip(TripsCompanion trip) => into(trips).insert(trip);

  Future<void> deleteTrip(String id) =>
      (delete(trips)..where((tripTbl) => tripTbl.id.equals(id))).go();
}
