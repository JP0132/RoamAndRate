import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';
import 'package:roam_and_rate/application/currency/currency_bloc.dart';
import 'package:roam_and_rate/application/currency/currency_event.dart';
import 'package:roam_and_rate/application/currency/currency_state.dart';
import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';
import 'package:roam_and_rate/application/participant/participant_bloc.dart';
import 'package:roam_and_rate/application/participant/participant_state.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/helper/currency_helper.dart';
import 'package:roam_and_rate/core/utils/helper/currency_rate.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/tag_widget.dart';

class FullExpenseCard extends StatefulWidget {
  final ExpenseModel expenseDetails;
  final TripModel tripDetails;
  final Function(String, double) onCostConverted;
  final Map<String, double> convertedCosts;
  final String participantName;
  const FullExpenseCard({
    super.key,
    required this.expenseDetails,
    required this.tripDetails,
    required this.onCostConverted,
    required this.convertedCosts,
    required this.participantName,
  });

  @override
  State<FullExpenseCard> createState() => _FullExpenseCardState();
}

class _FullExpenseCardState extends State<FullExpenseCard> {
  bool _expanded = false;
  late Future<String?> _conversionFuture; // Store the future

  @override
  void initState() {
    super.initState();
    _initializeConversionFuture();
  }

  @override
  void didUpdateWidget(FullExpenseCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-initialize if expense details changed
    if (oldWidget.expenseDetails.paid != widget.expenseDetails.paid ||
        oldWidget.expenseDetails.currency != widget.expenseDetails.currency ||
        oldWidget.tripDetails.currency != widget.tripDetails.currency) {
      _initializeConversionFuture();
    }
  }

  void _initializeConversionFuture() {
    if (widget.tripDetails.currency != widget.expenseDetails.currency) {
      _conversionFuture = CurrencyHelper().getConvertedAmount(
        base: widget.expenseDetails.currency.toUpperCase(),
        target: widget.tripDetails.currency.toUpperCase(),
        value: widget.expenseDetails.paid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.expenseDetails.expenseId!;
    final converted = widget.convertedCosts[id];

    return Slidable(
      key: Key(widget.expenseDetails.expenseId!),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Builder(
            builder: (context) {
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
            builder: (context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  // Left - Circle Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: CustomColours.darkPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Helperfunctions.getCatIcon(
                        widget.expenseDetails.category,
                      ),
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
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${CurrencyData.currencySymbolFromCode(widget.expenseDetails.currency)}${widget.expenseDetails.paid.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: CustomColours.darkPrimaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 4),

                            widget.tripDetails.currency ==
                                    widget.expenseDetails.currency
                                ? SizedBox() // no need to convert
                                : converted == null
                                ? const Text(
                                    "Converting...",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: CustomColours.darkBackground,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "${CurrencyData.currencySymbolFromCode(widget.tripDetails.currency)}${converted.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: CustomColours.darkPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right - Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
              
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CustomColours.darkSecondarySurface,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          
                        ),
                        child: Text(
                          DateFormat(
                            'EE, dd MMM yyyy',
                          ).format(widget.expenseDetails.datePaid),
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColours.darkSecondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CustomColours.darkSecondaryText,
                      width: 1,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCostDetails(
                        "payee",
                        widget.participantName,
                      ),

                      _buildCostDetails(
                        "cost",
                        "${CurrencyData.currencySymbolFromCode(widget.expenseDetails.currency)}${widget.expenseDetails.cost.toStringAsFixed(2)}",
                      ),

                      _buildCostDetails("type", widget.expenseDetails.type),

                      SizedBox(width: 1),
                    ],
                  ),
                ),
              ),

              widget.expenseDetails.tags.isEmpty
                  ? const SizedBox.shrink()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final visibleTags = _expanded
                            ? widget.expenseDetails.tags
                            : widget.expenseDetails.tags.take(3).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: CustomColours.darkSecondaryText,
                              thickness: 1,
                              height: 1,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  ...visibleTags.map(
                                    (tag) => TagWidget(label: tag),
                                  ),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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

  Widget _buildCostDetails(String label, String detail) {
    return Row(
      children: [
        VerticalDivider(
          color: CustomColours.darkSecondaryText,
          thickness: 1,
          width: 1,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: CustomColours.darkSecondaryText,
              ),
            ),

            Text(
              detail,
              style: TextStyle(
                color: CustomColours.darkPrimaryText,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
