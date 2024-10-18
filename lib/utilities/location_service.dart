import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  String? currentAddress;
  Position? currentPosition;
  final BuildContext context;

  // Constructor to accept context from where it's called
  LocationService(this.context);

  // Handle Location Permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Location services are disabled. Please enable them in settings.');
      return false;
    }

    // Check for current permission status
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('Location permissions are denied');
        return false;
      }
    }

    // Check if permission is denied forever (user selected "Don't ask again")
    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedDialog();
      return false;
    }

    return true;
  }

  // Show permission denied dialog if permanently denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text('Location permissions are permanently denied. Please enable permissions from the app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings(); // Open app settings for the user to enable location permissions
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Get Current Position
  Future<Position?> getCurrentPosition() async {
    // Request location permission if necessary
    bool permissionGranted = await _handleLocationPermission();
    if (!permissionGranted) return null;

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error fetching location: $e');
    }

    return currentPosition;
  }

  // Utility function to show snack bar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
