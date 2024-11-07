import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/rating_point.dart';

class CongestionGraphs {
  static Widget buildHourlyCongestionRatingGraph(List<RatingPoint> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Today\'s Hourly Congestion Graph',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 1,
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.25,
                    getTitlesWidget: (value, meta) {
                      // Convert y-axis values to percentages
                      switch (value.toInt()) {
                        case 0:
                          return Text('0%');
                        case 0.25:
                          return Text('25%');
                        case 0.5:
                          return Text('50%');
                        case 0.75:
                          return Text('75%');
                        case 1:
                          return Text('100%');
                        default:
                          return Text('${(value * 100).toInt()}%');
                      }
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // No labels on right
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // No labels on top
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        final formattedTime = formatToHour(data[index].ratedOn);
                        return Text(formattedTime);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                  right: BorderSide.none,
                  top: BorderSide.none,
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
                      .toList(),
                  isCurved: true,
                  color: Colors.red,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String formatToHour(DateTime dateTime) {
    return DateFormat.j().format(dateTime); // e.g., "1 PM"
  }

  static Widget buildCongestionHistoryGraph(List<RatingPoint> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Historical Congestion Graph - Past 5 days',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: 150,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: 1,
              barGroups: data
                  .asMap()
                  .entries
                  .map((entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.value.toDouble(),
                    color: Colors.blue,
                  ),
                ],
              ))
                  .toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.5,
                    getTitlesWidget: (value, meta) {
                      // Display y-axis values as percentages
                      if (value == 0) return Text('0%');
                      if (value == 0.5) return Text('50%');
                      if (value == 1) return Text('100%');
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide right y-axis labels
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide top labels
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        final formattedDate = formatToDayMonth(data[index].ratedOn);
                        return Text(formattedDate);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: Colors.black), // Border on left side
                  bottom: BorderSide(color: Colors.black), // Border on bottom
                  right: BorderSide.none, // No right border
                  top: BorderSide.none, // No top border
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String formatToDayMonth(DateTime dateTime) {
    return DateFormat('d MMM').format(dateTime); // e.g., "1 Nov"
  }
}