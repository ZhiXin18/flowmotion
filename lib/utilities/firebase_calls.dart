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

    // Check if there is an existing record of user
    QuerySnapshot querySnap = await usersCollection.where('userid', isEqualTo: currentUser.uid).get();

    if (querySnap.docs.isNotEmpty) {
      // Existing user, update the data including updated_on
      QueryDocumentSnapshot doc = querySnap.docs[0];
      await doc.reference.update({
        'addresses': addresses,
        'updated_on': currentTime,
      });
    } else {
      // New user, set created_on and updated_on, and add an empty routes array
      await usersCollection.add({
        'addresses': addresses,
        'created_on': currentTime,
        'routes': [], // Empty routes array
        'username': username,
        'userid': currentUser.uid,
        'updated_on': currentTime,
      });
    }
  }


  Future<List<CongestionRating>> getCongestionRatings() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection(
        'congestions').get();

    List<CongestionRating> congestionRatings = [];

    if (querySnap.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnap.docs) {
        final data = doc.data() as Map<String,
            dynamic>?; // Cast the data to a Map

        String docId = doc.id;
        // Print the data for debugging
        //print('Document ${doc.id} data: $data');

        if (data != null &&
            data.containsKey('camera') &&
            data['camera'] is Map &&
            data['camera'].containsKey('location') &&
            data['camera']['location'] is Map &&
            data['camera']['location'].containsKey('latitude') &&
            data['camera']['location'].containsKey(
                'longitude') && 
            data.containsKey('rating') &&
            data['rating'] is Map &&
            data['rating'].containsKey('value')) {
          double latitude = data['camera']['location']['latitude'];
          double longitude = data['camera']['location']['longitude'];
          double ratingValue = data['rating']['value'];
          String url = data['camera']['image_url'];

          //print("Marker latitude: $latitude, longitude: $longitude");

          CongestionRating congestionRating = CongestionRating(
            docId: docId,
            latitude: latitude,
            longitude: longitude,
            value: ratingValue,
            capturedOn: data['camera']['captured_on'], // Use 'data' instead of 'doc'
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
