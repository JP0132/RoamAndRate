import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

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
    'Nature': Colors.green,
    'Wellness': Colors.pink,
    'Other': Colors.grey,
    'Transport': Colors.yellow,
  };

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    // Map<String, double> dataMap = {};
    final dataMap = widget.categoryExpensesMap;

    return Container(
      decoration: BoxDecoration(
        color: custom.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: LayoutBuilder(builder: (context, constraints) {
        if (dataMap.isEmpty) {
          return Center(
            child: Text('No expense data', style: TextStyle(color: custom.primary)),
          );
        }
    
        final isWide = constraints.maxWidth > 600;
    final widthBased = isWide
      ? min(constraints.maxWidth * 0.45, 320.0)
      : min(constraints.maxWidth * 0.8, 260.0);
    final chartSize = min(widthBased, max(120.0, constraints.maxHeight * 0.6));
    
        Widget pie = SizedBox(
          height: chartSize,
          width: chartSize,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: max(28, chartSize * 0.18),
              sections: showingSections(dataMap, categoryColors),
            ),
          ),
        );
    
          // two-column legend using Wrap so it uses available space
          final legendAvailableWidth = isWide ? (constraints.maxWidth - chartSize - 18) : constraints.maxWidth;
          final columnWidth = (legendAvailableWidth - 12) / 2;

          Widget legend = SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: dataMap.keys.map((label) {
                return SizedBox(
                  width: columnWidth.clamp(140.0, legendAvailableWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Indicator(
                      color: categoryColors[label] ?? Colors.grey,
                      text: label,
                      isSquare: true,
                      textColor: custom.secondaryText,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
    
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  'Expense Distribution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: custom.primary),
                ),
              ),
            ),
            const SizedBox(height: 6),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pie,
                  const SizedBox(width: 18),
                  Expanded(child: legend),
                ],
              )
            else
              Column(
                children: [
                  Center(child: pie),
                  const SizedBox(height: 12),
                  ConstrainedBox(constraints: BoxConstraints(maxHeight: 180), child: legend),
                ],
              ),
          ],
        );
      }),
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

      final custom = Theme.of(context).extension<CustomColours>()!;


      return PieChartSectionData(
        color: colorList[data.key] ?? Colors.grey,
        value: data.value,
        title: "${((data.value / total) * 100).toStringAsFixed(1)}%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: custom.primary,
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
    this.textColor = Colors.white,
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
