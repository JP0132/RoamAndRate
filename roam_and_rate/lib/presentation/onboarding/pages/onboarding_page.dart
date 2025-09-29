import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/application/onboarding/onboarding_cubit.dart';
import 'package:roam_and_rate/core/utils/constants/images.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/presentation/onboarding/widgets/onboarding_step.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // TODO: Initialize onboarding page logic
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(context),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return PageView(
                  controller: state.pageController,
                  onPageChanged: (page) =>
                      context.read<OnboardingCubit>().pageChanged(page),
                  children: [
                    OnboardingStep(
                      image: CustomImages.traveler,
                      title: "Welcome to Roam & Rate!",
                      subText:
                          "Plan your trips, track your spending, and rate every place you visit — all in one app.",
                    ),
                    OnboardingStep(
                      image: CustomImages.review,
                      title: "Rate as you roam",
                      subText:
                          "Give each place a score out of 10 and jot down notes, so you’ll always remember the highlights (and the misses).",
                    ),
                    OnboardingStep(
                      image: CustomImages.trackExpensives,
                      title: "Track your expenses",
                      subText:
                          "Log every expense by category and tag, helping you stay on budget and see where your money goes.",
                    ),
                  ],
                );
              },
            ),
            //Skip Button
            Positioned(
              top: Helperfunctions.getAppBarHeight(),
              right: 20,
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: () {
                      context.read<OnboardingCubit>().skipPage();
                    },
                    child: const Text("Skip"),
                  );
                },
              ),
            ),
            // Page indicators, dot form
            Positioned(
              bottom: kBottomNavigationBarHeight + 25.0,
              left: 20,
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return SmoothPageIndicator(
                    controller: state.pageController,
                    count: 3,
                    onDotClicked: (page) => context
                        .read<OnboardingCubit>()
                        .dotNavigationClick(page),
                    effect: ExpandingDotsEffect(dotHeight: 6),
                  );
                },
              ),
            ),

            // Next page button
            Positioned(
              right: 20,
              bottom: Helperfunctions.getBottomNavBarHeight(),
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () => context.read<OnboardingCubit>().nextPage(),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const FaIcon(FontAwesomeIcons.arrowRight),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
