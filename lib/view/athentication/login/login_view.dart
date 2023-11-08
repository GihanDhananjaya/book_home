// Login screen UI
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/app_button.dart';
import '../../../common/app_password_field.dart';
import '../../../common/app_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../bootom_bar/bottom_bar_view.dart';
import '../../home/home_view.dart';
import '../registration/registration_view.dart';


class LoginScreen extends StatefulWidget {

  final SharedPreferences? prefs;

  LoginScreen({  this.prefs});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  final _emailAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogging = false; // Added a flag to track login state

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMessage),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              onTapButton: () {
                Navigator.of(context).pop();
              }, buttonText: 'Ok',
            ),
          ],
        );
      },
    );
  }


  Future<void> loginUser() async {
    setState(() {
      _isLogging = true; // Set the flag to true when logging in
    });
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        widget.prefs!.setBool('userLoggedIn', true);
        // Navigate to the home screen or another screen after login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarView()),
        );
      }
    } catch (e) {
      // Handle login errors
      String errorMessage = 'An error occurred. Please try again.';

      // You can check the specific error code to display custom messages
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email address.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password. Please try again.';
        }
      }

      _showErrorDialog(errorMessage);
    }finally {
      setState(() {
        _isLogging = false; // Set the flag to false when login process completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),
              AppColors.colorPrimary.withOpacity(0.5),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(26.0),
          child: Column(
            children: [

              SizedBox(height: 50),

              Text('Login',style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.fontColorDark)),


              AppTextField(
                  onTextChanged: (value){
                    setState(() {
                      email = value;
                    });
                  },
                  hint: 'Email Address',controller: _emailAddressController),

              // TextField(
              //   controller: _emailAddressController,
              //   onChanged: (value) {
              //     setState(() {
              //       email = value;
              //     });
              //   },
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              SizedBox(height: 20,),
              AppPasswordField(
                hint: "Password",
                onTextChanged: (value1) {
                    setState(() {
                      password = value1;
                    });
                },
              ),
              // TextField(
              //   onChanged: (value) {
              //     setState(() {
              //       password = value;
              //     });
              //   },
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'Password'),
              // ),
              SizedBox(height: 50),
              _isLogging
                  ? CircularProgressIndicator()
                  : AppButton(
                buttonText: 'Login',
                onTapButton: loginUser,
              ),
              // ElevatedButton(
              //   onPressed: loginUser,
              //   child: Text('Login'),
              // ),
              Spacer(),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationLoginScreen(),
                    ),
                  );
                },
                child: Text('Create New Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
