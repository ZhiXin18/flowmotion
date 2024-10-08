import 'package:flutter/material.dart';
import '../models/congestion_rating.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/firebase_calls.dart';
final FirebaseCalls firebaseCalls = FirebaseCalls();

class CongestionRatingScreen extends StatefulWidget {
  final String savedPlaceLabel;

  CongestionRatingScreen({required this.savedPlaceLabel});

  @override
  _CongestionRatingScreenState createState() => _CongestionRatingScreenState();
}

class _CongestionRatingScreenState extends State<CongestionRatingScreen> {
  final FirebaseCalls firebaseCalls = FirebaseCalls();
  List<CongestionRating> congestionRatings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
              color: Colors.grey[300], // Placeholder for map view
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text('Map View of Recommended Route')),
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

  Widget _buildHourlyCongestionRatingGraph() {
    // Placeholder for the hourly congestion rating bar graph
    return Container(
      height: 200,
      color: Colors.redAccent[100],
      child: Center(
        child: Text('Hourly Congestion Rating Graph'),
      ),
    );
  }

  Widget _buildCongestionHistoryGraph() {
    // Placeholder for congestion rating graph for past 7 days
    return Container(
      height: 150,
      color: Colors.blueAccent[100],
      child: Center(
        child: Text('Congestion Rating History Graph'),
      ),
    );
  }

  Widget _buildTotalCongestionTimeGraph() {
    // Placeholder for total congestion time graph for past 7 days
    return Container(
      height: 150,
      color: Colors.greenAccent[100],
      child: Center(
        child: Text('Total Congestion Time Graph'),
      ),
    );
  }
}