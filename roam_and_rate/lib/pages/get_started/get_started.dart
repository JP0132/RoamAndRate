import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/pages/get_started/enter_user_details.dart';
import 'package:roam_and_rate/widgets/smooth_transition_page.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset(
              "assets/images/logo/logopurple.png",
              height: 120,
              width: 120,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Fresh Start Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Fresh Start",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: StartingOptionBtn(
                    btnText: "GET STARTED",
                    onPress:
                        () => SmoothTransitionPage(context, EnterUserDetails()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48), // Space between sections
            // Restore from Backup Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Restore from Backup",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: StartingOptionBtn(
                    btnText: "CONNECT TO DATABASE",
                    onPress: () {},
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: StartingOptionBtn(
                    btnText: "RESTORE FROM JSON",
                    onPress: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StartingOptionBtn extends StatelessWidget {
  final String btnText;
  final VoidCallback onPress;
  const StartingOptionBtn({
    super.key,
    required this.btnText,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColours.darkPrimary,
        elevation: 2,
      ),
      child: Text(
        btnText,
        style: TextStyle(
          color: CustomColours.darkBackground,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }
}
