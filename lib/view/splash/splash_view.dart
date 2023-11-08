import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../athentication/login/login_view.dart';
import '../book_list/book_list_view.dart';
import '../bootom_bar/bottom_bar_view.dart';

class SplashView extends StatefulWidget {

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
   late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(prefs: prefs,),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Start from the bottom-left corner
            end: Alignment.centerRight,     // End at the top-right corner
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
              AppColors.colorPrimary.withOpacity(0.5),   // Color from the bottom-left side (green)
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(540),
                child: Image.asset(
                  fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    AppImages.appLogo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
