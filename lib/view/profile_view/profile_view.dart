import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/app_button.dart';
import '../../common/app_password_field.dart';
import '../../common/app_text_field.dart';
import '../../common/image_upload_widget.dart';
import '../../utils/app_colors.dart';

class ProfileView extends StatefulWidget {
  get prefs => null;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Uint8List? profileImage;
  bool isUpdated = false;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Fetch user data when entering the ProfileView
    setState(() {
      _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {

      });
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch additional user data from Firestore
        DocumentSnapshot userData =
        await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          // Set the text fields with user details
          fullNameController.text = userData['fullName'] ?? '';
          emailController.text = user.email ?? '';
          phoneNumberController.text = userData['phoneNumber'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }


  Future<void> _updateUserProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': fullNameController.text,
          'phoneNumber': phoneNumberController.text,
        });

        // If the password fields are not empty, update the password
        if (newPasswordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
          await user.updatePassword(newPasswordController.text);
        }

        setState(() {
          isUpdated = true;
        });
      }
    } catch (error) {
      print('Error updating user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.fontColorWhite),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),
              AppColors.colorPrimary.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileImageUi(title: ''),
                AppTextField(hint: 'Name', controller: fullNameController),
                SizedBox(height: 20),
                AppTextField(hint: 'Email', controller: emailController),
                SizedBox(height: 20),
                AppTextField(hint: 'Phone Number', controller: phoneNumberController),
                SizedBox(height: 20),
                AppPasswordField(hint: 'New Password', controller: newPasswordController),
                SizedBox(height: 20),
                AppPasswordField(hint: 'Confirm Password', controller: confirmPasswordController),
                SizedBox(height: 20),
                AppButton(
                  buttonText: 'Update Profile',
                  onTapButton: _updateUserProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
