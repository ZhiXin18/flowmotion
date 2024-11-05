import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import '../models/congestion_rating.dart';
import '../utilities/firebase_calls.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../widgets/navigationBar.dart';

final FirebaseCalls firebaseCalls = FirebaseCalls();
final api = FlowmotionApi().getCongestionApi();

class CongestionRatingScreen extends StatefulWidget {
  final String savedPlaceLabel;
  final LatLng initialCenter; // Add initial center configuration
  final double initialZoom; // Add initial zoom configuration
  final LatLng? currentLocationMarker; // Current location marker
  final LatLng initialDestination; // Initial destination
  List<String> allInstructions = [];
  List<String> congestionPoints = [];

  CongestionRatingScreen({
    required this.savedPlaceLabel,
    required this.initialCenter, // Accept initial center
    required this.initialZoom, // Accept initial zoom level
    required this.currentLocationMarker, // Current location marker
    required this.initialDestination, // Initial destination
    required this.congestionPoints,
    required this.allInstructions,
  });

  @override
  _CongestionRatingScreenState createState() => _CongestionRatingScreenState();
}

class _CongestionRatingScreenState extends State<CongestionRatingScreen> {
  final FirebaseCalls firebaseCalls = FirebaseCalls();
  late final MapController _mapController;
  List<CongestionRating> congestionRatings = [];
  List<Congestion> allCongestionRatings = [];
  bool isLoading = true;
  List<LatLng> _stepPoints = [];
  List<LatLng> allStepPoints = [];
  List<Map<String, String>> _stepInfo = []; // Store time and distance for each step
  List<String> _congestedCamera = [];

  String time = ""; // Time as a new parameter
  String distance = ""; // Distance as a new parameter

