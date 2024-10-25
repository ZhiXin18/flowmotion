import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmotion/screens/fullMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/widget_keys.dart';
import '../firebase_options.dart';
import '../utilities/firebase_calls.dart';
import '../utilities/location_service.dart';
import '../widgets/navigationBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'congestionRating.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  //make sure native code is set up correctly, need initialise native app before initialising firebase
  WidgetsFlutterBinding.ensureInitialized(); //auto called inside runApp, but need do before runApp so need do this codes
  await Firebase.initializeApp( //start firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationService locationService;
  Position? _currentPosition;
  LatLng _initialCenter = LatLng(
      1.2878, 103.8666); // Default location (Singapore)
  LatLng? _currentLocationMarker; // To hold the user location for the marker
  List<String> savedAddresses = []; // Store saved addresses

  // Add separate MapControllers for each map
  late final MapController _mainMapController;
  late final MapController _homeMapController;
  late final MapController _workMapController;

  @override
  void initState() {
    super.initState();
    locationService = LocationService(context);
    _mainMapController = MapController();
    _homeMapController = MapController();
    _workMapController = MapController();
    _getCurrentLocation();
    _fetchSavedAddresses(); // Fetch saved addresses
  }

  Future<Position?> _getCurrentLocation() async {
    Position? position = await locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentLocationMarker = LatLng(
            position.latitude, position.longitude); // Update marker position
      });

      // Programmatically update the main map's center using its MapController
      _mainMapController.move(LatLng(position.latitude, position.longitude),
          14.0); // Adjust the zoom level as needed
      _homeMapController.move(LatLng(position.latitude, position.longitude),
          14.0); // Adjust the zoom level as needed
      _workMapController.move(LatLng(position.latitude, position.longitude),
          14.0); // Adjust the zoom level as needed

      print('Location obtained: Latitude - ${position
          .latitude}, Longitude - ${position.longitude}');
    } else {
      print('Failed to get location.');
    }
    return _currentPosition;
  }

  Future<void> _fetchSavedAddresses() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await usersCollection
            .where('userid', isEqualTo: currentUser
            .uid) // Assuming 'userid' is the field to filter by
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          // Assuming the addresses field is an array of maps
          List<dynamic> addresses = userDoc.get('addresses') ?? [];

          // Extract address strings from the maps
          setState(() {
            savedAddresses = addresses.map((address) {
              // Assuming each address is a map and we want the value of the 'address' key
              return (address as Map<String, dynamic>)['address'] as String;
            }).toList();
          });

          print(
              'Saved Addresses: $savedAddresses'); // Print saved addresses for debugging
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching saved addresses: $e');
      }
    } else {
      print('No current user.');
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _mainMapController.dispose();
    _homeMapController.dispose();
    _workMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.homeScreen,
      backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            // Dashboard Header Section
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Where would you like to go today?",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),

            // Main Map View with "View Full Map" Button
            _buildMainMapView(),
            SizedBox(height: 20),

            GestureDetector(
              key: WidgetKeys.goMapButton,
              onTap: () {
                // Handle "View Full Map" action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullMapScreen(_currentPosition),
                  ),
                );
              },
              child: Text(
                "View full map >",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Saved Places Section
            _buildSavedPlacesSection(),
          ],
        ),
      ),
    );
  }

  // Build the main map view
  Widget _buildMainMapView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: FlutterMap(
              mapController: _mainMapController, // Main map controller
              options: MapOptions(
                initialCenter: _currentPosition != null
                    ? LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude)
                    : _initialCenter,
                // Default to initial center if location is not available yet
                initialZoom: 10, // Initial zoom level
              ),
              children: [
                TileLayer(
                  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                if (_currentLocationMarker != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocationMarker!,
                        // Use the user's current location
                        width: 60,
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.location_pin,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Build the saved places section (Home, Work)
  Widget _buildSavedPlacesSection() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Your saved places",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 20),
              // Build saved place cards based on savedAddresses
              for (int i = 0; i < savedAddresses.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  // Add right padding for spacing
                  child: _buildSavedPlaceCard(
                    i == 0 ? "Home" : "Work",
                    i == 0
                        ? _homeMapController
                        : _workMapController, // Alternate controllers or use your logic
                  ),
                ),
              // Add additional address fields only if there are 3 saved addresses
              if (savedAddresses.length >= 3 && savedAddresses.length > 2)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  // Add right padding for spacing
                  child: _buildSavedPlaceCard(
                    savedAddresses[2], // Use the third address
                    _homeMapController,
                  ),
                ),
              SizedBox(width: 30),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  // Reusable method to build saved place cards (Home, Work, etc.)
  Widget _buildSavedPlaceCard(String title, MapController controller) {
    return GestureDetector(
      onTap: () {
        // Navigate to CongestionRatingScreen with the corresponding title
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CongestionRatingScreen(savedPlaceLabel: title),
          ),
        );
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Add map view for each saved place
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: FlutterMap(
                  mapController: controller, // Use the respective MapController
                  options: MapOptions(
                    initialCenter: _currentPosition != null
                        ? LatLng(
                        _currentPosition!.latitude, _currentPosition!.longitude)
                        : _initialCenter,
                    // Default to initial center if location is not available yet
                    initialZoom: 10, // Initial zoom level
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    if (_currentLocationMarker != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocationMarker!,
                            // Use the user's current location
                            width: 60,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,  // Ensures the content scales down to fit the container
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "3",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFe9a59d),
                            ),
                          ),
                          Text(
                            "Congestion\nPoints",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    height: 80,
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,  // Ensures the content scales down to fit the container
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Recommended Route",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFe9a59d),
                              ),
                            ),
                            Text(
                              "Congestion Points",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Congestion Points",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  // Congestion Rating
                  Text(
                    "Congestion Rating",
                    style: TextStyle(
                        color: Color(0xFFe9a59d),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  // Rating graph placeholder
                  Center(
                    child: Text(
                      "Graph here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
