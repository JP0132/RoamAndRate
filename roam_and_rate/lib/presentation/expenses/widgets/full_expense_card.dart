import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/app_router.dart';

import 'package:roam_and_rate/application/expenses/expense_bloc.dart';
import 'package:roam_and_rate/application/expenses/expense_event.dart';

import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/helper/currency_helper.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/data/local/session_manager.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/helpers/expense_helper_functions.dart';
import 'package:roam_and_rate/presentation/expenses/widgets/tag_widget.dart';

class FullExpenseCard extends StatefulWidget {
  final ExpenseModel expenseDetails;
  final TripModel tripDetails;
  final Function(String, double) onCostConverted;
  final Map<String, double> convertedCosts;
  final List<ParticipantModel> participants;
  const FullExpenseCard({
    super.key,
    required this.expenseDetails,
    required this.tripDetails,
    required this.onCostConverted,
    required this.convertedCosts,
    required this.participants,
  });

  @override
  State<FullExpenseCard> createState() => _FullExpenseCardState();
}

class _FullExpenseCardState extends State<FullExpenseCard> {
  bool _expanded = false;
  late Future<String?> _conversionFuture; // Store the future
  final sessionManager = SessionManager();
  String? userCurrency = "";

  @override
  void initState() {
    super.initState();
    print(
      "🤯🤯🤯🤯🤯🤯 ${widget.expenseDetails.targetPaidAmountMinor.toString()}",
    );
    print(
      "🤯🤯🤯🤯🤯🤯 ${widget.expenseDetails.targetCostAmountMinor.toString()}",
    );
    print("🤯🤯🤯🤯🤯🤯 ${widget.expenseDetails.targetCurrency.toString()}");
    userCurrency = sessionManager.userCurrency;

    // _initializeConversionFuture();
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    final id = widget.expenseDetails.expenseId!;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.viewExpense,
        arguments: ViewExpenseArguments(
          tripDetails: widget.tripDetails,
          participants: widget.participants,
          expense: widget.expenseDetails,
        ),
      ),
      child: Slidable(
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
                      arguments: ExpenseFormArguments(
                        expense: widget.expenseDetails,
                        participants: widget.participants,
                        tripDetails: widget.tripDetails,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: custom.success,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.pencil,
                    color: custom.icon,
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
                        backgroundColor: custom.surface,
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
                                SnackBar(
                                  content: Text(
                                    'Expense deleted successfully!',
                                  ),
                                  backgroundColor: custom.success,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              "DELETE",
                              style: TextStyle(color: custom.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: custom.error,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: custom.icon,
                    size: 25,
                  ),
                );
              },
            ),
          ],
        ),

        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: custom.surface,
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
                      color: custom.primary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: FaIcon(
                        Helperfunctions.getCatIcon(
                          widget.expenseDetails.category,
                        ),
                        color: custom.background,
                      ),
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
                            color: custom.primary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${CurrencyData.currencySymbolFromCode(widget.expenseDetails.baseCurrency!)}${getExpenseDisplay(widget.expenseDetails.basePaidAmountMinor!, widget.expenseDetails.baseCurrency!)}",
                              style: TextStyle(
                                color: custom.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 4),
        
                            widget.expenseDetails.exchangeRate == 1.0
                                ? SizedBox() // no need to convert
                                : widget.expenseDetails.conversionStatus ==
                                      "pending"
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: custom.background,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "pending",
                                      style: TextStyle(
                                        color: custom.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: custom.background,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "${CurrencyData.currencySymbolFromCode(widget.expenseDetails.targetCurrency!)}${getExpenseDisplay(widget.expenseDetails.targetPaidAmountMinor!, widget.expenseDetails.targetCurrency!)}",
                                      style: TextStyle(
                                        color: custom.primary,
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
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: custom.secondarySurface,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      DateFormat(
                        'EE, dd MMM yyyy',
                      ).format(widget.expenseDetails.datePaid),
                      style: TextStyle(
                        fontSize: 12,
                        color: custom.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
        
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: custom.secondaryText, width: 1),
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
                      widget.expenseDetails.toBeSplit 
                      ? _buildCostDetails("split", "Yes") 
                      : _buildCostDetails("payee", Helperfunctions.getParticipantName(widget.participants, widget.expenseDetails.participantId!)),
        
                      _buildCostDetails(
                        "cost",
                        "${CurrencyData.currencySymbolFromCode(widget.expenseDetails.baseCurrency!)}${getExpenseDisplay(widget.expenseDetails.baseCostAmountMinor!, widget.expenseDetails.baseCurrency!)}",
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
                              color: custom.secondaryText,
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
                                          color: custom.primary,
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
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Row(
      children: [
        VerticalDivider(color: custom.secondaryText, thickness: 1, width: 1),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: custom.secondaryText,
              ),
            ),

            Text(
              detail,
              style: TextStyle(
                color: custom.primaryText,
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
