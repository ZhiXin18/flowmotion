import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import '../utilities/firebase_calls.dart'; // Import the FirebaseCalls class
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../utilities/location_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SavedPlaceScreen(userId: '', username: '', userEmail: '',));
}

class SavedPlaceScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String userEmail;

  const SavedPlaceScreen({Key? key, required this.userId, required this.username, required this.userEmail}) : super(key: key);

  @override
  _SavedPlaceScreenState createState() => _SavedPlaceScreenState();
}

class _SavedPlaceScreenState extends State<SavedPlaceScreen> {
  List<String> addressLabels = ['Home', 'Work'];
  bool _termsAccepted = false;
  bool _notificationsAllowed = false;
  List<Map<String, dynamic>> savedAddresses = [
    {'label': '','postalCode': '', 'address': '', 'city': '', 'state': '', 'countryCode': '', 'deleted': false},
    {'label': '','postalCode': '', 'address': '', 'city': '', 'state': '', 'countryCode': '', 'deleted': false}
  ]; // Initialize with matching number of items

  void _addAddress() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          key: WidgetKeys.addMoreDialog,
          title: Text('Enter Address Name'),
          content: TextField(
            key: WidgetKeys.addressNameTextField,
            controller: nameController,
            decoration: InputDecoration(hintText: 'Enter new address name'),
          ),
          actions: [
            TextButton(
              key: WidgetKeys.addMoreCancelButton,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              key: WidgetKeys.addButton,
              onPressed: () {
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
        savedAddresses.add({
          'label': '',
          'postalCode': '',
          'address': '',
          'city': '',
          'state': '',
          'countryCode': '',
          'deleted': false
        }); // Add corresponding address entry
      });
    }
  }

  void _saveUserData() async {
    // Check that both Home and Work addresses are filled
    if (savedAddresses[0]['postalCode']!.isEmpty || savedAddresses[0]['address']!.isEmpty) {
      if (mounted) _showErrorDialog('Please fill in the Home address.');
      return;
    }

    if (savedAddresses[1]['postalCode']!.isEmpty || savedAddresses[1]['address']!.isEmpty) {
      if (mounted) _showErrorDialog('Please fill in the Work address.');
      return;
    }

    if (!_termsAccepted || !_notificationsAllowed) {
      if (mounted) _showErrorDialog('Please accept the terms and conditions and allow notifications.');
      return;
    }

    bool allFieldsFilled = savedAddresses.every(
          (address) => address['postalCode']!.isNotEmpty && address['address']!.isNotEmpty,
    );

    if (!allFieldsFilled) {
      if (mounted) _showErrorDialog('Please fill in all address fields.');
      return;
    }

    // Combine address data with labels
    List<Map<String, dynamic>> addressesWithLabels = List.generate(savedAddresses.length, (index) {
      return {
        'label': addressLabels[index],
        ...savedAddresses[index],
      };
    });

    try {
      FirebaseCalls firebaseCalls = FirebaseCalls();
      await firebaseCalls.updateUser(widget.username, addressesWithLabels); // Use the new list with labels
      if (mounted) {
        //await sendEmailVerification();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: WidgetKeys.registerErrorDialog,
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            key: WidgetKeys.registerErrorOK,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField(int index, String label) {
    // Ensure that the index exists in savedAddresses
    if (index >= savedAddresses.length) {
      return SizedBox.shrink(); // Return an empty widget if the index is out of bounds
    }

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
                key: WidgetKeys.addressPostalCodeField(index),
                onChanged: (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['postalCode'] = value;
                    });
                  }
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
                key: WidgetKeys.addressField(index),
                onChanged: (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['address'] = value;
                    });
                  }
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
        SizedBox(height: 20),
      ],
    );
  }
  late LocationService locationService;

  @override
  void initState() {
    super.initState();
    locationService = LocationService(context); // Initialize with context
  }

  void _getCurrentLocation() async {
    await locationService.getCurrentPosition();
    if (locationService.currentPosition != null) {
      print('Location obtained: Latitude - ${locationService.currentPosition!.latitude}, '
          'Longitude - ${locationService.currentPosition!.longitude}');
    }
  }

  /*Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }*/

  /*Future<void> sendEmailVerification() async {
    try{
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: WidgetKeys.dismissKeyboard,
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        key: WidgetKeys.savedPlaceScreen,
        appBar: AppBar(
          leading: IconButton(
              key: WidgetKeys.savedPlaceScreenBackButton,
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
              {
                _auth.currentUser?.delete(),
                Navigator.pop(context),
              }
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
                      Text('Register your saved places', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 20),
                      ...List.generate(addressLabels.length, (index) => _buildAddressField(index, addressLabels[index])),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          key: WidgetKeys.addMoreButton,
                          onPressed: _addAddress,
                          child: Text('Add More', style: TextStyle(color: Colors.white, fontSize: 14)),
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
                            // Call _getCurrentPosition if the checkbox is enabled
                            if (_termsAccepted) {
                              _getCurrentLocation();
                            }
                          });
                        },
                        key: WidgetKeys.termsCheckbox,
                      ),
                      _buildCheckbox(
                        'Allow notifications from FlowMotion',
                        _notificationsAllowed,
                            (bool? value) {
                          setState(() {
                            _notificationsAllowed = value ?? false;
                          });
                        },
                        key: WidgetKeys.notificationsCheckbox,
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          key: WidgetKeys.getStartedButton,
                          onPressed: _saveUserData,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            backgroundColor: Color(0xFFD4543C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Let\'s get started!', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged, {Key? key}) {
    return Row(
      children: [
        Checkbox(
          key: key, // Assign the key to the checkbox
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
