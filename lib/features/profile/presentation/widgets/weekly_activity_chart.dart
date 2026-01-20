import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../stats/domain/entities/reading_session.dart';

class WeeklyActivityChart extends StatelessWidget {
  final List<ReadingSession> sessions;

  const WeeklyActivityChart({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) =>
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.round()} words',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  String text;
                  // Simple logic: Assuming 0=Today, 1=Yesterday, etc. or vice versa
                  // Ideally we map values to Days of Week based on data
                  // For MVP, let's just show M T W T F S S based on index logic in parent
                  switch (value.toInt()) {
                    case 0:
                      text = 'M';
                      break;
                    case 1:
                      text = 'T';
                      break;
                    case 2:
                      text = 'W';
                      break;
                    case 3:
                      text = 'T';
                      break;
                    case 4:
                      text = 'F';
                      break;
                    case 5:
                      text = 'S';
                      break;
                    case 6:
                      text = 'S';
                      break;
                    default:
                      text = '';
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(text, style: style),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    return Text(
                      value >= 1000
                          ? '${(value / 1000).toStringAsFixed(1)}k'
                          : value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.right,
                    );
                  }),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: _generateGroups(context),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateGroups(BuildContext context) {
    // Process sessions into last 7 days buckets
    // This is placeholder logic.
    // In real app we would map 'sessions' to days of week.
    // For now assuming we just show dummy or total words per day

    // Init buckets
    final Map<int, int> wordCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

    // Ideally normalize dates.
    // 0 = Mon, 6 = Sun

    for (var session in sessions) {
      // Simple mapping: (weekday - 1) gives 0 for Mon, 6 for Sun
      final dayIndex = session.createdAt.weekday - 1;
      wordCounts[dayIndex] = (wordCounts[dayIndex] ?? 0) + session.wordsRead;
    }

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (wordCounts[index] ?? 0).toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }
}
