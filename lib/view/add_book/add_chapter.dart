import 'dart:convert';
import 'package:flutter/material.dart';
import '../../common/app_bar.dart';
import '../../common/app_text_field.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../notification_view/local_notification.dart';


class AddChapterView extends StatefulWidget {
  @override
  _AddChapterViewState createState() => _AddChapterViewState();
}

class _AddChapterViewState extends State<AddChapterView> {
  final TextEditingController _chapterNumberController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(title: 'Add Chapter'),
      body: Container(
        decoration: BoxDecoration(
            color: AppColors.containerBackgroundColor
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft, // Start from the bottom-left corner
          //   end: Alignment.centerRight,     // End at the top-right corner
          //   colors: [
          //     AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
          //     AppColors.colorPrimary.withOpacity(0.8),   // Color from the bottom-left side (green)
          //   ],
          // ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                AppTextField(
                  hint: "Chapter No",
                  controller: _chapterNumberController,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.fontBackgroundColor)),
                  height: 550,
                  width: double.infinity,
                  child: TextField(
                    cursorColor: AppColors.fontColorWhite,
                    style: TextStyle(color: AppColors.fontColorWhite),
                    controller: _storyController, // Use a TextField for story input
                    decoration: InputDecoration(
                      hintText: "Story",
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.textBackgroundColor),),
                  onPressed: () {
                    final chapterNumber = _chapterNumberController.text;
                    final story = _storyController.text;

                    if (chapterNumber.isNotEmpty && story.isNotEmpty) {
                      final newChapter = ChapterEntity(
                        name: chapterNumber,
                        story: story,
                      );

                      Navigator.of(context).pop(newChapter);
                    }
                  },
                  child: Text('Submit Chapter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
