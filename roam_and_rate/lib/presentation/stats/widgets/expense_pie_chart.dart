import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryExpensesMap;
  const ExpensePieChart({super.key, required this.categoryExpensesMap});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  final List<Color> colorList = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.cyan,
  ];

  final Map<String, Color> categoryColors = {
    'Food & Drink': Colors.blue,
    'Tourist Attraction': Colors.red,
    'Accommodation': Colors.purple,
    'Shopping': Colors.orange,
    'Nature & Outdoors': Colors.green,
    'Wellness': Colors.pink,
    'Other': Colors.grey,
    'Transport': Colors.yellow,
  };

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Map<String, double> dataMap = {};

    // for (var expense in widget.expenses) {
    //   if (dataMap.containsKey(expense.category)) {
    //     dataMap[expense.category] = dataMap[expense.category]! + expense.paid;
    //   } else {
    //     dataMap[expense.category] = expense.paid;
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColours.darkSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Expense Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColours.darkPrimary,
              ),
            ),
            SizedBox(height: 30),
            AspectRatio(
              aspectRatio: 1.3,
              child: Column(
                children: <Widget>[
                  
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(widget.categoryExpensesMap, categoryColors),
                        ),
                      ),
                    ),
                  ),
                  // Legend
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.categoryExpensesMap.keys.toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Indicator(
                            color: categoryColors[label] ?? Colors.grey,
                            text: label,
                            isSquare: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    Map<String, double> dataMap,
    Map<String, Color> colorList,
  ) {
    final total = dataMap.values.fold(0.0, (a, b) => a + b);

    return dataMap.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 22.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: colorList[data.key] ?? Colors.grey,
        value: data.value,
        title: "${((data.value / total) * 100).toStringAsFixed(1)}%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: CustomColours.darkPrimary,
          shadows: shadows,
        ),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = CustomColours.darkSecondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
