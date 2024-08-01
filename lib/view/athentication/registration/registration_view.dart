import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/app_button.dart';
import '../../../common/app_password_field.dart';
import '../../../common/app_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../bootom_bar/bottom_bar_view.dart';
import '../../home/home_view.dart';
import '../../profile_view/widget/profile_image.dart';
import '../login/login_view.dart';

class RegistrationLoginScreen extends StatefulWidget {
  @override
  _RegistrationLoginScreenState createState() =>
      _RegistrationLoginScreenState();
}

class _RegistrationLoginScreenState extends State<RegistrationLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _userName = '';
  String _phoneNumber = '';
  String _profileImageURL = ''; // Firebase Storage එකට URL
  String _userRole = 'User';

  bool _isRegistering = false;
  Uint8List? _profileImage;

  void _registerUser() async {
    if (_password != _confirmPassword) {
      _showAlertDialog('Password Mismatch', 'Passwords do not match. Please try again.');
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      print('Attempting to register user...');
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      final User? user = userCredential.user;
      if (user != null) {
        print('User registered successfully: ${user.uid}');
        // Upload the profile image to Firebase Storage
        if (_profileImage != null) {
          final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
          final UploadTask uploadTask = storageRef.putData(_profileImage!);
          await uploadTask.whenComplete(() async {
            _profileImageURL = await storageRef.getDownloadURL();
            print('Profile image uploaded: $_profileImageURL');
          });
        }
        // Firebase Firestore එකට user data ඇතුලත් කරනවා
        await _firestore.collection('users').doc(user.uid).set({
          'userName': _userName,
          'email': _email,
          'phoneNumber': _phoneNumber,
          'profileImageURL': _profileImageURL,
          'userRole': _userRole,
        });

        _showAlertDialog('Registration Successful', 'User registration was successful.');
        _clearInputFields();
      } else {
        print('User registration failed: User is null');
      }
    } catch (e) {
      print('Error during registration: $e');
      _showAlertDialog('Registration Error', 'An error occurred during registration. Please try again.');
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBarView()),
                      (route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearInputFields() {
    setState(() {
      _email = '';
      _password = '';
      _confirmPassword = '';
      _userName = '';
      _phoneNumber = '';
      _profileImageURL = '';
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(26.0),
            child: Column(
              children: [
                SizedBox(height: 50,),
                Text('User Registration', style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.fontColorWhite,
                )),
                SizedBox(height: 20),
                ProfileImage(
                  title: 'Profile Image',
                  url: _profileImageURL,
                  onChanged: (imageData, extension) {
                    setState(() {
                      _profileImage = imageData;
                    });
                  },
                ),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                  hint: "User Name",
                ),
                SizedBox(height: 10),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  hint: "Email Address",
                ),
                SizedBox(height: 10),
                AppTextField(
                  onTextChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                  hint: "Phone Number",
                ),
                SizedBox(height: 10),
                AppPasswordField(
                  onTextChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  hint: "Password",
                ),
                SizedBox(height: 10),
                AppPasswordField(
                  onTextChanged: (value) {
                    setState(() {
                      _confirmPassword = value;
                    });
                  },
                  hint: "Confirm Password",
                ),
                SizedBox(height: 50),
                AppButton(
                  buttonText: 'Register',
                  onTapButton: _isRegistering ? null : _registerUser,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
