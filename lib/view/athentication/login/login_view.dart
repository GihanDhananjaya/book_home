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
      _isLogging = true;
    });
    try {
      final UserCredential userCredential = await
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      //String userRole = widget.prefs!.getString('userRole') ?? 'User';

      if (user != null) {
        setState(() {});

        widget.prefs!.setBool('userLoggedIn', true);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomBarView(user:user)),
        );
      }
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

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
        _isLogging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerBackgroundColor,
      body: Container(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
            child: Column(
              children: [

                SizedBox(height: 50),
                Text('BOOK HOME',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: AppColors.fontColorWhite)),
                SizedBox(height: 50),
                Text('Login',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: AppColors.fontColorWhite)),

                SizedBox(height: 50),
                AppTextField(
                    onTextChanged: (value){
                      setState(() {
                        email = value;
                      });
                    },
                    hint: 'Email Address',controller: _emailAddressController),

                SizedBox(height: 20,),
                AppPasswordField(
                  hint: "Password",
                  onTextChanged: (value1) {
                      setState(() {
                        password = value1;
                      });
                  },
                ),

                SizedBox(height: 50),
                _isLogging
                    ? CircularProgressIndicator()
                    : AppButton(
                  buttonText: 'Login',
                  onTapButton: loginUser,
                ),

                SizedBox(height: 150),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(AppColors.textBackgroundColor) ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationLoginScreen(),
                      ),
                    );
                  },
                  child: Text('Create New Account',style: TextStyle(color: AppColors.fontColorWhite)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
