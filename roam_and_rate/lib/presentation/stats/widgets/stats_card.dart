import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

/// A polished, reusable stats card used across the stats page.
class StatsCard extends StatelessWidget {
  final String valueToDisplay;
  final IconData icon;
  final String label;
  final String? subtitle;
  final List<Color>? gradientColors;
  final List<double>? sparklineData;

  const StatsCard({
    super.key,
    required this.valueToDisplay,
    required this.icon,
    required this.label,
    this.subtitle,
    this.gradientColors,
    this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    final colors = gradientColors ??
        [custom.primary.withValues(alpha: 0.95), custom.primary.withValues(alpha: 0.7)];

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    valueToDisplay,
                    key: ValueKey(valueToDisplay),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.white60)),
                ],
                // small sparkline under the text
                if (sparklineData != null && sparklineData!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(enabled: false),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (sparklineData!.length - 1).toDouble(),
                        minY: sparklineData!.reduce((a, b) => a < b ? a : b),
                        maxY: sparklineData!.reduce((a, b) => a > b ? a : b),
                        lineBarsData: [
                          LineChartBarData(
                            spots: sparklineData!.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                            isCurved: true,
                            color: Colors.white.withOpacity(0.9),
                            barWidth: 2,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}