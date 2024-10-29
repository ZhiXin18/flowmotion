import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmotion/screens/fullMapScreen.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
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
  LatLng _initialCenter = LatLng(1.2878, 103.8666);
  LatLng _initialDestination = LatLng(1.3656412, 103.8726954);
  LatLng? _currentLocationMarker;
  List<String> savedAddresses = [];
  List<LatLng> _stepPoints = [];
  List<LatLng> allStepPoints = [];
  List<String> allInstructions = [];
  List<String> congestionPoints = [];
  late RoutePost200Response? routeData;

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
    _fetchSavedAddresses();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final routeApi = FlowmotionApi().getRoutingApi();
    final routePostRequest = RoutePostRequest((b) => b
      ..src.update((srcBuilder) => srcBuilder
        ..kind = RoutePostRequestSrcKindEnum.location //state that location lat long is provided
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = _initialCenter.latitude // Set the latitude
          ..longitude = _initialCenter.longitude // Set the longitude
        )
      )
      ..dest.update((destBuilder) => destBuilder
        ..kind = RoutePostRequestDestKindEnum.location //state that location lat long is provided
        ..location.update((locationBuilder) => locationBuilder
          ..latitude = _initialDestination.latitude // Set the destination latitude
          ..longitude = _initialDestination.longitude // Set the destination longitude
        )
      )
    );

    try {
      final response = await routeApi.routePost(routePostRequest: routePostRequest);
      print(routePostRequest);
      print("/////////////////////////");
      print(response.realUri);
      routeData = response.data;
      _processRouteResponse(routeData);

    } catch (e) {
      print('Exception when calling RoutingApi->routePost: $e\n');
    }
  }

  void _processRouteResponse(RoutePost200Response? response) {
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
          }
          // Add unique instructions
          if (!allInstructions.contains(step.instruction)) {
            allInstructions.add(step.instruction);
          }

          // Add unique instructions
          if (!congestionPoints.contains(step.name)) {
            congestionPoints.add(step.name);
          }
        }
      }
      print(allInstructions);
      print(congestionPoints);

      setState(() {
        _stepPoints = allStepPoints; // Set _stepPoints to the new List<LatLng>
      });

      print("Step Points: $_stepPoints");
      print("Route duration: ${route.duration}, distance: ${route.distance}");
    } else {
      print("No routes found in the response.");
    }
  }

  Future<Position?> _getCurrentLocation() async {
    Position? position = await locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _currentLocationMarker = LatLng(
            position.latitude, position.longitude);
      });

      _mainMapController.move(LatLng(position.latitude, position.longitude), 13.0);

      LatLng midpoint = LatLng(
        (_currentPosition!.latitude + _initialDestination.latitude) / 2,
        (_currentPosition!.longitude + _initialDestination.longitude) / 2,
      );

      _homeMapController.move(midpoint, 11.0);
      _workMapController.move(midpoint, 11.0);

      print('Location obtained: Latitude - ${position.latitude}, Longitude - ${position.longitude}');
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
            .where('userid', isEqualTo: currentUser.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          List<dynamic> addresses = userDoc.get('addresses') ?? [];

          setState(() {
            savedAddresses = addresses.map((address) {
              return (address as Map<String, dynamic>)['address'] as String? ?? '';
            }).toList();
          });

          print('Saved Addresses: $savedAddresses');
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

  LatLng _calculateMidpoint(LatLng point1, LatLng point2) {
    double midLatitude = (point1.latitude + point2.latitude) / 2;
    double midLongitude = (point1.longitude + point2.longitude) / 2;
    return LatLng(midLatitude, midLongitude);
  }

  @override
  void dispose() {
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
            Text("Dashboard", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
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
                initialCenter: _currentPosition != null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : _initialCenter,
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
                    i == 0 ? "Home" : "Work",
                    i == 0 ? _homeMapController : _workMapController,
                  ),
                ),
              if (savedAddresses.length >= 3 && savedAddresses.length > 2)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _buildSavedPlaceCard(
                    savedAddresses[2],
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

  Widget _buildSavedPlaceCard(String title, MapController controller) {
    return GestureDetector(
      onTap: () {
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
              initialZoom: 10, // Pass the initial zoom level
              currentLocationMarker: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
              initialDestination: _initialDestination,
              route: routeData ?? null, // Handle null case appropriately
              congestionPoints: congestionPoints,
              allInstructions: allInstructions
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
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocationMarker != null ? _currentLocationMarker! : _initialCenter,
                          width: 60,
                          height: 60,
                          child: const Icon(
                            Icons.location_pin,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        Marker(
                          point: _initialDestination,
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
                                  text: "${congestionPoints.length}",
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
                                  children: List.generate(allInstructions.length, (index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            allInstructions[index],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                        if (index < allInstructions.length - 1) // Avoid adding a divider after the last instruction
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