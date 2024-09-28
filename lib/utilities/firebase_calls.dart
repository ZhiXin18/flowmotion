import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

