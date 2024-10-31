import 'package:flutter/material.dart';
import '../widgets/navigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/firebase_calls.dart';
import 'homeScreen.dart';


FirebaseCalls firebaseCalls = FirebaseCalls();

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

  // Load user data
  Future<void> _loadUserData() async {
    Map<String, dynamic>? userData = await firebaseCalls.getUserData();
    if (userData != null) {
      setState(() {
        username = userData['username'];
        addresses = List<Map<String, dynamic>>.from(userData['addresses']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Divide screen height into 1/3 and 2/3
          double topSectionHeight = constraints.maxHeight * 1 / 3;
          double bottomSectionHeight = constraints.maxHeight * 2 / 3;

          return Column(
            children: [
              // Top Section (1/3 of screen height)
              Container(
                height: topSectionHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center align the items in the Row
                  children: [
                    Container(
                      height: 80, // Set the desired height for the icon
                      width: 80, // Set a width if needed for the icon
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 80, // Adjust the icon size as needed
                      ),
                    ),
                    SizedBox(width: 10), // Add spacing between the icon and the text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center align text within the Column
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                      children: [
                        // Username section
                        Text(
                          '$username',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5), // Adjust spacing between username and manual link

                        // Link to user manual
                        GestureDetector(
                          child: Text(
                            'Open User Manual',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),

              // Bottom Section (2/3 of screen height)
              Container(
                height: bottomSectionHeight,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Color(0xFF696e6e),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saved Places title
                    Text(
                      'Your Saved Places',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),

                    // List of saved places
                    Expanded(
                      child: addresses.isEmpty
                          ? Text(
                        'No saved places yet.',
                        style: TextStyle(color: Colors.white),
                      )
                          : ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> address = addresses[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Address Label TextField
                                TextField(
                                  controller: TextEditingController(
                                    text: address["label"],
                                  ),
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Label (e.g., Home, Work)',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      addresses[index]["label"] = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 8),

                                // Row with Postal Code and Address TextFields
                                Row(
                                  children: [
                                    // Postal Code TextField (1/3 of the width)
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: address["postalCode"],
                                        ),
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          hintText: 'Postal Code',
                                          hintStyle: TextStyle(color: Colors.black),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            addresses[index]["postalCode"] = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),

                                    // Address TextField (2/3 of the width)
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: address["address"],
                                        ),
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          hintText: 'Building/ Street/ etc',
                                          hintStyle: TextStyle(color: Colors.black),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            addresses[index]["address"] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Add More button
                    Container(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            addresses.add({
                              "label": '',
                              "postalCode": '',
                              "address": '',
                            });
                          });
                        },
                        child: Text('Add More', style: TextStyle(color: Colors.white, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: Color(0xFF696e6e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Save changes button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Remove empty addresses
                          _removeEmptyAddresses();
                          setState(() async {
                            await _saveChanges();
                          });
                        },
                        child: Text('Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          backgroundColor: Color(0xFFD4543C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  // Function to remove addresses with blank fields
  void _removeEmptyAddresses() {
    addresses.removeWhere((address) =>
    (address["label"]?.isEmpty ?? true) ||
        (address["postalCode"]?.isEmpty ?? true) ||
        (address["address"]?.isEmpty ?? true));
  }

  // Define _saveChanges method
  Future<void> _saveChanges() async {
    try {
      // Update user addresses
      await firebaseCalls.updateUser(username, addresses);

      // Provide feedback if needed (e.g., show a Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Addresses saved successfully!')),
      );
    } catch (error) {
      // Handle any errors here
      print('Failed to save addresses: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save addresses. Please try again.')),
      );
    }
  }

}
