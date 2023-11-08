import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class AllCommentsView extends StatelessWidget {
  final List<dynamic> comments;

  const AllCommentsView({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: 'All Comments'),
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
        height: 700,
        width: double.infinity,
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            final userName = comment['userName'] as String;
            final firstLetter = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '';
            // Customize the comment UI as needed
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: AppColors.appColorAccent)),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.fontColorGray),
                          color: AppColors.fontColorWhite,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.fontColorDark,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(comment['userName']),
                            SizedBox(width: 10),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(comment['comment']),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
