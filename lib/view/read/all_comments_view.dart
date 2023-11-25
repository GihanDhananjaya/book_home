import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class AllCommentsView extends StatefulWidget {
  final String title;
  final String chapterName;

  AllCommentsView({required this.title, required this.chapterName});
  @override
  State<AllCommentsView> createState() => _AllCommentsViewState();
}


class _AllCommentsViewState extends State<AllCommentsView> {
   List<dynamic>? comments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('books');

    final QuerySnapshot snapshot = await collection
        .where('title', isEqualTo: widget.title)
        .get();

    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (final doc in documents) {
      final data = doc.data() as Map<String, dynamic>;
      final chapters = data['chapters'] as List<dynamic>;

      for (final chapter in chapters) {
        if (chapter['name'] == widget.chapterName) {
          setState(() {
            comments = chapter['commentList'] as List<dynamic>? ?? [];
          });
          break; // Exit the loop after finding the chapter
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: 'All Comments'),
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
        height: double.infinity,
        width: double.infinity,
        child:comments != null && comments!.isNotEmpty ? ListView.builder(
          itemCount: comments!.length,
          itemBuilder: (context, index) {
            final comment = comments![index];
            final userName = comment['userName'] as String;
            final firstLetter = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : '';
            // Customize the comment UI as needed
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color:  AppColors.textBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fontBackgroundColor)),
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
                            Text(comment['userName'],style: TextStyle(color: AppColors.fontColorWhite)),
                            SizedBox(width: 10),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                            Icon(Icons.star,color: Colors.amber),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(comment['comment'],style: TextStyle(color: AppColors.fontColorWhite)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ):Center(child: Text("No Comments")),
      ),
    );
  }
}
