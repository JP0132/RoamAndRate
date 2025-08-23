import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/onboarding/onboarding_cubit.dart';
import 'package:roam_and_rate/core/utils/constants/images.dart';
import 'package:roam_and_rate/presentation/onboarding/widgets/onboarding_step.dart';

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
          ],
        ),
      ),
    );
  }
}
