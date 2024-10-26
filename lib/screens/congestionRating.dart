import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/congestion_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/firebase_calls.dart';

final FirebaseCalls firebaseCalls = FirebaseCalls();

class CongestionRatingScreen extends StatefulWidget {
  final String savedPlaceLabel;
  final LatLng initialCenter; // Add initial center configuration
  final double initialZoom; // Add initial zoom configuration
  final LatLng? currentLocationMarker; // Current location marker
  final LatLng initialDestination; // Initial destination

  CongestionRatingScreen({
    required this.savedPlaceLabel,
    required this.initialCenter, // Accept initial center
    required this.initialZoom, // Accept initial zoom level
    required this.currentLocationMarker, // Current location marker
    required this.initialDestination, // Initial destination
  });

  @override
  _CongestionRatingScreenState createState() => _CongestionRatingScreenState();
}

class _CongestionRatingScreenState extends State<CongestionRatingScreen> {
  final FirebaseCalls firebaseCalls = FirebaseCalls();
  late final MapController _mapController;
  List<CongestionRating> congestionRatings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    fetchCongestionRatings();
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

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.savedPlaceLabel),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // "From" label and input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter current location',
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Map View
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: FlutterMap(
                mapController: _mapController, // Use the passed controller
                options: MapOptions(
                  initialCenter: widget.initialCenter, // Use the passed initial center
                  initialZoom: widget.initialZoom, // Use the passed initial zoom
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),

                  if (widget.currentLocationMarker != null)
                    MarkerLayer(markers: [
                      Marker(
                        point: widget.currentLocationMarker!,
                        width: 60,
                        height: 60,
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
                        points: [
                          widget.currentLocationMarker ?? LatLng(0, 0), // Use a default value or handle null safely
                          widget.initialDestination,
                        ],
                        strokeWidth: 4.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Row 1: Congestion Points and Recommended Route
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCongestionPointsBox(),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildRecommendedRouteBox(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Additional rows for congestion ratings and history...
          ],
        ),
      ),
    );
  }

  Widget _buildCongestionPointsBox() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${congestionRatings.length} Congestion Points",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...congestionRatings.map((rating) {
            return Text("Lat: ${rating.latitude}, Lng: ${rating.longitude}, Rating: ${rating.value}");
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendedRouteBox() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Route", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("1. Turn right onto XYZ\n2. Continue straight\n3. Exit at ABC"), // Simplified directions
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
