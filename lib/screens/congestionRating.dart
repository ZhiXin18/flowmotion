import 'package:flowmotion/models/rating_point.dart';
import 'package:flowmotion/utilities/flowmotion_api_sgt.dart';
import 'package:flowmotion/widgets/congestionPointView.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';

import '../models/congestion_rating.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigationBar.dart';

final FirebaseCalls firebaseCalls = FirebaseCalls();

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
  List<LatLng> _stepPointsNotOpt = [];
  List<LatLng> allStepPoints = [];
  List<LatLng> allStepPointsNotOpt = [];
  List<Map<String, String>> _stepInfo = []; // Store time and distance for each step
  List<String> congestedCamera = [];
  List<RatingPoint> historyRatings = [];

  // Create a Set to store unique combinations of camera.id and step.name
  Set<String> uniqueCameraStepCombination = Set();

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

  Future<void> fetchGraphRatings(String cameraId, String groupby, DateTime begin, DateTime end) async {
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
      if (response.data != null && response.data!.isNotEmpty) {
        // Group the data by hour
        Map<int, List<Map<String, dynamic>>> hourlyData = {};
        for (var item in response.data!) {
          DateTime ratedOn = item.rating.ratedOn;
          num value = item.rating.value;
          String imageUrl = item.camera.imageUrl;
          int hour = ratedOn.hour;
          ratingPoints.add(RatingPoint(
            ratedOn: DateTime(begin.year, begin.month, begin.day, hour),
            value: value,
            imageUrls: imageUrl,
          ));
        };
        historyRatings = ratingPoints;
        print("Ratings fetched: $historyRatings");
      }
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet with parameters: $e\n');
    }
  }

  Future<void> fetchAllRatings() async {
    final api = FlowmotionApi().getCongestionApiSgt();
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
        ..kind = RoutePostRequestSrcKindEnum.location
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = src.latitude
          ..longitude = src.longitude
        )
      )
      ..dest.update((destBuilder) => destBuilder
        ..kind = RoutePostRequestDestKindEnum.location
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = dest.latitude
          ..longitude = dest.longitude
        )
      )
    );

    try {
      // First API call with the default parameters
      final response = await routeApi.routePost(routePostRequest: routePostRequest);
      _processRouteResponse(response.data, false);

      final secondaryRoutePostRequest = RoutePostRequest((b) => b
        ..src.update((srcBuilder) => srcBuilder
          ..kind = RoutePostRequestSrcKindEnum.location
          ..location.update((locationBuilder) => locationBuilder
            ..latitude = src.latitude
            ..longitude = src.longitude
          )
        )
        ..dest.update((destBuilder) => destBuilder
          ..kind = RoutePostRequestDestKindEnum.location
          ..location.update((locationBuilder) => locationBuilder
            ..latitude = dest.latitude
            ..longitude = dest.longitude
          )
        )
        ..congestion = false
      );
      // Second API call with `false` as a parameter to get step points for another polyline
      final responseWithFalse = await routeApi.routePost(routePostRequest: secondaryRoutePostRequest); // Adjust as necessary based on your API
      _processRouteResponse(responseWithFalse.data, true); // Process response for the second route

    } catch (e) {
      print('Exception when calling RoutingApi->routePost: $e\n');
    }
  }

  void _processRouteResponse(RoutePost200Response? response, bool isSecondary) {
    List<String> congestedSteps = [];
    List<String> congestedStepsNotOpt = [];
    List<Map<String, String>> stepInfo = []; // Store time and distance for each step

    if (!isSecondary) {
      if (response != null && response.routes!.isNotEmpty) {
        final route = response.routes!.first;

        for (var step in route.steps) {
          List<List<num>> stepPoints = decodePolyline(step.geometry);

          if (step.congestion != null && step.name != "") {
            // Check if the combination of camera.id and step.name is already in the Set
            String cameraStepCombination = '${step.congestion!.camera.id}_${step.name}';
            if (!uniqueCameraStepCombination.contains(cameraStepCombination)) {
              // If not, add to the list and Set
              setState(() {
                congestedSteps.add(step.name);

                uniqueCameraStepCombination.add(cameraStepCombination);
                if (!congestedCamera.contains(step.congestion!.camera.id)) {
                  congestedCamera.add(step.congestion!.camera.id);
                }
              });
            }
          }

          // Check for congestion and capture step info
          for (var point in stepPoints) {
            if (point.length >= 2) {
              LatLng latLngPoint = LatLng(point[0].toDouble(), point[1].toDouble());
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
          });
        }
      } else {
        print("No routes found in the response.");
      }
    } else {
      if (response != null && response.routes!.isNotEmpty) {
        final routeNotOpt = response.routes!.first;

        for (var step in routeNotOpt.steps) {
          List<List<num>> stepPointsNotOpt = decodePolyline(step.geometry);

          if (step.congestion != null) {
            // Check if the combination of camera.id and step.name is already in the Set
            String cameraStepCombination = '${step.congestion!.camera.id}_${step.name}';
            if (!uniqueCameraStepCombination.contains(cameraStepCombination)) {
              // If not, add to the list and Set
              setState(() {
                congestedStepsNotOpt.add(step.name);
                uniqueCameraStepCombination.add(cameraStepCombination);
              });
            }
          }

          // Check for congestion and capture step info
          for (var point in stepPointsNotOpt) {
            if (point.length >= 2) {
              LatLng latLngPoint = LatLng(point[0].toDouble(), point[1].toDouble());
              setState(() {
                allStepPointsNotOpt.add(latLngPoint);
              });
            }
          }

          setState(() {
            _stepPointsNotOpt = allStepPointsNotOpt;
          });
        }
      } else {
        print("No routes found in the response.");
      }
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

    return Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
        Colors.blue,
        Color(0xFFEFF3F9), // Light Blue
    Color(0xFFF2F2F2),
    Colors.grey// Light Grey
    ],
    ),
    ),

    child: Scaffold(
      backgroundColor: Colors.transparent,
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
                SizedBox(height: 10),
                Text(
                  widget.savedPlaceLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'PressStart2P',
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
                key: WidgetKeys.congestionMapScreen,
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
                  PolylineLayer(
                    key: WidgetKeys.congestionMapRoute,
                    polylines: [
                      Polyline(
                        points: _stepPointsNotOpt, // This is now correctly a List<LatLng>
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                      Polyline(
                        points: _stepPoints, // This is now correctly a List<LatLng>
                        strokeWidth: 4.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      ..._buildMarkers(), // Existing markers
                    ],
                  ),
                  if (widget.currentLocationMarker != null)
                    MarkerLayer(
                      key: WidgetKeys.congestionMapMarkers,
                      markers: [
                      
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

                ],
              ),
            ),
            SizedBox(height: 20),

            _buildCongestionAndRecommendedBoxes(widget.congestionPoints, widget.allInstructions, context),
            SizedBox(height: 20),
            if (selectedIndex != null) 
              CongestionPointView(cameraId: congestedCamera[selectedIndex!])
          ],
        ),
      ),
    )
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
    List<Marker> markers = allCongestionRatings.asMap().keys
        .map((index) {
      final allCongestionRating = allCongestionRatings[index];

      // Handle locations where congestion rating is not available
      if (allCongestionRating.rating.value == null) {
        questionMarkCount++;
        return Marker(
          key: WidgetKeys.congestionMarker(index),
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
          key: WidgetKeys.congestionMarker(index),
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
                          key: WidgetKeys.congestionPoint(index) ,
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
                    key: WidgetKeys.routeStep(index),
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
}
