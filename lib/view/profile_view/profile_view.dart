import 'dart:typed_data';
import 'package:book_home/view/profile_view/update_profile_view.dart';
import 'package:book_home/view/profile_view/widget/profile_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? userName;
  String? userEmail;
  String? userMobileNumber;
  String? imageUrl;
  int? follower;
  int? followedCount;

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

        // Fetch followers data
        QuerySnapshot followersSnapshot = await _firestore
            .collection('users')
            .where('followers', arrayContains: user.uid)
            .get();

        // Fetch followedCount
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();


        setState(() {
          // Set the text fields with user details
          userName = userData['userName'] ?? '';
          userEmail = user.email ?? '';
          userMobileNumber = userData['phoneNumber'] ?? '';
          imageUrl = userData['profileImageURL'] ?? '';
          //follower = followersSnapshot.docs.length;
          follower = userDoc['followers']?.length  ?? 0;
          followedCount = userDoc['followedCount']?.length ?? 0;
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
    final firstLetter = userName?.isNotEmpty ?? false ? userName!.substring(0, 1).toUpperCase() : 'A';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.containerBackgroundColor,
        title: Text(
          'User Profile',
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
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.fontColorGray),
                        color: AppColors.fontColorWhite,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: imageUrl != null && imageUrl!.isNotEmpty
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl!),
                      )
                          : Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 44,
                            color: AppColors.fontColorDark,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(follower?.toString() ?? '0',style: TextStyle(color: AppColors.fontColorWhite,fontWeight: FontWeight.w500)),
                        Text('Followers',style: TextStyle(color: AppColors.fontColorWhite)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$followedCount',style: TextStyle(color: AppColors.fontColorWhite,fontWeight: FontWeight.w500)),
                        Text('Following',style: TextStyle(color: AppColors.fontColorWhite)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(userName ?? '',style: TextStyle(color: AppColors.fontColorWhite,fontSize: 22)),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    InkResponse(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UpdateProfileView()),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            color: AppColors.fontBackgroundColor,borderRadius: BorderRadius.circular(8)),
                        child: Row(
                         children: [
                           Icon(Icons.edit),
                           Text('Edit Profile',style: TextStyle(color: AppColors.fontColorWhite),)
                         ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.fontBackgroundColor,borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Icon(Icons.mail),
                          Text('Massanger',style: TextStyle(color: AppColors.fontColorWhite),)
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Icon(Icons.email_outlined,color: AppColors.fontColorWhite),
                    SizedBox(width: 10),
                    Text('email :',style: TextStyle(color: AppColors.fontColorWhite)),
                    SizedBox(width: 10),
                    Text(userEmail ?? '',style: TextStyle(color: AppColors.fontColorWhite))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.call,color: AppColors.fontColorWhite),
                    SizedBox(width: 10),
                    Text('mobile :',style: TextStyle(color: AppColors.fontColorWhite)),
                    SizedBox(width: 10),
                    Text(userMobileNumber ?? '',style: TextStyle(color: AppColors.fontColorWhite))
                  ],
                ),

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
