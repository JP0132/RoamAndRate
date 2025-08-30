import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void handleParticipantBtn() {
    Navigator.pushNamed(context, AppRouter.participantSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome the user and edit the user here
            SettingsBtn(
              btnIcon: FontAwesomeIcons.person,
              btnText: "Participants",
              onTap: handleParticipantBtn,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsBtn extends StatelessWidget {
  final String btnText;
  final IconData btnIcon;
  final Function onTap;
  const SettingsBtn({
    super.key,
    required this.btnText,
    required this.btnIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.participantSettings),
      splashColor: CustomColours.darkPrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: CustomColours.darkSurface,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: CustomColours.darkPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(btnIcon, color: CustomColours.darkSurface),
                  ),
                ),

                Text(btnText, style: TextStyle(fontSize: 20)),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: CustomColours.darkPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
