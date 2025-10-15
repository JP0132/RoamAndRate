import 'package:flutter/material.dart';

class ConnectToDatabasePage extends StatefulWidget {
  const ConnectToDatabasePage({super.key});

  @override
  State<ConnectToDatabasePage> createState() => _ConnectToDatabasePageState();
}

class _ConnectToDatabasePageState extends State<ConnectToDatabasePage> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Backup to your Database"),
      ),
      body: SingleChildScrollView(
        child: Column(
          
        ),
      ),
    );
  }
}