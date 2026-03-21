import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/participant_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/daos/trip_dao.dart';
import 'package:roam_and_rate/data/local/daos/user_dao.dart';

import 'package:roam_and_rate/domain/repositories/backup_repository.dart';

class BackupRepositoryImpl implements BackupRepository {
  final ExpenseDao expenseDao;
  final UserDao userDao;
  final ParticipantDao participantDao;
  final RatingsMadeDao ratingsMadeDao;
  final RatingDetailsDao ratingDetailsDao;
  final TripDao tripDao;

  BackupRepositoryImpl(
    this.expenseDao,
    this.userDao,
    this.participantDao,
    this.ratingsMadeDao,
    this.ratingDetailsDao,
    this.tripDao,
  );

  @override
  Future addBackUpData(dynamic backupData) async {
    final user = backupData["user"];
    final trips = backupData["trips"];
    final expenses = backupData["expenses"];
    final participants = backupData["participants"];
    final ratingsMade = backupData["ratingsMade"];
    final ratingDetails = backupData["ratingDetails"];

    await userDao.insertUser(user.toCompanion());

    for (var p in participants) {
      await participantDao.insertParticipant(p.toCompanion());
    }

    for (var t in trips) {
      await tripDao.insertTrip(t.toCompanion);
    }

    for (var e in expenses) {
      await expenseDao.insertExpense(e.toCompanion);
    }

    for (var rd in ratingDetails) {
      await ratingDetailsDao.insertRatingDetails(rd.toCompanion);
    }

    for (var rm in ratingsMade) {
      await ratingsMadeDao.insertRatingsMade(rm.toCompanion);
    }
  }
}
