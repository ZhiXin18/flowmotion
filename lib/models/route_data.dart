import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:latlong2/latlong.dart';

class RouteData {
  List<LatLng> stepPoints;          // List to hold LatLng points
  List<String> instructions;         // List to hold route instructions
  List<String> congestionPoints;     // List to hold congestion points
  RoutePost200Response? routeResponse; // Renamed to avoid duplication

  RouteData()
      : stepPoints = [],              // Initialize stepPoints
        instructions = [],            // Initialize instructions
        congestionPoints = [],        // Initialize congestionPoints
        routeResponse = null;         // Initialize routeResponse
}
