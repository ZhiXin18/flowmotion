import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/congestion_rating.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference usersCollection =
FirebaseFirestore.instance.collection('users');
CollectionReference congestionCollection =
FirebaseFirestore.instance.collection('congestions');
bool newUser = true;

class FirebaseCalls {
  Future<void> updateUser(String username, List<Map<String, dynamic>> addresses) async {
    // Fetch the currently authenticated user
    User? currentUser = auth.currentUser;

    // Ensure that the user is logged in
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    // Get the current date and time for created_on and updated_on
    String currentTime = DateTime.now().toUtc().toIso8601String();

    // Check if there is an existing record of the user
    QuerySnapshot querySnap = await usersCollection.where('userid', isEqualTo: currentUser.uid).get();

    if (querySnap.docs.isNotEmpty) {
      // Existing user, update the data including updated_on
      QueryDocumentSnapshot doc = querySnap.docs[0];

      // Update addresses with coordinates
      await doc.reference.update({
        'addresses': addresses.map((address) {
          return {
            'address': address['address'], // Actual address string
            'city': address['city'] ?? '', // City
            'countryCode': address['countryCode'] ?? '', // Country code
            'deleted': address['deleted'] ?? false, // Deleted flag
            'label': address['label'], // Label for the address
            'postalCode': address['postalCode'], // Postal code
            'state': address['state'] ?? '', // State
            // Include coordinates if available
            'latitude': address['latitude'] ?? 0.0, // Default to 0.0 if not provided
            'longitude': address['longitude'] ?? 0.0, // Default to 0.0 if not provided
          };
        }).toList(),
        'updated_on': currentTime,
      });
    } else {
      // New user, set created_on and updated_on, and add an empty routes array
      await usersCollection.add({
        'addresses': addresses.map((address) {
          return {
            'address': address['address'], // Actual address string
            'city': address['city'] ?? '', // City
            'countryCode': address['countryCode'] ?? '', // Country code
            'deleted': address['deleted'] ?? false, // Deleted flag
            'label': address['label'], // Label for the address
            'postalCode': address['postalCode'], // Postal code
            'state': address['state'] ?? '', // State
            // Include coordinates if available
            'latitude': address['latitude'] ?? 0.0, // Default to 0.0 if not provided
            'longitude': address['longitude'] ?? 0.0, // Default to 0.0 if not provided
          };
        }).toList(),
        'created_on': currentTime,
        'routes': [], // Empty routes array
        'username': username,
        'userid': currentUser.uid,
        'updated_on': currentTime,
      });
    }
  }


  Future<Map<String, dynamic>?> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('users')
        .where('userid', isEqualTo: currentUser.uid)
        .get();
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

  Future<List<CongestionRating>> getCongestionRatings() async {
    QuerySnapshot querySnap = await congestionCollection
        .orderBy('camera.captured_on', descending: true)
        .limit(90)
        .get();

    List<CongestionRating> congestionRatings = [];

    if (querySnap.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        //print(data);

        if (data.containsKey('camera') &&
            data['camera'] is Map &&
            data['camera'].containsKey('location') &&
            data['camera']['location'] is Map &&
            data['camera']['location'].containsKey('latitude') &&
            data['camera']['location'].containsKey('longitude') &&
            data.containsKey('rating') &&
            data['rating'] is Map &&
            data['rating'].containsKey('value')) {

          double latitude = data['camera']['location']['latitude'];
          double longitude = data['camera']['location']['longitude'];
          double ratingValue = data['rating']['value'];
          String url = data['camera']['image_url'];

          CongestionRating congestionRating = CongestionRating(
            docId: doc.id,
            latitude: latitude,
            longitude: longitude,
            value: ratingValue,
            capturedOn: data['camera']['captured_on'],
            imageUrl: url,
          );

          congestionRatings.add(congestionRating);
        } else {
          print('Document ${doc.id} is missing required fields');
        }
      }
    }
    return congestionRatings;
  }

  Future<List<CongestionRating>> getCongestionRatingsForPlace(String savedPlaceLabel) async {
    QuerySnapshot querySnap = await congestionCollection
        .where('place_label', isEqualTo: savedPlaceLabel) // Assuming there's a place_label field
        .get();

    List<CongestionRating> congestionRatings = [];

    if (querySnap.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        String docId = doc.id;

        if (data != null &&
            data.containsKey('camera') &&
            data['camera'] is Map &&
            data['camera'].containsKey('location') &&
            data['camera']['location'] is Map &&
            data['camera']['location'].containsKey('latitude') &&
            data['camera']['location'].containsKey('longitude') &&
            data.containsKey('rating') &&
            data['rating'] is Map &&
            data['rating'].containsKey('value')) {

          double latitude = data['camera']['location']['latitude'];
          double longitude = data['camera']['location']['longitude'];
          double ratingValue = data['rating']['value'];
          String url = data['camera']['image_url'];

          CongestionRating congestionRating = CongestionRating(
            docId: docId,
            latitude: latitude,
            longitude: longitude,
            value: ratingValue,
            capturedOn: data['camera']['captured_on'],
            imageUrl: url,
          );

          congestionRatings.add(congestionRating);
        }
      }
    }
    return congestionRatings;
  }
}
