import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/book_list_entity.dart';
import '../../../entity/user_entity.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class UserComponent extends StatelessWidget {
  final UserEntity userEntityList;
  final VoidCallback onFollow;
  String? text;
  String? image;
  Color? buttonColor;

  UserComponent({required this.userEntityList, required this.onFollow,this.text,this.image,this.buttonColor});

  @override
  Widget build(BuildContext context) {
    bool? isFollowing = userEntityList.followed;
    final firstLetter = userEntityList.userName?.isNotEmpty ?? false ? userEntityList.userName!.substring(0, 1).toUpperCase() : 'A';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(color: AppColors.textBackgroundColor,
            border: Border.all(color: AppColors.fontBackgroundColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.fontColorGray),
                      color: AppColors.fontColorWhite,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: userEntityList.imageUrl != null && userEntityList.imageUrl!.isNotEmpty
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(userEntityList.imageUrl!),
                    )
                        : Center(
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: AppColors.fontColorDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(userEntityList.userName!,style: TextStyle(color: AppColors.fontColorWhite,fontSize: 18),),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: InkResponse(
                onTap: onFollow,
                child: Container(
                  height: 35,
                  width: 90,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                    children: [
                        Image.asset(image!,width: 15,height: 15,color: AppColors.fontColorWhite),
                        SizedBox(width: 5,),
                        Text(text!,
                            style: TextStyle(color: AppColors.fontColorWhite)),
                        ],
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
