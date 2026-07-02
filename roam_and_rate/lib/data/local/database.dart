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
  int get schemaVersion => 11;
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
      if (from < 3) {
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
      if (from < 5) {
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

      if (from < 6) {
        await migrator.addColumn(users, users.currency);
      }

      if (from < 7) {
        // await migrator.addColumn(expenses, expenses.originalPaidAmountMinor);
        // await migrator.addColumn(expenses, expenses.originalCostAmountMinor);
        await migrator.addColumn(expenses, expenses.basePaidAmountMinor);
        await migrator.addColumn(expenses, expenses.baseCostAmountMinor);

        // await migrator.addColumn(expenses, expenses.originalCurrency);
        await migrator.addColumn(expenses, expenses.baseCurrency);

        await migrator.addColumn(expenses, expenses.exchangeRate);
        await migrator.addColumn(expenses, expenses.exchangeRateDate);

        await customStatement("""
            UPDATE expenses
            SET original_paid_amount_minor = CAST(ROUND(paid * 100) AS INTEGER),
            original_cost_amount_minor = CAST(ROUND(cost * 100) AS INTEGER),
            base_paid_amount_minor = CAST(ROUND(paid * 100) AS INTEGER),
            base_cost_amount_minor = CAST(ROUND(cost * 100) AS INTEGER),
            original_currency = currency,
            exchange_rate = 1.0
        """);
      }

      if (from < 8) {
        await customStatement("""
            ALTER TABLE expenses RENAME COLUMN original_cost_amount_minor TO target_cost_amount_minor;
        """);
        await customStatement("""
            ALTER TABLE expenses RENAME COLUMN original_paid_amount_minor TO target_paid_amount_minor;
        """);

        await customStatement("""
            ALTER TABLE expenses RENAME COLUMN original_currency TO target_currency;
        """);
      }

      if (from < 9) {
        await migrator.addColumn(expenses, expenses.conversionStatus);

        await customStatement("""
            UPDATE expenses
            SET conversion_status = 'completed'
            WHERE target_paid_amount_minor IS NOT NULL
        """);

        await customStatement("""
            UPDATE expenses
            SET conversion_status = 'pending'
            WHERE target_paid_amount_minor IS NULL
        """);

      }

      if(from < 10){
        await migrator.addColumn(expenses, expenses.location);
      }

      if(from < 11){
        await migrator.addColumn(expenses, expenses.splitParticipants);
      }

    },
  );
}
