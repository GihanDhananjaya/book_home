import 'dart:typed_data';
import 'package:book_home/view/profile_view/widget/profile_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/app_button.dart';
import '../../common/app_password_field.dart';
import '../../common/app_text_field.dart';
import '../../common/image_upload_widget.dart';
import '../../utils/app_colors.dart';

class UpdateProfileView extends StatefulWidget {
  get prefs => null;

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Uint8List? profileImage;
  bool isUpdated = false;
  String? userName;
  String? fileExtension;
  String? imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Fetch user data when entering the ProfileView
    _fetchUserData();

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
          userName = userData['userName'] ?? '';
          fullNameController.text = userData['userName'] ?? '';
          emailController.text = user.email ?? '';
          phoneNumberController.text = userData['phoneNumber'] ?? '';
          imageUrl = userData['profileImageURL'] ?? '';
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
          'userName': fullNameController.text,
          'phoneNumber': phoneNumberController.text,
        });

        // If the password fields are not empty, update the password
        if (newPasswordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
          await user.updatePassword(newPasswordController.text);
        }
        if (profileImage != null) {
          final storage = FirebaseStorage.instance;
          final ref = storage.ref().child('profile_images/${widget.prefs}.$fileExtension');
          await ref.putData(profileImage!);
          imageUrl = await ref.getDownloadURL();
          await _firestore.collection('users').doc(user.uid).update({
            'profileImageURL': imageUrl,
          });
        }
        setState(() {
          isUpdated = true;
        });
      }
    } catch (error) {
      print('Error updating user profile: $error');
    }
  }

  // Callback function to update the profile image data
  // Callback function to update the profile image data
  void updateProfileImage(Uint8List newProfileImage) {
    setState(() {
      profileImage = newProfileImage;
      // Handle the update of the profile image in Firestore
      // You need to upload the new image to a storage service and get the URL
      // Update the 'profileImageURL' field in the Firestore document
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstLetter = userName?.isNotEmpty ?? false ? userName!.substring(0, 1).toUpperCase() : 'A';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.containerBackgroundColor,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.fontColorWhite),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     AppColors.fontColorWhite.withOpacity(0.5),
          //     AppColors.colorPrimary.withOpacity(0.8),
          //   ],
          // ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileImage(title: '',onChanged: (Ubytes, extension) async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    final extension = pickedFile.path.split('.').last;

                    setState(() {
                      profileImage = bytes;
                      fileExtension = extension;
                    });
                  }
                }),
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
