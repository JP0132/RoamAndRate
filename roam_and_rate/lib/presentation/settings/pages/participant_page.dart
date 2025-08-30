import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';

class ParticipantPage extends StatefulWidget {
  const ParticipantPage({super.key});

  @override
  State<ParticipantPage> createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage> {
  List<ParticipantModel> _participants = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Participants"), centerTitle: true),
      body: BlocBuilder<ParticipantBloc, ParticipantState>(
        builder: (context, state) {
          if (state is ParticipantLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ParticipantLoaded) {
            if (state.participants.isEmpty) {
              return Center(
                child: Text("Create your first trip to get started!"),
              );
            }
            _participants = state.participants;

            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: state.participants.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: CustomColours.darkSurface,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Text(state.participants[index].particpantName),
                      FaIcon(FontAwesomeIcons.penToSquare),
                    ],
                  ),
                );
              },
            );
          } else if (state is ParticipantError) {
            return Text("Error: ${state.message}");
          } else {
            return const Text("Something went wrong!");
          }
        },
      ),
    );
  }
}
