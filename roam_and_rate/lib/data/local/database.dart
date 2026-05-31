import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roam_and_rate/core/utils/helper/string_list_converter.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/participant_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/daos/trip_dao.dart';
import 'package:roam_and_rate/data/local/daos/user_dao.dart';
import 'package:uuid/uuid.dart';

// Tables
import 'tables/users.dart';
import 'tables/trips.dart';
import 'tables/expenses.dart';
import 'tables/participants.dart';
import 'tables/rating_details.dart';
import 'tables/ratings_made.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Trips,
    Expenses,
    Participants,
    RatingDetails,
    RatingsMade,
    Participants,
  ],
  daos: [
    UserDao,
    TripDao,
    ExpenseDao,
    ParticipantDao,
    RatingsMadeDao,
    RatingDetailsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal([QueryExecutor? executor])
    : super(executor ?? _openConnection());
  static final AppDatabase instance = AppDatabase._internal();

  @override
  int get schemaVersion => 5;
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'roamandrate_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(expenses, expenses.isNotBudget);
      }
      // Updating the categories in expenses
      if (from < 3){
        await customStatement(""" 
         UPDATE expenses
         SET category = 'Health'
         WHERE category = 'Wellness'
        """);

        await customStatement(""" 
         UPDATE expenses
         SET category = 'Stay'
         WHERE category = 'Accommodation'
        """);

        await customStatement(""" 
         UPDATE expenses
         SET category = 'Food'
         WHERE category = 'Food & Drink'
        """);

        await customStatement(""" 
         UPDATE expenses
         SET category = 'Tourism'
         WHERE category = 'Tourist Attraction'
        """);
      }
      // Updating the categories in ratings
      if (from < 5){
        await customStatement(""" 
         UPDATE rating_details
         SET category = 'Health'
         WHERE category = 'Wellness'
        """);

        await customStatement(""" 
         UPDATE rating_details
         SET category = 'Stay'
         WHERE category = 'Accommodation'
        """);

        await customStatement(""" 
         UPDATE rating_details
         SET category = 'Food'
         WHERE category = 'Food & Drink'
        """);

        await customStatement(""" 
         UPDATE rating_details
         SET category = 'Tourism'
         WHERE category = 'Tourist Attraction'
        """);
      }
      
    },
  );
}
