import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/categories.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/category_model.dart';

class ExpenseCard extends StatefulWidget {
  final String transactionName;
  final String type;
  final DateTime datePaid;
  final double paid;
  final String category;
  const ExpenseCard({
    super.key,
    required this.transactionName,
    required this.type,
    required this.datePaid,
    required this.paid,
    required this.category,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
 
  
  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: custom.surface,
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
              color: custom.primary,
            ),
            child: FaIcon(Helperfunctions.getCatIcon(widget.category), color: custom.surface),
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
                    color: custom.secondaryText,
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
                  color: custom.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('EE, dd MMM yyyy').format(widget.datePaid),
                style: TextStyle(
                  fontSize: 12,
                  color: custom.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
