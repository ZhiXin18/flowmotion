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

    // Check if there is an existing record of user
    QuerySnapshot querySnap = await usersCollection.where('userid', isEqualTo: currentUser.uid).get();

    if (querySnap.docs.isNotEmpty) {
      // Existing user
      QueryDocumentSnapshot doc = querySnap.docs[0];
      await doc.reference.update({
        'addresses': addresses,
      });
    } else {
      // New user
      await usersCollection.add({
        'addresses': addresses,
        'username': username,
        'userid': currentUser.uid,
      });
    }
  }

  Future<List<CongestionRating>> getCongestionRatings() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('congestions').get();

    List<CongestionRating> congestionRatings = [];

    if (querySnap.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>?; // Cast the data to a Map

        // Print the data for debugging
        print('Document ${doc.id} data: $data');

        if (data != null &&
            data.containsKey('camera') &&
            data['camera'] is Map &&
            data['camera'].containsKey('location') &&
            data['camera']['location'] is Map &&
            data['camera']['location'].containsKey('latitude') &&
            data['camera']['location'].containsKey('longtitude') && // Corrected spelling
            data.containsKey('rating') &&
            data['rating'] is Map &&
            data['rating'].containsKey('value')) {

          // Corrected spelling of longitude
          double latitude = data['camera']['location']['latitude'];
          double longitude = data['camera']['location']['longtitude']; // Ensure this spelling is consistent
          double ratingValue = data['rating']['value'];

          print("Marker latitude: $latitude, longitude: $longitude");

          CongestionRating congestionRating = CongestionRating(
            latitude: latitude,
            longitude: longitude,
            value: ratingValue,
            capturedOn: data['camera']['captured_on'], // Use 'data' instead of 'doc'
          );

          congestionRatings.add(congestionRating);
        } else {
          print('Document ${doc.id} is missing required fields');
        }
      }
    }

    return congestionRatings;
  }

}