import 'package:flowmotion/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  //make sure native code is set up correctly, need initialise native app before initialising firebase
  WidgetsFlutterBinding.ensureInitialized(); //auto called inside runApp, but need do before runApp so need do this codes
  await Firebase.initializeApp( //start firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ForgetPasswordScreen());
}

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void passwordReset() async {
    try{
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Please check your email for the password reset link."),
          );
        },
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
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
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Enter your email for password reset link',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 5),
          //email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD4543C)),
                  ),
                  hintText: 'Email',
                ),
              )
            ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // Handle the "Reset Password" action
              passwordReset();
              _emailController.text = "";
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              backgroundColor: Color(0xFFD4543C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Reset Password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

}