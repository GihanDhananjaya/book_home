import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AnotherPage extends StatelessWidget {
  final String title;
  final String chapterName;
  final String chapterStory;

  AnotherPage({
    required this.title,
    required this.chapterName,
    required this.chapterStory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: AppColors.colorPrimary,
          title: Text('Read Story',style: TextStyle(color: AppColors.fontColorWhite),)
      ),
      body: Container(
        width: double.infinity,
        height: 900,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),
              AppColors.colorPrimary.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title: $title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Chapter Name: $chapterName', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Chapter Story: $chapterStory', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
