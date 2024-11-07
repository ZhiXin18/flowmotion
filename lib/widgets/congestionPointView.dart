import 'package:fl_chart/fl_chart.dart';
import 'package:flowmotion/models/rating_point.dart';
import 'package:flowmotion/widgets/imageViewerWithSlider.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../utilities/flowmotion_api_sgt.dart';

/// Visualize Congestion Point identified by the given cameraId
class CongestionPointView extends StatelessWidget {
  final String cameraId;
  const CongestionPointView({required this.cameraId, super.key});

  Future<List<RatingPoint>> fetchGraphRatings(
      String cameraId, String groupby, DateTime begin, DateTime end) async {
    final api = FlowmotionApi().getCongestionApiSgt();
    print("Fetching for camera ID: $cameraId");
    print("End time: $end");
    print("Start time: $begin");
    try {
      final response = await api.congestionsGet(
        cameraId: cameraId,
        agg: 'avg',
        groupby: groupby,
        begin: begin,
        end: end,
      );
      print("Raw response data: ${response.data}");

      List<RatingPoint> ratingPoints = [];
      if (response.data == null || response.data!.isEmpty) {
        throw Exception(
            "Expected CongestionApi->congestionsGet to return nonempty data");
      }
      // Group the data by hour
      for (var item in response.data!) {
        DateTime ratedOn = item.rating.ratedOn;
        num value = item.rating.value;
        String imageUrl = item.camera.imageUrl;
        int hour = ratedOn.hour;
        ratingPoints.add(RatingPoint(
          ratedOn: DateTime(ratedOn.year, ratedOn.month, ratedOn.day, hour),
          value: value,
          imageUrls: imageUrl,
        ));
      }
      print("Ratings fetched: $ratingPoints");
      return ratingPoints;
    } catch (e) {
      print(
          'Exception when calling CongestionApi->congestionsGet with parameters: $e\n');
      throw e;
    }
  }

  // Placeholder methods for graphs
  Widget _buildHourlyCongestionRatingGraph(List<RatingPoint> data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      final formattedTime = _formatToHour(data[index].ratedOn);
                      return Text(formattedTime);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: data
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(
                        entry.key.toDouble(), entry.value.value.toDouble()))
                    .toList(),
                isCurved: true,
                color: Colors.red,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  // format DateTime to Xpm/Xam for hourly graphs
  String _formatToHour(DateTime dateTime) {
    return DateFormat.j().format(dateTime); // e.g., "1 PM"
  }

  Widget _buildCongestionHistoryGraph(List<RatingPoint> data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                            color: Colors.blue),
                      ],
                    ))
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      final formattedDate =
                          _formatToDayMonth(data[index].ratedOn);
                      return Text(formattedDate);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  // format DateTime to X month for history graph
  String _formatToDayMonth(DateTime dateTime) {
    return DateFormat('d MMM').format(dateTime); // e.g., "1 Nov"
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        FutureBuilder<List<RatingPoint>>(
          future: fetchGraphRatings(
              cameraId,
              'hour', // groupby
              DateTime.now().subtract(Duration(hours: 10)),
              DateTime.now()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final historyRatings = snapshot.data;
              if (historyRatings != null && historyRatings.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHourlyCongestionRatingGraph(historyRatings),
                    SizedBox(height: 20), // spacing between graph and images
                    ImageViewerWithSlider(data: historyRatings),
                  ],
                );
              } else {
                return Text("No data available");
              }
            }
          },
        ),
        SizedBox(height: 20),
        FutureBuilder<List<RatingPoint>>(
          future: fetchGraphRatings(
              cameraId,
              'day', // groupby
              DateTime.now().subtract(Duration(days: 5)), // start time
              DateTime.now() // end time
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              // Use historyRatings, which should contain the updated List<RatingPoint> after fetchGraphRatings completes
              final historyRatings = snapshot.data;
              if (historyRatings != null && historyRatings.isNotEmpty) {
                return _buildCongestionHistoryGraph(historyRatings);
              } else {
                return Text("No data available");
              }
            }
          },
        ),
      ]),
    );
  }
}
