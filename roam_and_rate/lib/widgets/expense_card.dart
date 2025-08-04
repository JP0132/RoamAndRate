import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';

class ExpenseCard extends StatefulWidget {
  final String transactionName;
  final String type;
  final DateTime datePaid;
  final double paid;
  const ExpenseCard({
    super.key,
    required this.transactionName,
    required this.type,
    required this.datePaid,
    required this.paid,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColours.darkSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          // Left - Circle Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColours.darkPrimary,
            ),
          ),

          SizedBox(width: 16),

          // Middle - Name and Stars (takes remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.transactionName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CustomColours.darkSecondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Right - Date and Rating Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.paid.toString(),
                style: TextStyle(
                  color: CustomColours.darkPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('EE, dd MM yyyy').format(widget.datePaid),
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColours.darkSecondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
