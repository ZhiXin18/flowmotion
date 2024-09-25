import 'package:flowmotion/screens/fullMapScreen.dart';
import 'package:flutter/material.dart';
import '../core/widget_keys.dart';
import '../widgets/navigationBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.homeScreen,
      backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Dashboard Header Section
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Where would you like to go today?",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Map View with View Full Map Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(1.2878, 103.8666),
                        initialZoom: 14,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                        ),
                        const MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(1.2878, 103.8666),
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
                  GestureDetector(
                    onTap: () {
                      // Handle "View Full Map" action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullMapScreen(),
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
                ],
              ),
            ),
            SizedBox(height: 30),

            // Saved Places Section
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your saved places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            // Home and Work Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home Card
                /*_buildSavedPlaceCard(
                  "Home",
                  "assets/home_map_preview.png", // Replace with your map image
                ),*/
                SizedBox(width: 10),
                // Work Card
                /*_buildSavedPlaceCard(
                  "Work",
                  "assets/work_map_preview.png", // Replace with your map image
                ),*/
                Container(),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Reusable method to build saved place cards (Home, Work, etc.)
  Widget _buildSavedPlaceCard(String title, String imageAsset) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Image.asset(
            imageAsset,
            height: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Congestion points
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "3",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text("Congestion\nPoints"),
                  ],
                ),
                SizedBox(height: 10),
                // Congestion Rating
                Text(
                  "Congestion Rating",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Rating graph placeholder
                Container(
                  height: 40,
                  width: 120,
                  color: Colors.redAccent[100],
                  child: Center(
                    child: Text(
                      "Graph here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



