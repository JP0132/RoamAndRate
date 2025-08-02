import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/pages/bottom_nav/bloc/navigation_event.dart';
import 'package:roam_and_rate/pages/bottom_nav/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeState()) {
    on<NavigateToHome>((event, emit) => emit(HomeState()));
    on<NavigateToAnalytics>((event, emit) => emit(AnalyticsState()));
    on<NavigateToSplits>((event, emit) => emit(SplitNavState()));
    on<NavigateToProfile>((event, emit) => emit(ProfileState()));
    on<NavigateToSettings>((event, emit) => emit(SettingsState()));
  }
}
