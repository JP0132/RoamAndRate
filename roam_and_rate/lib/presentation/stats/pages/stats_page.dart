import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roam_and_rate/presentation/widgets/common/customisable_dropdown.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          
        ],),
      ),
    );
  }
}