import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/presentation/get_started/widgets/dropdown_with_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';

class ConnectToDatabasePage extends StatefulWidget {
  const ConnectToDatabasePage({super.key});

  @override
  State<ConnectToDatabasePage> createState() => _ConnectToDatabasePageState();
}

class _ConnectToDatabasePageState extends State<ConnectToDatabasePage> {
  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _portNoController = TextEditingController();
  String serverAddress = "";

  void _onServerAddressChanged(String value) {
    setState(() {
      serverAddress = value;
    });
    print('Server Address value: $value');
  }

  @override
  Widget build(BuildContext context) {
    List<String> protocols = ["http://", "https://"];
    String selectedProtocol = "http://";

    Future<bool> testConnection() async {
      final result = await http.get(
        Uri.parse("$serverAddress:${_portNoController.text}/testConnection"),
        headers: {"Content-Type": "application/json"},
      );

      if (result.statusCode != 200) {
        print("⏰⏰ IT NOT CORRECT");
        return false;
      }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              DropdownWithInput(
                items: protocols,
                preSelected: selectedProtocol,
                onChanged: _onServerAddressChanged,
              ),

              SizedBox(height: 20),
              CustomInputField(
                inputText: "Port Number",
                inputIcon: FaIcon(FontAwesomeIcons.globe),
                controller: _portNoController,
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    bool isConnected = await testConnection();
                    if (isConnected) {
                      print("⏰⏰⏰⏰ IT IS CORRRRTI");
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
