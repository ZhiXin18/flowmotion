import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/navigationBar.dart';
import 'package:latlong2/latlong.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        MarkerLayer(markers: [
          Marker(
            point: LatLng(1.2878, 103.8666),
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.circle,
              size: 15,
              color: Colors.red,
            )
          )
        ])
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);