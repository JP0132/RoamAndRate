import 'package:roam_and_rate/data/local/daos/rating_dao.dart';
import 'package:roam_and_rate/data/local/mappers/rating_mapper.dart';
import 'package:roam_and_rate/domain/models/rate_model.dart';
import 'package:roam_and_rate/domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingDao dao;
  RatingRepositoryImpl(this.dao);

  @override
  Future<void> addRating(RateModel rating) async {
    await dao.insertRating(rating.toCompanion());
  }

  @override
  Future<void> deleteRating(String id) async {
    await dao.deleteRating(id);
  }

  @override
  Future<List<RateModel>> getRatings() async {
    final ratings = await dao.getAllRatings();
    return ratings.map((rating) => rating.toModel()).toList();
  }

  @override
  Stream<List<RateModel>> watchRatings() {
    return dao.watchAllRatings().map(
      (rows) => rows.map((e) => e.toModel()).toList(),
    );
  }
}
