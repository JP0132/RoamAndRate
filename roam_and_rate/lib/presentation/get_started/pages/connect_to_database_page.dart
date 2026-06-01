import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/presentation/get_started/pages/restore_db_backup.dart';
import 'package:roam_and_rate/presentation/get_started/widgets/dropdown_with_input.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_input_field.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';
import 'package:roam_and_rate/presentation/widgets/common/smooth_transition_page.dart';

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
  bool isTestConnection = false;
  final _formKey = GlobalKey<FormState>();

  void _onServerAddressChanged(String value) {
    setState(() {
      serverAddress = value.trim();
      isTestConnection = false;
    });
    print('Server Address value: $value');
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    
    List<String> protocols = ["http://", "https://"];
    String selectedProtocol = "http://";

    Future<bool> testConnection() async {
      final result = await http.get(
        Uri.parse(
          "$serverAddress:${_portNoController.text.trim()}/testConnection",
        ),
        headers: {"Content-Type": "application/json"},
      );

      if (result.statusCode != 200) {
        print("⏰⏰ IT NOT CORRECT");
        return false;
      }
      return true;
    }

    void handleOnSubmit() async {
      print("⚠️ ⚠️ ⚠️  $serverAddress ⚠️ ⚠️ ⚠️ ");
      print("⚠️ ⚠️ ⚠️  ${_portNoController.text} ⚠️ ⚠️ ⚠️ ");
      final sm = SessionManager();
      await sm.setServerData(
        serverAddress.trim(),
        _portNoController.text.trim(),
      );

      SmoothTransitionPage(context, RestoreDbBackup());
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Backup to your database",custom: custom),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                DropdownWithInput(
                  controller: _serverAddressController,
                  items: protocols,
                  preSelected: selectedProtocol,
                  onChanged: _onServerAddressChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "URL required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                CustomInputField(
                  inputText: "Port Number",
                  inputIcon: FaIcon(FontAwesomeIcons.globe),
                  controller: _portNoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final tryTestConnection = await testConnection();
                          setState(() {
                            isTestConnection = tryTestConnection;
                          });
                        } catch (e) {
                          setState(() {
                            isTestConnection = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: custom.surface,
                              title: const Text("Connection Failed"),
                              content: Text(
                                "Unable to connect to the provided server address.\nEnsure you have entered the correct server address and Roam&Rate docker is running.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          );
                          //print("Connection failed: $e");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: custom.primary,
                      foregroundColor: custom.background,
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      "Press to test connection",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                isTestConnection
                    ? Text("Successful Connection ✔️")
                    : Text("Unable to connect ❌"),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isTestConnection
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              print("⏰⏰⏰⏰ IT IS CORRRRTI");
                              handleOnSubmit();
                            }
                          }
                        : null,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: custom.primary,
                      foregroundColor: custom.background,
                      padding: EdgeInsets.all(8.0),
                      disabledBackgroundColor: Colors.grey.shade400,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
