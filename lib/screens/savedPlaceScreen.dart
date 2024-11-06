import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import '../utilities/firebase_calls.dart'; // Import the FirebaseCalls class
import 'package:flowmotion/globals.dart' as globals;

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
    {'label': 'Home','postalCode': '', 'address': '', 'city': '', 'state': '', 'countryCode': '', 'deleted': false},
    {'label': 'Work','postalCode': '', 'address': '', 'city': '', 'state': '', 'countryCode': '', 'deleted': false}
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
          'label': newName,
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
    print(savedAddresses);
    // Validate postal codes and fetch coordinates for each address
    for (var address in savedAddresses) {
      final postalCode = address['postalCode']!;
      Map<String, double?> coordinates = await _validateAndFetchCoordinates(postalCode);

      // Check if coordinates were retrieved; if not, stop the process
      if (coordinates['latitude'] == null || coordinates['longitude'] == null) {
        if (mounted) _showErrorDialog('Invalid address. Please check and try again.');
        return;
      }

      // Save the coordinates in the address map
      address['latitude'] = coordinates['latitude'];
      address['longitude'] = coordinates['longitude'];
    }

    // Combine address data with labels
    List<Map<String, dynamic>> addressesWithLabels = List.generate(savedAddresses.length, (index) {
      return {
        'label': addressLabels[index],
        ...savedAddresses[index],
      };
    });

    print('_termsAccepted: $_termsAccepted, _notificationsAllowed: $_notificationsAllowed');
    // Check if terms and conditions are accepted and notifications allowed
    if (!_termsAccepted || !_notificationsAllowed) {
      if (mounted) _showErrorDialog('Please accept the terms and conditions and allow notifications.');
      return;
    }

    print("Saved Addresses: $savedAddresses");
    // Check if all address fields are filled
    bool allFieldsFilled = savedAddresses.every(
          (address) => address['postalCode']!.isNotEmpty && address['address']!.isNotEmpty,
    );

    print(!allFieldsFilled);
    if (allFieldsFilled == false) {
      if (mounted) _showErrorDialog('Please fill in all address fields.');
      return;
    }

    // Save data to Firebase
    try {
      FirebaseCalls firebaseCalls = FirebaseCalls();
      await firebaseCalls.updateUser(widget.username, addressesWithLabels); // Use the new list with labels
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString());
    }
  }

  Future<Map<String, double?>> _validateAndFetchCoordinates(String postalCode) async {
    if (postalCode.isNotEmpty) {
      try {
        final geocodeApi = FlowmotionApi().getGeocodingApi();
        final response = await geocodeApi.geocodePostcodeGet(postcode: postalCode.toString());
        print("Latitude: ${response.data?.latitude}, Longitude: ${response.data?.longitude}");

        if (response.statusCode == 200 && response.data != null) {
          return {
            'latitude': response.data?.latitude,
            'longitude': response.data?.longitude,
          };
        }
      } catch (e) {
        print('Error calling Geocoding API: $e');
      }
    }

    return {'latitude': null, 'longitude': null};
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
                onSubmitted: (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['postalCode'] = value;
                    });
                  }
                },
                onChanged: globals.testingActive
                    ? (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['postalCode'] = value;
                    });
                  }
                }
                    : null,


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
                onSubmitted: (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['address'] = value;
                    });
                  }
                },
                onChanged: globals.testingActive
                    ? (value) {
                  if (index < savedAddresses.length) {
                    setState(() {
                      savedAddresses[index]['address'] = value;
                    });
                  }
                }
                    : null,
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

  @override
  void initState() {
    super.initState();
  }


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
