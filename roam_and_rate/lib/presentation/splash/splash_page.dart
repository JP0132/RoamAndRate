import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/helper/my_logo.dart';
import 'package:roam_and_rate/presentation/get_started/pages/get_started.dart';
import 'package:roam_and_rate/presentation/onboarding/pages/onboarding_page.dart';
import 'package:roam_and_rate/presentation/widgets/bottom_nav/bottom_navbar.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // _bounceAnimation = Tween<Offset>(
    //   begin: Offset.zero,
    //   end: Offset(0, -1),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
    //   ),
    // );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation completed, navigate based on authentication state
        _checkFirstTime();
        //_goToOnBoarding(true);
        // _goToGetStarted(true);
      }
    });
  }

  // void _goToOnBoarding(test) {
  //   if (test) {
  //     SmoothTransitionPage(context, OnboardingPage());
  //   }
  // }

  // void _goToGetStarted(test) {
  //   if (test) {
  //     SmoothTransitionPage(context, GetStarted());
  //   }
  // }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (mounted) {
      if (isFirstTime) {
        SmoothTransitionPage(context, OnboardingPage());
      } else {
        SmoothTransitionPage(context, CustomBottomNavbar());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.7, 0.3],
              colors: [
                custom.background,
                custom.secondarySurface,
              ],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      "assets/images/logo/logopurple.png",
                      height: 300,
                      width: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
