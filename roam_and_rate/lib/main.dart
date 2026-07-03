import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/currency/currency_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/rating/ratings_bloc.dart';
import 'package:roam_and_rate/application/theme/theme_cubit.dart';
import 'package:roam_and_rate/application/tripData/trip_data_bloc.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/core/themes/app_theme_mode.dart';
import 'package:roam_and_rate/core/themes/app_themes.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/data/local/daos/expense_dao.dart';
import 'package:roam_and_rate/data/local/daos/participant_dao.dart';
import 'package:roam_and_rate/data/local/daos/rating_details_dao.dart';
import 'package:roam_and_rate/data/local/daos/ratings_made_dao.dart';
import 'package:roam_and_rate/data/local/daos/trip_dao.dart';
import 'package:roam_and_rate/data/local/daos/user_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/remote/sync_service.dart';
import 'package:roam_and_rate/data/repositories/expense_repository_impl.dart';
import 'package:roam_and_rate/data/repositories/participant_repository_impl.dart';
import 'package:roam_and_rate/data/repositories/ratings_repository_impl.dart';
import 'package:roam_and_rate/data/repositories/trip_repository_impl.dart';
import 'package:roam_and_rate/data/repositories/user_repository_impl.dart';
import 'package:roam_and_rate/lifecycle_watcher.dart';


Future<void> main() async {
  final db = AppDatabase.instance;
  final userRepository = UserRepositoryImpl(UserDao(db), ParticipantDao(db));
  final tripRepository = TripRepositoryImpl(TripDao(db));
  final participantRepository = ParticipantRepositoryImpl(ParticipantDao(db));
  final expenseRepository = ExpenseRepositoryImpl(ExpenseDao(db));
  final ratingsRepository = RatingsRepositoryImpl(
    RatingDetailsDao(db),
    RatingsMadeDao(db),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager().init();
  //SyncService().startSyncTimer();

  runApp(
    LifecycleWatcher(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => UserBloc(userRepository)),
          BlocProvider(create: (_) => TripBloc(tripRepository)),
          BlocProvider(create: (_) => ParticipantBloc(participantRepository)),
          BlocProvider(create: (_) => ExpenseBloc(expenseRepository)),
          BlocProvider(create: (_) => RatingsBloc(ratingsRepository)),
          BlocProvider(create: (_) => CurrencyBloc()),
          BlocProvider(create: (_) => TripDataBloc(ExpenseDao(db), RatingDetailsDao(db), RatingsMadeDao(db))),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.of(state),
            
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
