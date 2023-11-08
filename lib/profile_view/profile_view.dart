import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/app_bar.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';
import '../common/image_upload_widget.dart';
import '../utils/app_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Uint8List? profileImage;
  String? fileExtension;
  bool isUpdated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.colorPrimary,
          title: Text('Book Management',style: TextStyle(color: AppColors.fontColorWhite),)
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.centerLeft, // Start from the bottom-left corner
          end: Alignment.centerRight,     // End at the top-right corner
          colors: [
            AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
            AppColors.colorPrimary.withOpacity(0.5),   // Color from the bottom-left side (green)
          ],
        ),),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              ProfileImageUi(title: '',),
              SizedBox(height: 20),
              AppTextField(hint: 'Name',controller: fullNameController),
              SizedBox(height: 20),
              AppTextField(hint: 'Email',controller: emailController),
              SizedBox(height: 20),
              AppTextField(hint: 'Phone Number',controller: phoneNumberController),
              SizedBox(height: 20),

              SizedBox(height: 70),
              AppButton(buttonText: 'Update Profile',
                onTapButton: (){

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
