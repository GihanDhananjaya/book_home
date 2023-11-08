import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';

class BottomBarItem extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final bool isHidden;
  final String name;
  final bool isSelected;

  BottomBarItem(
      {required this.icon,
        required this.onTap,
        this.isHidden = false,
        required this.name, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onTap();
            },
            child: Image.asset(
              icon,
              color: isSelected ? AppColors.colorPending:
              AppColors.fontColorWhite,
              width: 30,
              height: 30,
            ),
          ),
          SizedBox(height: 5),
          Text(name,style: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: AppColors.fontColorWhite,
          ))
        ],
      ),
    );
  }
}
