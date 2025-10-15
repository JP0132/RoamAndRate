import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';

class ConnectToDatabasePage extends StatefulWidget {
  const ConnectToDatabasePage({super.key});

  @override
  State<ConnectToDatabasePage> createState() => _ConnectToDatabasePageState();
}

class _ConnectToDatabasePageState extends State<ConnectToDatabasePage> {
  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _portNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<bool> testConnection() async {
      return true;
    }

    void handleOnSubmit() async {
      final sm = SessionManager();
      await sm.setServerData(
        _serverAddressController.text,
        _portNoController.text,
      );
      // TODO: Either handle the get the data from the db here or create another page for it
      //SmoothTransitionPage(context, CustomBottomNavbar());
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Backup to your Database")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomInputField(
              inputText: "Server IP Address",
              inputIcon: FaIcon(FontAwesomeIcons.solidCircleUser),
              controller: _serverAddressController,
            ),
            CustomInputField(
              inputText: "Port Number",
              inputIcon: FaIcon(FontAwesomeIcons.solidCircleUser),
              controller: _portNoController,
            ),
            ElevatedButton(
              onPressed: () async {
                bool isConnected = await testConnection();
                if (isConnected) {
                  handleOnSubmit();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColours.darkPrimary,
                foregroundColor: CustomColours.darkBackground,
                padding: EdgeInsets.all(8.0),
              ),
              child: Text(
                "Submit",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
