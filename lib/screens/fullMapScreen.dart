
import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/utilities/firebase_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/congestion_rating.dart';
import '../widgets/navigationBar.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  List<CongestionRating> congestionRatings = [];

  @override
  void initState() {
    super.initState();
    _fetchCongestionRatings();
  }

  Future<void> _fetchCongestionRatings() async {
    congestionRatings = await FirebaseCalls().getCongestionRatings();
    print("Fetched congestion ratings: $congestionRatings"); // Debug statement
    setState(() {}); // Update UI after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.fullMapScreen,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: _fullMap(),
    );
  }

  Widget _fullMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(1.2878, 103.8666),
        initialZoom: 14,
        interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    print("Building markers for congestion ratings: $congestionRatings"); // Debug statement
    return congestionRatings.map((congestionRating) {
      return Marker(
        point: LatLng(congestionRating.latitude, congestionRating.longitude),
        width: 60,
        height: 60,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.circle,
          size: 15, // Increased size for visibility
          color: _getMarkerColor(congestionRating.value),
        ),
      );
    }).toList(); // Convert iterable to list
  }

  Color _getMarkerColor(double value) {
    if (value < 0.3) {
      return Colors.green;
    } else if (value < 0.7) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
