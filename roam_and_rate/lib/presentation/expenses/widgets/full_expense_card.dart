import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/currency/currency_bloc.dart';
import 'package:roam_and_rate/application/currency/currency_event.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/tag_widget.dart';

class FullExpenseCard extends StatefulWidget {
  final ExpenseModel expenseDetails;
  final TripModel tripDetails;
  const FullExpenseCard({
    super.key,
    required this.expenseDetails,
    required this.tripDetails,
  });

  @override
  State<FullExpenseCard> createState() => _FullExpenseCardState();
}

class _FullExpenseCardState extends State<FullExpenseCard> {
  bool _expanded = false;

  IconData? getCatIcon(String category) {
    for (CategoryModel c in Categories.expenseCategories) {
      if (c.name == category) {
        return c.icon;
      }
    }
    return FontAwesomeIcons.question;
  }

  // Future<String?> fetchRate(String base, String target, double value) async {
  //   final rate = await getExchangeRate(
  //     base.toUpperCase(),
  //     target.toUpperCase(),
  //   );

  //   if (rate != null) {
  //     final converted = convertAmount(value, rate);
  //     return "${converted.toStringAsFixed(2)}";
  //   }
  //   return null;
  // }

  // double convertAmount(double amount, CurrencyRate rate) {
  //   return amount * rate.mid;
  // }

  // @override
  // void initState() {
  //   if (widget.tripDetails.currency != widget.expenseDetails.currency) {
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(widget.expenseDetails.expenseId!),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder(
            builder: (con) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.editExpense,
                    arguments: EditExpenseArugments(
                      expense: widget.expenseDetails,
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
                      backgroundColor: CustomColours.darkSurface,
                      title: const Text("Delete Expense?"),
                      content: const Text(
                        "Are you sure you want to delete this expense, this action is irversiable",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<ExpenseBloc>().add(
                              DeleteExpense(widget.expenseDetails.expenseId!),
                            );
                            // context.read<ExpenseBloc>().add(
                            //     DeleteExpenseRequested(
                            //         widget.expenseDetails));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Expense deleted successfully!'),
                                backgroundColor: CustomColours.darkSuccess,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: CustomColours.darkError),
                          ),
                        ),
                      ],
                    ),
                  );
                  // Call the callback when returning from SplitDetailPage
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

      child: GestureDetector(
        onTap: () {
          if (widget.expenseDetails.notes.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Notes"),
                content: Text(widget.expenseDetails.notes),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },

        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomColours.darkSurface,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Left - Circle Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CustomColours.darkPrimary,
                    ),
                    child: Icon(
                      getCatIcon(widget.expenseDetails.category),
                      color: CustomColours.darkBackground,
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.expenseDetails.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.expenseDetails.type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: CustomColours.darkSecondaryText,
                          ),
                        ),
                        BlocBuilder<ParticipantBloc, ParticipantState>(
                          builder: (context, state) {
                            if (state is ParticipantLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ParticipantLoaded) {
                              if (state.participants.isEmpty) {
                                return Text("SOMETHING WENT WRONG");
                              }

                              return Text(
                                "Payee: ${state.participants.firstWhere((p) => p.id == widget.expenseDetails.participantId).particpantName}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColours.darkSecondaryText,
                                ),
                              );
                            } else if (state is ParticipantError) {
                              return Text("Error: ${state.message}");
                            } else {
                              return const Text("Something went wrong!");
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Right - Date, Cost and Paid
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Paid: ${CurrencyData.currencySymbol(widget.expenseDetails.currency)}${widget.expenseDetails.paid.toString()}",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 69, 219, 156),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      widget.tripDetails.currency ==
                              widget.expenseDetails.currency
                          ? SizedBox() // no need to convert
                          : FutureBuilder<String?>(
                              future: fetchRate(
                                widget.expenseDetails.currency
                                    .toUpperCase(), // base (original currency)
                                widget.tripDetails.currency
                                    .toUpperCase(), // target (trip display currency)
                                widget.expenseDetails.paid, // value to convert
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    "Converting...",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  );
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return Text(
                                    "Conversion failed",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    "Paid: ${CurrencyData.currencySymbol(widget.tripDetails.currency)}${snapshot.data}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 69, 219, 156),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                }
                              },
                            ),
                      Text(
                        "Cost: ${CurrencyData.currencySymbol(widget.expenseDetails.currency)}${widget.expenseDetails.cost.toString()}",
                        style: TextStyle(
                          color: CustomColours.darkPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat(
                          'EE, dd MMM yyyy',
                        ).format(widget.expenseDetails.datePaid),
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColours.darkSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final visibleTags = _expanded
                      ? widget.expenseDetails.tags
                      : widget.expenseDetails.tags.take(3).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          ...visibleTags.map((tag) => TagWidget(label: tag)),
                          if (widget.expenseDetails.tags.length > 3)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expanded = !_expanded;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColours.darkPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  _expanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
