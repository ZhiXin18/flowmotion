import 'dart:async'; // Import Timer
import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import '../utilities/location_service.dart';
import '../widgets/navigationBar.dart';
import 'package:latlong2/latlong.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen(Position? currentPosition, {super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  List<Congestion> congestionRatings = [];
  late LocationService locationService;
  Position? _currentPosition;
  LatLng _initialCenter =
  LatLng(1.3402, 103.6755); // Default location (Singapore)
  LatLng? _currentLocationMarker; // To hold the user location for the marker

  // Add MapController
  late final MapController _mapController;

  // Counters for marker categories
  int greenMarkersCount = 0;
  int orangeMarkersCount = 0;
  int redMarkersCount = 0;
  int questionMarkCount = 0; // For missing congestion ratings

  // Timer for automatic fetching
  Timer? _fetchTimer;

  @override
  void initState() {
    super.initState();
    _fetchCongestionRatings(); // Fetch immediately on initialization
    locationService = LocationService(context);
    _mapController = MapController();
    //_getCurrentLocation();

    // Set up a timer to fetch data every 5 minutes
    _fetchTimer = Timer.periodic(Duration(minutes: 5), (Timer timer) {
      print("Timer triggered: Fetching congestion ratings...");
      _fetchCongestionRatings();
    });
  }

  Future<Position?> _getCurrentLocation() async {
    Position? position = await locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentLocationMarker = LatLng(
            position.latitude, position.longitude); // Update marker position
      });

      // Programmatically update the map's center using the MapController
      _mapController.move(LatLng(position.latitude, position.longitude),
          14.0); // Adjust the zoom level as needed
    } else {
      print('Failed to get location.');
    }
    return _currentPosition;
  }

  Future<void> _fetchCongestionRatings() async {
    final api = FlowmotionApi().getCongestionApi();
    try {
      final response = await api.congestionsGet();

      setState(() {
        congestionRatings = response.data!.toList(); // Convert Iterable to List
      });
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet: $e\n');
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _fetchTimer?.cancel();
    super.dispose();
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
      mapController: _mapController, // Pass the MapController here
      options: MapOptions(
        initialCenter: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : _initialCenter, // Default to initial center if location is not available yet
        initialZoom: 10, // Initial zoom level
        interactionOptions:
        const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: _buildMarkers()),
      ],
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
    List<Marker> markers = congestionRatings
        .map((congestionRating) {
      String coordinateKey =
          "${congestionRating.camera.location.latitude},${congestionRating.camera.location.longitude}";


        // Handle locations where congestion rating is not available
        if (congestionRating.rating.value == null) {
          questionMarkCount++;
          return Marker(
            point: LatLng(congestionRating.camera.location.latitude, congestionRating.camera.location.longitude),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () {
                // Show dialog with relevant information
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("No Congestion Data Available"),
                      content: congestionRating.camera.imageUrl != null
                          ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("No congestion rating available."),
                          const SizedBox(height: 10),
                          Image.network(
                            congestionRating.camera.imageUrl!,
                            width: 200,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ],
                      )
                          : Text("No image available"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.question_mark,
                    size: 40,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          );
        }

        // Handle locations where congestion rating is available
        Color markerColor = _getMarkerColor(congestionRating.rating.value.toDouble());

        // Increment the corresponding counter based on the marker color
        if (markerColor == Colors.green) {
          greenMarkersCount++;
        } else if (markerColor == Colors.orange) {
          orangeMarkersCount++;
        } else if (markerColor == Colors.red) {
          redMarkersCount++;
        }

        return Marker(
          point: LatLng(congestionRating.camera.location.latitude, congestionRating.camera.location.longitude),
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: () {
              // Show dialog with the image URL when the marker is tapped
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    //title: Text("Congestion Rating: ${congestionRating.value}"),
                    content: congestionRating.camera.imageUrl != null
                        ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Image.network(
                          congestionRating.camera.imageUrl!,
                          width: 250,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                        : Text("No image available"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              Icons.circle,
              size: 15, // Increased size for visibility
              color: markerColor,
            ),
          ),
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
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
