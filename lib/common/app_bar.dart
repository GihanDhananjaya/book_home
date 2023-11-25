
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class BookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? goBackEnabled;
  final VoidCallback? onBackPressed;

  BookAppBar(
      {this.title = '',
        this.actions,
        this.goBackEnabled = true,
        this.onBackPressed})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super();

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: AppColors.fontColorWhite),
      ),
      backgroundColor:AppColors.containerBackgroundColor,
      elevation: 0,
      actions: actions,
      centerTitle: true,
      leading: goBackEnabled!
          ? InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: AppColors.fontColorWhite,
          ))
          : const SizedBox.shrink(),
    );
  }
}
