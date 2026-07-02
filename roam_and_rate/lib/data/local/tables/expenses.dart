import 'package:drift/drift.dart';
import 'package:roam_and_rate/core/utils/helper/string_list_converter.dart';
import 'package:roam_and_rate/data/local/tables/participants.dart';
import 'package:roam_and_rate/data/local/tables/trips.dart';
import 'package:uuid/uuid.dart';

class Expenses extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get tripId =>
      text().references(Trips, #id)(); // Foriegn Key Many to 1
  TextColumn get participantId =>
      text().references(Participants, #id)(); // Many to 1
  BoolColumn get toBeSplit => boolean()();
  BoolColumn get isNotBudget => boolean().withDefault(const Constant(false))();
  TextColumn get expenseName => text()();
  TextColumn get location => text().nullable()();
  TextColumn get category => text()();
  
  // The old way
  RealColumn get paid => real()();
  RealColumn get cost => real()();
  TextColumn get currency => text()();

  // Target Currency Conversion (Users Currency)
  IntColumn get targetPaidAmountMinor => integer().nullable()();
  IntColumn get targetCostAmountMinor => integer().nullable()();
  TextColumn get targetCurrency => text().nullable()();

  // Base Currency Values  (What it is converted from)
  IntColumn get basePaidAmountMinor => integer().nullable()();
  IntColumn get baseCostAmountMinor => integer().nullable()();
  TextColumn get baseCurrency => text().nullable()();

  // Store exact EX rate used
  RealColumn get exchangeRate => real().nullable()();

  // Exchange rateAPI does not have a lot of historical data,
  // so storing the date of the exchange rate
  DateTimeColumn get exchangeRateDate => dateTime().nullable()();

  // Setting a conversion status to indicate if the conversion has been completed
  // this will be used to handle API offline or network issues
  TextColumn get conversionStatus => text().withDefault(const Constant('pending'))();

  TextColumn get splitParticipants => text().map(const StringListConverter()).nullable()();


  DateTimeColumn get datePaid => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get images => text().nullable()();
  TextColumn get type => text()();
  TextColumn get tags => text().map(const StringListConverter())();
  DateTimeColumn get dateAdded => dateTime()();
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
