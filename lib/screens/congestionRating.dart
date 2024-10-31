import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';
import '../models/congestion_rating.dart';
import '../utilities/firebase_calls.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

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

  // Counters for marker categories
  int greenMarkersCount = 0;
  int orangeMarkersCount = 0;
  int redMarkersCount = 0;
  int questionMarkCount = 0; // For missing congestion ratings

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    fetchCongestionRatings();
    fetchAllRatings();
    _fetchRoute(
        widget.currentLocationMarker ?? LatLng(0, 0), // Provide a default LatLng if null
        widget.initialDestination
    );
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
    List<String> congestedSteps = []; // To store the step names that overlap with congestion markers

    if (response != null && response.routes!.isNotEmpty) {
      final route = response.routes!.first;

      for (var step in route.steps) {
        // Decode the step points to List<List<num>>
        List<List<num>> stepPoints = decodePolyline(step.geometry); // This remains List<List<num>>

        // Convert each step point (List<num>) to LatLng
        for (var point in stepPoints) {
          if (point.length >= 2) { // Ensure that we have enough data
            // Convert point to LatLng
            LatLng latLngPoint = LatLng(point[0].toDouble(), point[1].toDouble());
            allStepPoints.add(latLngPoint); // Add to the List<LatLng>

            // Check for overlap with congestion markers
            if (_isPointNearCongestion(latLngPoint)) {
              congestedSteps.add(step.name); // Save the step name
            }
          }
        }
      }

      setState(() {
        _stepPoints = allStepPoints; // Set _stepPoints to the new List<LatLng>
        widget.congestionPoints = congestedSteps; // Update the widget's congestionPoints with the saved steps
      });

    } else {
      print("No routes found in the response.");
    }
  }

  // Helper function to check if a point is near any congestion marker
  bool _isPointNearCongestion(LatLng stepPoint) {
    const double proximityThreshold = 0.001; // Define a threshold for proximity (adjust this value based on your needs)

    for (var congestionRating in allCongestionRatings) {
      LatLng markerLocation = LatLng(
        congestionRating.camera.location.latitude,
        congestionRating.camera.location.longitude,
      );

      // Calculate the distance between the step point and the congestion marker
      double distance = Distance().as(
        LengthUnit.Meter,
        stepPoint,
        markerLocation,
      );

      if (distance <= proximityThreshold) {
        return true; // Return true if the step point is near a congestion marker
      }
    }

    return false; // Return false if no congestion marker is close enough
  }


  Future<void> fetchCongestionRatings() async {
    try {
      List<CongestionRating> ratings = await firebaseCalls.getCongestionRatingsForPlace(widget.savedPlaceLabel);
      setState(() {
        congestionRatings = ratings;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching congestion ratings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAllRatings() async {
    final api = FlowmotionApi().getCongestionApi();
    try {
      final response = await api.congestionsGet();

      setState(() {
        allCongestionRatings = response.data!.toList(); // Convert Iterable to List
      });
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet: $e\n');
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

    print(congestionBoxWidth);
    print(recommendedBoxWidth);
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
                  initialZoom: 14, // Use the passed initial zoom
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: _buildMarkers()), // Add the congestion markers
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
            // Row 1: Congestion Points and Recommended Route
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCongestionPointsBox(widget.congestionPoints, congestionBoxWidth),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildRecommendedRouteBox(widget.allInstructions, recommendedBoxWidth),
                  ),
                ],
              ),
            ),*/
            SizedBox(height: 20),

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


    // Create a list of markers
    List<Marker> markers = allCongestionRatings
        .map((allCongestionRatings) {
      String coordinateKey =
          "${allCongestionRatings.camera.location.latitude},${allCongestionRatings.camera.location.longitude}";


      // Handle locations where congestion rating is not available
      if (allCongestionRatings.rating.value == null) {
        questionMarkCount++;
        return Marker(
          point: LatLng(allCongestionRatings.camera.location.latitude, allCongestionRatings.camera.location.longitude),
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
      Color markerColor = _getMarkerColor(allCongestionRatings.rating.value.toDouble());

      // Increment the corresponding counter based on the marker color
      if (markerColor == Colors.green) {
        greenMarkersCount++;
      } else if (markerColor == Colors.orange) {
        orangeMarkersCount++;
      } else if (markerColor == Colors.red) {
        redMarkersCount++;
      }

      return Marker(
          point: LatLng(allCongestionRatings.camera.location.latitude, allCongestionRatings.camera.location.longitude),
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

    // Print the counts for each category
    print("Number of green markers: $greenMarkersCount");
    print("Number of orange markers: $orangeMarkersCount");
    print("Number of red markers: $redMarkersCount");
    print("Number of question mark markers: $questionMarkCount");
    print("Number of unique markers: ${markers.length}");

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

  Widget _buildCongestionPointsBox(List<String> congestionPoints) {
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
                  text: "${congestionPoints.length}",
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
                children: List.generate(congestionPoints.length, (index) {
                  return Column(
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
                  );
                }),
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
  Widget _buildHourlyCongestionRatingGraph() {
    return Container(
      height: 200,
      color: Colors.redAccent[100],
      child: Center(
        child: Text('Hourly Congestion Rating Graph'),
      ),
    );
  }

  Widget _buildCongestionHistoryGraph() {
    return Container(
      height: 150,
      color: Colors.blueAccent[100],
      child: Center(
        child: Text('Congestion Rating History Graph'),
      ),
    );
  }

  Widget _buildTotalCongestionTimeGraph() {
    return Container(
      height: 150,
      color: Colors.greenAccent[100],
      child: Center(
        child: Text('Total Congestion Time Graph'),
      ),
    );
  }
}