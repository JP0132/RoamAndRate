import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/navigation/navigation_event.dart';
import 'package:roam_and_rate/application/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeState()) {
    on<NavigateToHome>((event, emit) => emit(HomeState()));
    on<NavigateToAnalytics>((event, emit) => emit(AnalyticsState()));
    on<NavigateToTrips>((event, emit) => emit(TripsState()));
    on<NavigateToProfile>((event, emit) => emit(ProfileState()));
    on<NavigateToSettings>((event, emit) => emit(SettingsState()));
    on<NavigateToAddTrips>((event, emit) => emit(AddTripPageState()));
  }
}