  // Counters for marker categories
  int greenMarkersCount = 0;
  int orangeMarkersCount = 0;
  int redMarkersCount = 0;
  int questionMarkCount = 0; // For missing congestion ratings

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    fetchAllRatings();
    _fetchRoute(
        widget.currentLocationMarker ?? LatLng(1.342874, 103.67941), // Provide a default LatLng if null
        widget.initialDestination
    );
  }

  Future<List<double>> fetchGraphRatings(String cameraId, String groupby, DateTime begin, DateTime end) async {
    final api = FlowmotionApi().getCongestionApi();
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
      final ratings = response.data?.map((item) => item.rating as double).toList() ?? [];
      print("Ratings fetched: $ratings");
      return ratings;
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet with parameters: $e\n');
      return []; // Return empty list on error
    }
  }

  Future<void> fetchAllRatings() async {
    final api = FlowmotionApi().getCongestionApi();
    try {
      final response = await api.congestionsGet();
      print(response.data!.length);
      setState(() {
        allCongestionRatings = response.data!.isNotEmpty? response.data!.toList() : []; // Convert Iterable to List
        isLoading = false;
      });
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet: $e\n');
    }
  }

  Future<void> _fetchRoute(LatLng src, LatLng dest) async {
    final routeApi = FlowmotionApi().getRoutingApi();
    final routePostRequest = RoutePostRequest((b) => b
      ..src.update((srcBuilder) => srcBuilder
        ..kind = RoutePostRequestSrcKindEnum.location // Indicate that location lat long is provided
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = src.latitude // Set the latitude
          ..longitude = src.longitude // Set the longitude
        )
      )
      ..dest.update((destBuilder) => destBuilder
        ..kind = RoutePostRequestDestKindEnum.location // Indicate that location lat long is provided
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = dest.latitude // Set the destination latitude
          ..longitude = dest.longitude // Set the destination longitude
        )
      )
    );

    try {
      final response = await routeApi.routePost(routePostRequest: routePostRequest);
      _processRouteResponse(response.data); // Pass the index to process the response

    } catch (e) {
      print('Exception when calling RoutingApi->routePost: $e\n');
    }
  }
  void _processRouteResponse(RoutePost200Response? response) {
    List<String> congestedSteps = [];
    List<Map<String, String>> stepInfo = []; // Store time and distance for each step
    List<String> congestedCamera = []; // List to hold cross markers

    if (response != null && response.routes!.isNotEmpty) {
      final route = response.routes!.first;

      for (var step in route.steps) {
        List<List<num>> stepPoints = decodePolyline(step.geometry);

        if(step.congestion != null) {
          //print(step.congestion);
          setState(() {
            congestedSteps.add(step.name);
            congestedCamera.add(step.congestion!.camera.id);
          });
        }


        // Check for congestion and capture step info
        for (var point in stepPoints) {
          if (point.length >= 2) {
            LatLng latLngPoint = LatLng(
                point[0].toDouble(), point[1].toDouble());
            setState(() {
              allStepPoints.add(latLngPoint);
            });
          }
        }
        // Collect the distance and time for each step
        stepInfo.add({
          'time': route.duration.toString(), // Or use formatted time
          'distance': route.distance.toString(), // Or use formatted distance
        });

        setState(() {
          _stepPoints = allStepPoints;
          _stepInfo = stepInfo; // Store the step info for dynamic data in marker
          _congestedCamera = congestedCamera;
        });
      }
      print(congestedCamera);
    } else {
      print("No routes found in the response.");
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the widths for the boxes
    double congestionBoxWidth = screenWidth / 3; // 1/3 of the screen width
    double recommendedBoxWidth = (screenWidth * 2) / 3; // 2/3 of the screen width

    var time = _stepInfo.isNotEmpty ? double.parse(_stepInfo[0]['time']!) /60 : 0;
    var distance = _stepInfo.isNotEmpty ? double.parse(_stepInfo[0]['distance']!) /1000 : 0;

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // "From" label and input field
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.savedPlaceLabel,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'from',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Your Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,)
              ],
            ),

            // Map View
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: FlutterMap(
                mapController: _mapController, // Use the passed controller
                options: MapOptions(
                  initialCenter: widget.initialCenter, // Use the passed initial center
                  initialZoom: 10, // Use the passed initial zoom
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [
                      ..._buildMarkers(), // Existing markers
                    ],
                  ),
                  if (widget.currentLocationMarker != null)
                    MarkerLayer(markers: [
                      Marker(
                        point: widget.currentLocationMarker!,
                        width: 55,
                        height: 55,
                        child: const Icon(
                          Icons.location_pin,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                      Marker(
                        point: _stepPoints.isNotEmpty
                            ? LatLng(_stepPoints[2].latitude, _stepPoints[2].longitude + 0.0003) // Offset longitude to the right
                            : widget.initialCenter,
                        width: 80, // Overall marker width
                        height: 60, // Overall marker height
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Location pin icon
                            const Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.red,
                            ),
                            // Custom time-distance label above the pin with dynamic sizing
                            Positioned(
                              top: 0, // Position above the pin
                              child: IntrinsicWidth( // Adjust width based on content
                                child: IntrinsicHeight( // Adjust height based on content
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.directions_car, size: 14, color: Colors.black),
                                            SizedBox(width: 4),
                                            Text(
                                                time.toStringAsFixed(1) + 'mins', // Convert to minutes and append "mins"
                                              style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          distance.toStringAsFixed(1) + 'km', // Dynamic distance
                                          style: TextStyle(color: Colors.black54, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),



                  Marker(
                        point: widget.initialDestination,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.account_balance,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ]),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _stepPoints, // This is now correctly a List<LatLng>
                        strokeWidth: 4.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            _buildCongestionAndRecommendedBoxes(widget.congestionPoints, widget.allInstructions, context),
            SizedBox(height: 20),
            if (selectedIndex != null) ...[
              FutureBuilder<List<double>>(
                future: fetchGraphRatings(
                    _congestedCamera[selectedIndex!], // cameraID
                    'hour', // groupby
                    formatToSingaporeTime(DateTime.now().subtract(Duration(hours: 10))), // start time
                    formatToSingaporeTime(DateTime.now()) // end time
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<double> hourlyData = snapshot.data!;
                    // Display your graphs or other UI here
                    return _buildHourlyCongestionRatingGraph(hourlyData);
                  } else {
                    return Text("No data available");
                  }
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<List<double>>(
                future: fetchGraphRatings(
                    _congestedCamera[selectedIndex!], // cameraId
                    'day', // groupby for daily data
                    formatToSingaporeTime(DateTime.now().subtract(Duration(days: 10))), // start time
                    formatToSingaporeTime(DateTime.now())   // end time
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<double> dailyData = snapshot.data!;
                    return _buildCongestionHistoryGraph(dailyData);
                  } else {
                    return Text("No data available");
                  }
                },
              ),
            ],
            // Additional rows for congestion ratings and history...
          ],
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    print("Building markers...");

    // Reset the counters each time markers are built
    greenMarkersCount = 0;
    orangeMarkersCount = 0;
    redMarkersCount = 0;
    questionMarkCount = 0;
    // Check if allCongestionRatings is null or empty
    if (allCongestionRatings == null || allCongestionRatings.isEmpty) {
      print('No congestion ratings available.');
      return []; // Return an empty list if there are no ratings
    }

    // Create a list of markers
    List<Marker> markers = allCongestionRatings
        .map((allCongestionRating) {

      // Handle locations where congestion rating is not available
      if (allCongestionRating.rating.value == null) {
        questionMarkCount++;
        return Marker(
          point: LatLng(allCongestionRating.camera.location.latitude, allCongestionRating.camera.location.longitude),
          width: 60,
          height: 60,
          child: Icon(
            Icons.question_mark,
            size: 40,
            color: Colors.blue,
          ),

        );
      }

      // Handle locations where congestion rating is available
      Color markerColor = _getMarkerColor(allCongestionRating.rating.value.toDouble());

      // Increment the corresponding counter based on the marker color
      if (markerColor == Colors.green) {
        greenMarkersCount++;
      } else if (markerColor == Colors.orange) {
        orangeMarkersCount++;
      } else if (markerColor == Colors.red) {
        redMarkersCount++;
      }

      return Marker(
          point: LatLng(allCongestionRating.camera.location.latitude, allCongestionRating.camera.location.longitude),
          width: 60,
          height: 60,
          child: Icon(
            Icons.circle,
            size: 15, // Increased size for visibility
            color: markerColor,
          )
      );
    })
        .where((marker) => marker != null)
        .cast<Marker>()
        .toList(); // Filter out null markers and cast to List<Marker>

    return markers;
  }

  Color _getMarkerColor(double value) {
    if (value <= 0.3) {
      return Colors.green;
    } else if (value > 0.3 && value <= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  DateTime formatToSingaporeTime(DateTime date) {
    return date.toUtc().add(Duration(hours: 8));
  }

  Widget _buildCongestionAndRecommendedBoxes(List<String> congestionPoints, List<String> allInstructions, BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double congestionBoxWidth = screenWidth / 3; // 1/3 of the screen width
    double recommendedBoxWidth = (screenWidth * 2) / 3; // 2/3 of the screen width

    return Row(
      children: [
        // Congestion Points Box
        SizedBox(width: 15,),
        Expanded(
          flex: 1, // 1 part of the total 3 parts
          child: _buildCongestionPointsBox(congestionPoints),
        ),
        SizedBox(width: 10,),
        // Recommended Route Box
        Expanded(
          flex: 2, // 2 parts of the total 3 parts
          child: _buildRecommendedRouteBox(allInstructions),
        ),
        SizedBox(width: 15,),
      ],
    );
  }

  int? selectedIndex;
  Widget _buildCongestionPointsBox(List<String>? congestionPoints) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: congestionPoints != null ? "${congestionPoints.length}" : "0",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "Congestion Points",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            child: SingleChildScrollView(
              child: Column(
                children: congestionPoints != null && congestionPoints.isNotEmpty
                    ? List.generate(congestionPoints.length, (index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  index; // Update selected congestion point
                            });
                          },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              congestionPoints[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          if (index < congestionPoints.length - 1)
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 10,
                              indent: 25,
                              endIndent: 25,
                            ),
                        ],
                      )
                      );
                })
                    : [ // Fallback message if list is empty
                  Center(child: Text("No congestion points available.")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRecommendedRouteBox(List<String> allInstructions) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Recommended Route",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(allInstructions.length, (index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          allInstructions[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      if (index < allInstructions.length - 1)
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 10,
                          indent: 25,
                          endIndent: 25,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Placeholder methods for graphs
  Widget _buildHourlyCongestionRatingGraph(List<double> data) {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: Colors.red,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCongestionHistoryGraph(List<double> data) {
    return Container(
      height: 150,
      child: BarChart(
        BarChartData(
          barGroups: data
              .asMap()
              .entries
              .map((e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(toY: e.value, color: Colors.blue),
            ],
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTotalCongestionTimeGraph(List<String> imageUrls) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: EdgeInsets.all(5),
            child: Image.network(imageUrls[index]),
          );
        },
      ),
    );
  }
}