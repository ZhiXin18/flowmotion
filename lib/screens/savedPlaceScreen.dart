import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
//import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../screens/registerScreen.dart';
import '../components/background.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SavedPlaceScreen(userId: '', userEmail: '',));
}

class SavedPlaceScreen extends StatefulWidget {
  final String userId;
  final String userEmail;

  const SavedPlaceScreen({Key? key, required this.userId, required this.userEmail}) : super(key: key);

  @override
  _SavedPlaceScreenState createState() => _SavedPlaceScreenState();
}

class _SavedPlaceScreenState extends State<SavedPlaceScreen> {
  List<String> addressLabels = ['Home', 'Work'];
  bool _termsAccepted = false;
  bool _notificationsAllowed = false;
  Map<String, Map<String, String>> savedAddresses = {};

  void _addAddress() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Address Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Enter new address name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.delete();
                Navigator.of(context).pop(nameController.text);

              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        addressLabels.add(newName);
        savedAddresses[newName] = {'postalCode': '', 'address': ''};
      });
    }
  }

  void _saveUserData() async {
    if (!_termsAccepted) {
      _showErrorDialog('You must accept the terms and conditions.');
      return;
    }

    bool allFieldsFilled = savedAddresses.values.every(
          (address) => address['postalCode']!.isNotEmpty && address['address']!.isNotEmpty,
    );

    if (!allFieldsFilled) {
      _showErrorDialog('Please fill in all address fields.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('flowmotionUsers').doc(widget.userId).set({
        'email': widget.userEmail,
        'addresses': savedAddresses,
        'termsAccepted': _termsAccepted,
        'notificationsAllowed': _notificationsAllowed,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace NextScreen with your next screen
      );
    } catch (e) {
      //_showErrorDialog('Failed to save data. Please try again.');
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    savedAddresses[label]?['postalCode'] = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Postal Code',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    savedAddresses[label]?['address'] = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Building/Street/etc',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // Add spacing between address fields
      ],
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  '02.',
                  style: TextStyle(
                    color: Color(0xFFD4543C),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Help us understand\n your needs',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                    _buildSectionHeader('Register your saved places'),
                    SizedBox(height: 20),
                    ...addressLabels.map((label) => _buildAddressField(label)).toList(),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _addAddress,
                        child: Text(
                          'Add More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          backgroundColor: Color(0xFFD696e6e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildCheckbox(
                      'I have read and accepted the Terms and Conditions of data storage and location privacy',
                      _termsAccepted,
                          (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    _buildCheckbox(
                      'Allow notifications from FlowMotion',
                      _notificationsAllowed,
                          (bool? value) {
                        setState(() {
                          _notificationsAllowed = value ?? false;
                        });
                      },
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveUserData,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          backgroundColor: Color(0xFFD4543C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Let\'s get started!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}


  /*Widget _buildAddressField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  savedAddresses[label]?['postalCode'] = value;
                },
                decoration: InputDecoration(
                  hintText: 'Postal Code',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  savedAddresses[label]?['address'] = value;
                },
                decoration: InputDecoration(
                  hintText: 'Building/Street/etc',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // Add spacing between address fields
      ],
    );
  }*/

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

