
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/app_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class CommentsSentComponent extends StatelessWidget {

  TextEditingController? controller;
  VoidCallback onTap;


  CommentsSentComponent({this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 80,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.fontColorGray),
                  color: AppColors.fontColorWhite,
                  borderRadius: BorderRadius.circular(40)),
              child: Image.asset(AppImages.appProfileImg,height:355,width: 355),
            ),

            SizedBox(width: 10,),

            Container(
              width: 270,
              height: 70,
              child: AppTextField(
                controller: controller,
                hint: 'Post a comment',
                action: Padding(
                  padding: EdgeInsets.all(8.0),

                  child: InkResponse(
                      onTap: onTap,
                      child: Image.asset(AppImages.appSentImg,width: 5,height: 5,color: AppColors.textBackgroundColor)),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
