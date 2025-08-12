import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/pages/bottom_nav/bloc/navigation_bloc.dart';
import 'package:roam_and_rate/pages/bottom_nav/bloc/navigation_event.dart';
import 'package:roam_and_rate/pages/bottom_nav/bloc/navigation_state.dart';
import 'package:roam_and_rate/pages/expenses/expenses_page.dart';
import 'package:roam_and_rate/pages/home/homepage.dart';
import 'package:roam_and_rate/pages/settings/settings_page.dart';
import 'package:roam_and_rate/pages/trips/trips_page.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: Scaffold(
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.addTrip);
          },
          shape: const CircleBorder(),
          backgroundColor: CustomColours.darkPrimary,
          foregroundColor: Colors.black,
          child: FaIcon(FontAwesomeIcons.plus, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: CustomColours.darkSecondarySurface,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                final selectedIndex = _getSelectedIndex(state);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildIcon(
                      context,
                      icon: FontAwesomeIcons.house,
                      index: 0,
                      selectedIndex: selectedIndex,
                      onTap:
                          () => context.read<NavigationBloc>().add(
                            NavigateToHome(),
                          ),
                    ),
                    _buildIcon(
                      context,
                      icon: FontAwesomeIcons.locationDot,
                      index: 1,
                      selectedIndex: selectedIndex,
                      onTap:
                          () => context.read<NavigationBloc>().add(
                            NavigateToTrips(),
                          ),
                    ),
                    const SizedBox(width: 40), // Space for the FAB
                    _buildIcon(
                      context,
                      icon: FontAwesomeIcons.dollarSign,
                      index: 2,
                      selectedIndex: selectedIndex,
                      onTap:
                          () => context.read<NavigationBloc>().add(
                            NavigateToAnalytics(),
                          ),
                    ),
                    _buildIcon(
                      context,
                      icon: FontAwesomeIcons.gear,
                      index: 3,
                      selectedIndex: selectedIndex,
                      onTap:
                          () => context.read<NavigationBloc>().add(
                            NavigateToSettings(),
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is HomeState) {
              return const HomePage();
            } else if (state is TripsState) {
              return const TripsPage();
            } else if (state is AnalyticsState) {
              return Container(color: Colors.orange);
            } else if (state is SettingsState) {
              return const SettingsPage();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context, {
    required IconData icon,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            selectedIndex == index
                ? CustomColours.darkPrimary
                : CustomColours.darkSurface,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: FaIcon(
          icon,
          size: 25,
          color: selectedIndex == index ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

int _getSelectedIndex(NavigationState state) {
  if (state is HomeState) return 0;
  if (state is TripsState) return 1;
  if (state is AnalyticsState) return 2;
  if (state is SettingsState) return 3;
  return 0;
}

// class CircularNotchedAndCorneredRectangle extends NotchedShape {
//   final double cornerRadius;

//   CircularNotchedAndCorneredRectangle({this.cornerRadius = 20.0});

//   @override
//   Path getOuterPath(Rect host, Rect? guest) {
//     const fabRadius = 28.0; // Default FAB radius

//     final notchRadius = guest != null ? guest.width / 2.0 : 0.0;

//     final path =
//         Path()
//           ..moveTo(host.left + cornerRadius, host.top)
//           ..arcToPoint(
//             Offset(host.left, host.top + cornerRadius),
//             radius: Radius.circular(cornerRadius),
//             clockwise: false,
//           )
//           ..lineTo(host.left, host.bottom)
//           ..lineTo(host.right, host.bottom)
//           ..lineTo(host.right, host.top + cornerRadius)
//           ..arcToPoint(
//             Offset(host.right - cornerRadius, host.top),
//             radius: Radius.circular(cornerRadius),
//             clockwise: false,
//           );

//     // Add notch
//     if (guest != null) {
//       final notchCenter = guest.center.dx;
//       final notchRadius = guest.width / 2.0 + 8.0;

//       path.lineTo(notchCenter + notchRadius, host.top);
//       path.arcToPoint(
//         Offset(notchCenter - notchRadius, host.top),
//         radius: Radius.circular(notchRadius),
//         clockwise: true,
//       );
//     }

//     path.lineTo(host.left + cornerRadius, host.top);
//     path.close();

//     return path;
//   }
// }
