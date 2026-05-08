import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/presentation/settings/widget/theme_picker_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _sessionManager = SessionManager();
  void handleParticipantBtn() {
     Navigator.pushNamed(context, AppRouter.participantSettings);
  }

  void handleUserDetailsBtn() {
    Navigator.pushNamed(context, AppRouter.userDetails);
  }

  Future<void> handleSyncBtn() async {
    
    if(await _sessionManager.hasServerData()){ 
      Navigator.pushNamed(context, AppRouter.syncSettings);
    } else{
        Navigator.pushNamed(context, AppRouter.connectToDB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

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
            SizedBox(height: 10),
            SettingsBtn(btnText: "User's Details", btnIcon: FontAwesomeIcons.user, onTap: handleUserDetailsBtn),
            SettingsBtn(btnIcon: FontAwesomeIcons.arrowsRotate, btnText: "Sync", onTap: handleSyncBtn),
            ThemePickerWidget(),
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
    final custom = Theme.of(context).extension<CustomColours>()!;

    return InkWell(
      onTap: () => onTap(),
      splashColor: custom.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: custom.surface,
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
                    color: custom.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(btnIcon, color: custom.surface),
                  ),
                ),

                Text(btnText, style: TextStyle(fontSize: 20)),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: custom.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
