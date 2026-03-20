import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';

class TripOverviewCard extends StatefulWidget {
  final TripModel tripModel;
  final double totalSpent;
  const TripOverviewCard({super.key, required this.tripModel, required this.totalSpent});

  @override
  State<TripOverviewCard> createState() => _TripOverviewCardState();
}

class _TripOverviewCardState extends State<TripOverviewCard> {
  @override
  Widget build(BuildContext context) {
    Duration diff = widget.tripModel.endDate.difference(
      widget.tripModel.startDate,
    );
    int days = diff.inDays;

    String getDays() {
      if(DateTime.now().isAfter(widget.tripModel.endDate)) return "Finished";
      if(DateTime.now().isBefore(widget.tripModel.startDate)) return "Upcoming";

      String daysLeft = (days - DateTime.now().difference(widget.tripModel.startDate).inDays).toString();
      String daysDone = DateTime.now().difference(widget.tripModel.startDate).inDays.toString();
      
      return  "${daysDone} days in | ${daysLeft} remaining";
    }

    Color getBudgetColor(){
      double progress = (widget.totalSpent / widget.tripModel.budget).clamp(0.0, 1.0);

      if(progress >= 0.9) return CustomColours.darkError;
      if(progress >= 0.6) return Colors.amber.shade400;
      return CustomColours.darkSuccess;
    }

    

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: widget.tripModel.backgroundColor == "red"
            ? CustomColours.darkError
            : CustomColours.darkSurface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tripModel.tripName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: CustomColours.darkPrimary.withValues(
                          alpha: (0.3),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CustomColours.darkPrimary,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: CustomColours.darkPrimary,
                          ),
                          Text(widget.tripModel.location),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Text(
                    "${DateFormat('dd MMM yyyy').format(widget.tripModel.startDate)} - ",
                    style: const TextStyle(
                      color: CustomColours.darkSecondaryText,
                      fontSize: 10,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "${DateFormat('dd MMM yyyy').format(widget.tripModel.endDate)}",
                    style: const TextStyle(
                      color: CustomColours.darkSecondaryText,
                      fontSize: 10,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    " | ${days} days",
                    style: const TextStyle(
                      color: CustomColours.darkSecondaryText,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "TOTAL BUDGET",
                      style: const TextStyle(
                        color: CustomColours.darkSecondaryText,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "${CurrencyData.currencySymbolFromCode(widget.tripModel.currency)} ${widget.tripModel.budget.toString()}",
                      style: const TextStyle(
                        color: CustomColours.darkPrimaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "REMAINING",
                      style: const TextStyle(
                        color: CustomColours.darkSecondaryText,
                        fontSize: 10,
                        
                      ),
                    ),
                    Text(
                      "${CurrencyData.currencySymbolFromCode(widget.tripModel.currency)} ${(widget.tripModel.budget - widget.totalSpent).toStringAsFixed(2)}",
                      style:  TextStyle(
                        color: getBudgetColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            BudgetBar(budget: widget.tripModel.budget, spent: widget.totalSpent),
            const SizedBox(height: 4),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Spent: ${CurrencyData.currencySymbolFromCode(widget.tripModel.currency)} ${widget.totalSpent.toString()}",
                  style: const TextStyle(
                    color: CustomColours.darkSecondaryText,
                  ),
                ),
                Text(
                  getDays(),
                  style: TextStyle(
                    color: Colors.amber.shade500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetBar extends StatelessWidget{
  final double budget;
  final double spent;

  const BudgetBar({super.key, required this.budget, required this.spent});
  
  @override
  Widget build(Object context) {
    double progress = (spent / budget).clamp(0.0, 1.0);

    return LinearProgressIndicator(
      value: progress,
      minHeight: 5,
      backgroundColor: CustomColours.darkSecondarySurface,
      valueColor: AlwaysStoppedAnimation<Color>(progress >= 0.9 ? CustomColours.darkError : progress >= 0.6 ? Colors.amber.shade400 : CustomColours.darkPrimary),
      borderRadius: BorderRadius.circular(10),
    );
    
  }
}
