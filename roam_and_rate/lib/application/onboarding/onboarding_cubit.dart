import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/app_router.dart';

class OnboardingState {
  final int currentPage;
  final PageController pageController;

  OnboardingState({required this.currentPage, required this.pageController});
}

class OnboardingCubit extends Cubit<OnboardingState> {
  late BuildContext context;
  OnboardingCubit(this.context)
    : super(OnboardingState(currentPage: 0, pageController: PageController()));

  void pageChanged(int page) {
    emit(
      OnboardingState(currentPage: page, pageController: state.pageController),
    );
  }

  void nextPage() {
    if (state.currentPage == 2) {
      Navigator.pushReplacementNamed(context, AppRouter.enterUserDetails);
    }
    final nextPage = (state.currentPage + 1) % 3;

    state.pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    emit(
      OnboardingState(
        currentPage: nextPage,
        pageController: state.pageController,
      ),
    );
  }

  void skipPage() {
    Navigator.pushReplacementNamed(context, AppRouter.enterUserDetails);
  }

  void dotNavigationClick(int page) {
    if (page == 3) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    state.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    emit(
      OnboardingState(currentPage: page, pageController: state.pageController),
    );
  }
}
