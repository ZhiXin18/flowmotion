import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmotion/screens/fullMapScreen.dart';
import 'package:flowmotion/utilities/flowmotion_api_sgt.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import '../core/widget_keys.dart';
import '../firebase_options.dart';
import '../models/route_data.dart';
import '../utilities/firebase_calls.dart';
import '../utilities/location_service.dart';
import '../widgets/glowingUserMarker.dart';
import '../widgets/navigationBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'congestionRating.dart';
import 'package:flowmotion/globals.dart' as globals;

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
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
  LatLng _initialCenter = LatLng(1.342874, 103.67941);
  LatLng _initialDestination = LatLng(1.3656412, 103.8726954);
  LatLng? _currentLocationMarker;
  List<Map<String, dynamic>> savedAddresses = [];
  List<Congestion> allCongestionRatings = [];
  Set<String> uniqueCameraStepCombination = Set();

  late RoutePost200Response? routeData;
  List<LatLng> destinations = [LatLng(1.3521, 103.8198), LatLng(1.3656412, 103.8726954), LatLng(1.3521, 103.8198)];

  late final MapController _mainMapController;

  List<RouteData> routeDataList = []; // List to store route data for each destination
  List<MapController> mapControllers = [];

  bool _isFetchingData = false; // Track if data is being fetched

  @override
  void initState() {
    super.initState();
    _mainMapController = MapController();
    _initializeAddressesAndRoutes();
    fetchAllRatings();

  }

  // Create map controllers for each saved address
  void initializeMapControllers() {
    // Clear the list to avoid duplicates if this is called multiple times
    mapControllers.clear();

    for (var address in savedAddresses) {
      setState(() {
        mapControllers.add(MapController());
      });
    }
  }

  Future<void> _initializeAddressesAndRoutes() async {
    // Attempt to get current location first
    await _getCurrentLocation();

    // Use _initialCenter if _currentPosition is still null
    if (_currentPosition == null) {
      print('Current position not available, using initial center: $_initialCenter');
      _currentLocationMarker = _initialCenter; // Update the marker to the initial center
    } else {
      print('Current position obtained: $_currentPosition');
    }

    // Proceed to fetch saved addresses
    await _fetchSavedAddresses();
  }

  Future<Position?> _getCurrentLocation() async {
    print(globals.testingActive);
    if (globals.testingActive == false) {
      locationService = LocationService(context);
      Position? position = await locationService.getCurrentPosition();

      if (position != null) {
        setState(() {
          _currentPosition = position; // Set the current position if available
          _currentLocationMarker =
              LatLng(position.latitude, position.longitude); // Set the marker
        });

        _mainMapController.move(
            LatLng(position.latitude, position.longitude), 13.0);
      }
    } else {
      print('Failed to get location, marker will be set to initial center.');
      _currentLocationMarker = _initialCenter; // Ensure the marker reflects the initial center
    }

    return _currentPosition;
  }


  Future<void> _fetchRoute(LatLng src, LatLng dest, int index) async {
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
      // Assuming routeDataList is defined and is an instance of a class that holds multiple RouteData
      RouteData routeData = RouteData(); // Create a new instance of RouteData
      routeData.routeResponse = response.data; // Store the entire response data

      for(final route in routeData.routeResponse!.routes!) {
        for(final step in route.steps) {
          if(step.congestion != null) {
            //print(step.congestion);
          }
        }

      }
      // print(routeData.routeResponse);
      setState(() {
        routeDataList.add(routeData); // Assuming routeDataList is a List<RouteData>
      });

      _processRouteResponse(routeData.routeResponse, index); // Pass the index to process the response

    } catch (e) {
      print('Exception when calling RoutingApi->routePost: $e\n');
    }
  }

  void _processRouteResponse(RoutePost200Response? response, int index) {
    if (response != null && response.routes!.isNotEmpty) {
      final route = response.routes!.first;

      // Reference to the route data for the current index
      RouteData currentRouteData = routeDataList[index];

      for (var step in route.steps) {
        // Decode the step points to List<List<num>>
        List<List<num>> stepPoints = decodePolyline(step.geometry);

        if(step.congestion != null && step.name != "") {
          String cameraStepCombination = '${step.congestion!.camera.id}_${step.name}';

          // Check if the combination is unique and process
          if (!uniqueCameraStepCombination.contains(cameraStepCombination)) {
            setState(() {
              currentRouteData.congestionPoints.add(step.name);
            });
          }
        }

        // Convert each step point (List<num>) to LatLng
        for (var point in stepPoints) {
          if (point.length >= 2) { // Ensure that we have enough data
            // Convert point to LatLng
            LatLng latLngPoint = LatLng(point[0].toDouble(), point[1].toDouble());
            setState(() {
              currentRouteData.stepPoints.add(latLngPoint); // Add to the List<LatLng>

            });
          }

          // Add unique instructions
          if (!currentRouteData.instructions.contains(step.instruction)) {
            setState(() {
              currentRouteData.instructions.add(step.instruction);
            });
          }
        }
      }

      setState(() {
        // Optionally update the UI or any relevant state
        currentRouteData.stepPoints = currentRouteData.stepPoints;
      });
    } else {
      print("No routes found in the response.");
    }
  }

  Future<void> _fetchSavedAddresses() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await usersCollection
            .where('userid', isEqualTo: currentUser.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          List<dynamic> addresses = userDoc.get('addresses') ?? [];
          List<Map<String, dynamic>> updatedAddresses = [];

          for (var address in addresses) {
            double? latitude = address['latitude'];
            double? longitude = address['longitude'];

            if (latitude != null && longitude != null) {

              updatedAddresses.add({
                'label': address['label'],
                'address': address['address'],
                'postalCode': address['postalCode'],
                'coordinates': {'latitude': latitude, 'longitude': longitude},
              });
            } else {
              print('No coordinates found for postal code: ${address['postalCode']}');
            }
          }

          setState(() {
            savedAddresses = updatedAddresses;
            initializeMapControllers();
          });

          // Initialize route data list and fetch routes for each address
          for (int i = 0; i < savedAddresses.length; i++) {
            routeDataList.add(RouteData()); // Initialize route data list

            // Use _currentLocationMarker if available, else fallback to _initialCenter
            final src = _currentLocationMarker ?? _initialCenter;
            final dest = LatLng(
              savedAddresses[i]["coordinates"]["latitude"],
              savedAddresses[i]["coordinates"]["longitude"],
            );

            _fetchRoute(src, dest, i); // Call _fetchRoute
          }

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

  Future<void> fetchAllRatings() async {
    setState(() {
      _isFetchingData = true; // Start fetching data
    });

    final api = FlowmotionApi().getCongestionApiSgt();
    try {
      final response = await api.congestionsGet();

      if (mounted) { // Check if the widget is still mounted before calling setState
        setState(() {
          allCongestionRatings = response.data!.toList(); // Convert Iterable to List
        });
      }
    } catch (e) {
      print('Exception when calling CongestionApi->congestionsGet: $e\n');
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingData = false; // Stop fetching data
        });
      }
    }
  }

  List<Marker> _buildMarkers() {
    // Create a list of markers
    List<Marker> markers = allCongestionRatings
        .map((congestionRating) {
    })
        .where((marker) => marker != null)
        .cast<Marker>()
        .toList(); // Filter out null markers and cast to List<Marker>

    return markers;
  }

  @override
  void dispose() {
    _mainMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      key: WidgetKeys.homeScreen,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text("Dashboard", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'PressStart2P')),
            SizedBox(height: 5),
            Text("Where would you like to go today?", style: TextStyle(fontSize: 16, color: Colors.black54)),
            SizedBox(height: 20),
            _buildMainMapView(),
            SizedBox(height: 20),
            GestureDetector(
              key: WidgetKeys.goMapButton,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullMapScreen(_currentPosition),
                  ),
                );
              },
              child: Text("View full map >", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            _buildSavedPlacesSection(),
            if (_isFetchingData) // Show a loading indicator while fetching data
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildMainMapView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: FlutterMap(
              mapController: _mainMapController,
              options: MapOptions(
                initialCenter: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
                      width: 30,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: GlowingUserMarker(),
                    ),
                    ..._buildMarkers(), // Add congestion markers to the map
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

  Widget _buildSavedPlacesSection() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Your saved places", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 20),
              for (int i = 0; i < savedAddresses.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _buildSavedPlaceCard(
                    savedAddresses[i]['label'] ?? 'Saved Place',
                    mapControllers[i], // Use the corresponding map controller
                    LatLng(
                      savedAddresses[i]['coordinates']?['latitude'] ?? _initialDestination.latitude,
                      savedAddresses[i]['coordinates']?['longitude'] ?? _initialDestination.longitude,
                    ),
                    i,
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

  Widget _buildSavedPlaceCard(String title, MapController controller, LatLng destination, int index) {
    return GestureDetector(
      onTap: () {
        print('Congestion Points for index $index: ${routeDataList[index].congestionPoints}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CongestionRatingScreen(
                savedPlaceLabel: title,
                initialCenter: _currentPosition != null
                    ? LatLng(
                  (_currentPosition!.latitude + _initialDestination.latitude) / 2,
                  (_currentPosition!.longitude + _initialDestination.longitude) / 2,
                )
                    : LatLng(
                  (_initialCenter.latitude + _initialDestination.latitude) / 2,
                  (_initialCenter.longitude + _initialDestination.longitude) / 2,
                ),
                initialZoom: 9, // Pass the initial zoom level
                currentLocationMarker: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
                initialDestination: destination ?? _initialDestination,
                congestionPoints: routeDataList[index].congestionPoints,
                allInstructions: routeDataList[index].instructions
            ),
          ),
        );
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: IgnorePointer( //make the map uninteractive
                child: FlutterMap(
                  mapController: controller,
                  options: MapOptions(
                    initialCenter: _currentPosition != null
                        ? LatLng(
                      (_currentPosition!.latitude + _initialDestination.latitude) / 2,
                      (_currentPosition!.longitude + _initialDestination.longitude) / 2,
                    )
                        : LatLng(
                      (_initialCenter.latitude + _initialDestination.latitude) / 2,
                      (_initialCenter.longitude + _initialDestination.longitude) / 2,
                    ),
                    initialZoom: 10,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routeDataList[index].stepPoints, // This is now correctly a List<LatLng>
                          strokeWidth: 4.0,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
                          width: 30,
                          height: 30,
                          child: GlowingUserMarker()
                        ),
                        Marker(
                          point: destination != null ? destination : _initialDestination,
                          width: 60,
                          height: 60,
                          child: const Icon(
                            Icons.account_balance,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${routeDataList[index].congestionPoints.length}",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFe9a59d),
                                  ),
                                ),
                                TextSpan(text: "\n"),
                                TextSpan(
                                  text: "Congestion",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(text: "\n"),
                                TextSpan(
                                  text: "Points",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IgnorePointer(
                    child: SizedBox(
                      height: 80,
                      width: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Recommended Route",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFe9a59d),
                              ),
                            ),
                            // Scrollable area for instructions
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(routeDataList[index].instructions.length, (listIndex) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            routeDataList[index].instructions[listIndex],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                        if (index < routeDataList[index].instructions.length - 1) // Avoid adding a divider after the last instruction
                                          const Divider(
                                            color: Colors.grey, // You can customize the color
                                            thickness: 1,
                                            height: 10, // Space between the text and the divider
                                            indent: 20, // Adds padding to the left of the divider
                                            endIndent: 20, // Adds padding to the right of the divider
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
