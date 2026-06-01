import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/application/navigation/navigation_state.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_event.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/custom_app_bar.dart';

class ParticipantPage extends StatefulWidget {
  const ParticipantPage({super.key});

  @override
  State<ParticipantPage> createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Scaffold(
      appBar: CustomAppBar(title: "Participants",custom: custom),
      body: Column(
        children: [
          // Expanded List area
          Expanded(
            child: BlocBuilder<ParticipantBloc, ParticipantState>(
              builder: (context, state) {
                if (state is ParticipantLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ParticipantLoaded) {
                  if (state.participants.isEmpty) {
                    return const Center(
                      child: Text(
                        "Create your first participant to get started!",
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: state.participants.length,
                    itemBuilder: (context, index) {
                      final participant = state.participants[index];

                      return Slidable(
                        key: Key(participant.id ?? index.toString()),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            Builder(
                              builder: (con) {
                                // Edit Participant
                                return ElevatedButton(
                                  onPressed: () {
                                    _editingController.text = state
                                        .participants[index]
                                        .particpantName;
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor:
                                            custom.surface,
                                        title: const Text("Edit Participant"),
                                        content: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: custom
                                                    .background,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _editingController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Edit a participant',
                                                  hintStyle: TextStyle(
                                                    color: custom
                                                        .secondaryText,
                                                  ),
                                                  icon: Icon(
                                                    Icons.tag,
                                                    color: custom
                                                        .primary,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                onSubmitted: (value) {
                                                  if (value.trim().isNotEmpty) {
                                                    ParticipantModel
                                                    editParticipant =
                                                        participant.copyWith(
                                                          particpantName:
                                                              _editingController
                                                                  .text,
                                                        );

                                                    context
                                                        .read<ParticipantBloc>()
                                                        .add(
                                                          EditParticipant(
                                                            editParticipant,
                                                          ),
                                                        );

                                                    _editingController.clear();
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.pencil,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                );
                              },
                            ),
                            Builder(
                              builder: (con) {
                                return ElevatedButton(
                                  
                                  onPressed: () {
                                    
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        
                                        backgroundColor:
                                            custom.surface,
                                        title: const Text("Delete Expense?"),
                                        content: const Text(
                                          "Are you sure you want to delete this participant, this action is irreversible",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<ParticipantBloc>()
                                                  .add(
                                                    DeleteParticipant(
                                                      participant.id!,
                                                    ),
                                                  );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                 SnackBar(
                                                  content: Text(
                                                    'Participant deleted successfully!',
                                                  ),
                                                  backgroundColor:
                                                      custom.success,
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child:  Text(
                                              "DELETE",
                                              style: TextStyle(
                                                color: custom.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 50,
                          decoration: BoxDecoration(
                            color: custom.surface,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              participant.particpantName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ParticipantError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else {
                  return const Center(child: Text("Something went wrong!"));
                }
              },
            ),
          ),

          // Input at bottom
          BlocConsumer<ParticipantBloc, ParticipantState>(
            
            listener: (context, state) {
              final custom = Theme.of(context).extension<CustomColours>()!;

              if (state is ParticipantAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    
                    content: Text("Participant created!"),
                    backgroundColor: custom.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _controller.clear();
              } else if (state is ParticipantError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Failed to create participant: ${state.message}",
                    ),
                    backgroundColor: custom.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: custom.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a participant',
                      hintStyle: TextStyle(
                        color: custom.secondaryText,
                      ),
                      icon: Icon(Icons.tag, color: custom.primary),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        final sm = SessionManager();
                        final newParticipant = ParticipantModel(
                          userId: sm.userId!,
                          particpantName: value.trim(),
                          isAdmin: false,
                          createdAt: DateTime.now(),
                        );
                        context.read<ParticipantBloc>().add(
                          AddParticipant(newParticipant),
                        );
                        _controller.clear();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
