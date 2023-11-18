import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: 'Privacy Policy'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // Start from the bottom-left corner
            end: Alignment.centerRight,     // End at the top-right corner
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
              AppColors.colorPrimary.withOpacity(0.8),   // Color from the bottom-left side (green)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _heading('Data Collection'),
                _body(
                    'We only collect your mobile number when you use the 5 Wasara Jayamaga app. This information is required to provide you with personalized educational content and to track your progress.'),
                _heading('Why we collect data'),
                _body(
                    'We collect your mobile number to personalize your educational experience and provide you with relevant educational content. We use this information to track your progress and provide you with feedback on your performance.'),
                _heading('Data Protection'),
                _body(
                    'We are committed to ensuring the safety and security of your data. We use industry-standard encryption methods and secure storage techniques to protect your mobile number from unauthorized access, disclosure, or alteration.'),
                _heading('Third-Party Services'),
                _body(
                    'We do not use any third-party services to collect or store your mobile number.'),
                _heading('Updates to this Privacy Policy'),
                _body(
                    'We may update this Privacy Policy from time to time to reflect changes in the app’s functionality or legal requirements. We will notify you of any significant changes to this policy via email or through the app.\n\nIf you have any questions or concerns about this Privacy Policy, please contact us at info@jayamaga.lk.'),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _heading(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          text,
          style: TextStyle(
              color: AppColors.fontColorDark,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _body(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
          color: AppColors.fontColorDark,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
  }
}
