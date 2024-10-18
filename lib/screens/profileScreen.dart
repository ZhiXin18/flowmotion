import 'package:flutter/material.dart';

import '../widgets/navigationBar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/firebase_calls.dart';
import 'homeScreen.dart';

FirebaseCalls firebaseCalls = FirebaseCalls();

// retrieving user data
class FirebaseCalls {
  Future<Map<String, dynamic>?> getUserData() async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    QuerySnapshot querySnap = await usersCollection.where('userid', isEqualTo: currentUser.uid).get();
    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot userDoc = querySnap.docs[0];
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      String username = userData['username']; // Registered name
      List<dynamic> addresses = userData['addresses']; // List of saved addresses

      // Return both the username and addresses
      return {
        'username': username,
        'addresses': addresses,
      };
    } else {
      print("No user data found.");
      return null;
    }
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = ''; // To store username
  List<Map<String, dynamic>> addresses = []; // To store saved addresses
  bool allowLocationAccess = false; // To track checkbox value

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // load user data
  Future<void> _loadUserData() async {
    Map<String, dynamic>? userData = await firebaseCalls.getUserData();
    if (userData != null) {
      setState(() {
        username = userData['username'];
        addresses = List<Map<String, dynamic>>.from(userData['addresses']);
      });
    }
  }

  // open the user manual pdf
  // Future<void> _launchUserManual() async {
    // const url = 'https://example.com/user-manual.pdf'; // Replace with actual URL of the user manual PDF
    // if (await canLaunch(url)) {
      // await launch(url);
    // } else {
      // throw 'Could not launch $url';
    // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username section
            Text(
              'Welcome, $username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Link to user manual
            GestureDetector(
              // onTap: _launchUserManual,
              child: Text(
                'Open User Manual',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 32),

            // Saved places section with different background color
            Container(
              color: Colors.grey[200], // Different colored section
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Places',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // List of saved places
                  addresses.isEmpty
                      ? Text('No saved places yet.')
                      : ListView.builder(
                    shrinkWrap: true, // To prevent scrolling issues
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> address = addresses[index];
                      return ListTile(
                        title: Text('${address["label"]}'),
                        subtitle: Text(
                            '${address["address"]}, ${address["postalCode"]}'),                      );
                    },
                  ),

                  // Add more button
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for adding more places
                    },
                    child: Text('Add More'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Checkbox for allowing location access
            Row(
              children: [
                Checkbox(
                  value: allowLocationAccess,
                  onChanged: (value) {
                    setState(() {
                      allowLocationAccess = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I allow Flowmotion to access my location when I use the app',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save changes logic here
                },
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

