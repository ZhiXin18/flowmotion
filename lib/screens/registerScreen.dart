import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/savedPlaceScreen.dart';
import '../core/widget_keys.dart';
import 'package:flowmotion/globals.dart' as globals;

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = false;
  String _userEmail = '';
  String _username = '';

  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());


  // Validation method
  bool _validateInputs() {
    if (_usernameController.text.isEmpty) {
      _showErrorDialog('Please enter your name.');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email.');
      return false;
    }

    final email = _emailController.text;
    if (!_isValidEmail(email)) {
      _showErrorDialog('Please enter a valid email address.');
      return false;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return false;
    }

    final password = _passwordController.text;
    final passwordRegex = RegExp(r'^(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{5,12}$');
    if (!passwordRegex.hasMatch(password)) {
      _showErrorDialog('Password must be 5-12 characters and include at least one special character.');
      return false;
    }

    return true; // All validations passed
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _register() async {
    EmailOTP.config(
      appName: 'Flowmotion',
      otpType: OTPType.numeric, //OTP will consist only of numbers
      expiry : 90000, //OTP expiry time in milliseconds
      emailTheme: EmailTheme.v6, //Defines the theme for the OTP email.
      otpLength: 6, //length of the OTP
    );

    if (!_validateInputs()) {
      return;
    }

    String email = _emailController.text;

    try {
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        _showErrorDialog('Failed to register. Please try again.');
        return;
      }

      // Proceed with registration
      final User? user = (
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: _passwordController.text,
          )
      ).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!; // Initialize _userEmail
          _username = _usernameController.text;
        });

        //actual mode
        if (globals.testingActive == false){
          await EmailOTP.sendOTP(email: _emailController.text); //send otp to input email
          _showVerificationModal(user.uid, _username, _userEmail); //show the modal to enter otp
        } else {
          //test mode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavedPlaceScreen(
                userId: _auth.currentUser!.uid,
                username: _username,
                userEmail: _userEmail,
              ),
            ),
        );
        }
      } else {
        _showErrorDialog('Failed to register. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      // Catch Firebase specific authentication errors
      if (e.code == 'email-already-in-use') {
        _showErrorDialog('Failed to register. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred.');
    }
  }

  void _showVerificationModal(String userId, String username, String userEmail) {
    showDialog(
      context: context,
      barrierDismissible: false,  // User cannot dismiss it by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding: EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the 6-digit OTP sent to your email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _buildOTPField(index);
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                key: WidgetKeys.confirmationButton,
                onPressed: () => _verifyOTP(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        key: Key('otp_$index'),
        controller: _otpControllers[index],
        focusNode: _focusNodes[index], // Assign focus node
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus(); // Move to the next field
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus(); // Move to the previous field
          }

          if (index == 5) {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  Future<void> _verifyOTP() async {
    final otpCode = _otpControllers.map((controller) => controller.text).join();

    if (otpCode.length == 6) {
      print('OTP entered: $otpCode');  // Log the OTP entered

      await _auth.currentUser?.reload();

      // Call the EmailOTP.verifyOTP function with the entered OTP
      var isVerified = await EmailOTP.verifyOTP(otp: otpCode);

      print('OTP verification result: $isVerified');  // Log the verification result

      if (isVerified) {
        Navigator.of(context).pop(); // Close modal on success
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SavedPlaceScreen(
              userId: _auth.currentUser!.uid,
              username: _username,
              userEmail: _userEmail,
            ),
          ),
        );
      } else {
        _showErrorDialog('OTP verification failed. Please try again.');
        Navigator.of(context).pop(); // Close the modal after the error dialog is dismissed
        _clearOTPFields(); // Clear the input fields
        _auth.currentUser?.delete(); // Optionally delete user if verification fails
      }
    } else {
      _showErrorDialog('Please enter the complete 6-digit OTP.');
      _clearOTPFields(); // Clear the input fields

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
  // Method to clear all OTP input fields
  void _clearOTPFields() {
    for (var controller in _otpControllers) {
      controller.clear(); // Clear each controller
    }

    // Optionally, focus the first field again
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.registerScreen,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            _auth.currentUser?.delete();
          }
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        key: WidgetKeys.dismissKeyboard,
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '01.',
                    style: TextStyle(
                      color: Color(0xFFD4543C),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Hello! Nice to meet you.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  key: WidgetKeys.registerNameController,
                  controller: _usernameController,
                  hintText: 'Your Name',
                ),
                SizedBox(height: 20),
                _buildTextField(
                  key: WidgetKeys.registerEmailController,
                  controller: _emailController,
                  hintText: 'Your Email',
                ),
                SizedBox(height: 20),
                _buildTextField(
                  key: WidgetKeys.registerPasswordController,
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    key: WidgetKeys.registerButton,
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      key: key,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );
  }
}
