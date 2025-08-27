import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/trips/trip_bloc.dart';
import 'package:roam_and_rate/application/user/user_bloc.dart';
import 'package:roam_and_rate/core/themes/theme.dart';
import 'package:roam_and_rate/data/local/daos/trip_dao.dart';
import 'package:roam_and_rate/data/local/daos/user_dao.dart';
import 'package:roam_and_rate/data/local/database.dart';
import 'package:roam_and_rate/data/repositories/trip_repository_impl.dart';
import 'package:roam_and_rate/data/repositories/user_repository_impl.dart';

void main() {
  final db = AppDatabase.instance;
  final userRepository = UserRepositoryImpl(UserDao(db));
  final tripRepository = TripRepositoryImpl(TripDao(db));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(userRepository)),
        BlocProvider(create: (_) => TripBloc(tripRepository)),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomAppTheme.lightTheme,
      darkTheme: CustomAppTheme.darkTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
