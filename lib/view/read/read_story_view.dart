import 'package:book_home/view/read/widget/comment_sent_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_bar.dart';
import '../../common/app_button.dart';
import '../../utils/app_colors.dart';
import 'all_comments_view.dart';


class ReadStoryView extends StatefulWidget {
  final String chapterName;
  final String chapterStory;
  final String title;


  ReadStoryView({required this.chapterName, required this.chapterStory, required this.title});

  @override
  State<ReadStoryView> createState() => _ReadStoryViewState();
}

class _ReadStoryViewState extends State<ReadStoryView> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //late final SharedPreferences prefs;

  String? _userName; // To store the user's name

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore when the widget is initialized
    _fetchUserData();
  }

  // Function to fetch user data from Firestore
  void _fetchUserData() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot userData = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        setState(() {
          _userName = userData['userName']; // Assuming 'userName' is the field name in Firestore
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final commentController = TextEditingController();

  // Future<void> _showCommentSentDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Comment Sent'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Your comment has been sent successfully.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           AppButton(
  //             onTapButton: () {
  //               Navigator.of(context).pop();
  //             },
  //             buttonText: 'OK',
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  Future<void> _addCommentToChapter(String chapterName, String commentText) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('books');

    // Query the specific book that contains the target chapter
    final QuerySnapshot snapshot = await collection
        .where('title', isEqualTo: widget.title)  // Use the widget's title property
        .get();

    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (final doc in documents) {
      final data = doc.data() as Map<String, dynamic>;
      final chapters = data['chapters'] as List<dynamic>;

      for (int i = 0; i < chapters.length; i++) {
        final chapter = chapters[i];

        if (chapter['name'] == chapterName) {
          // Add the comment to the chapter's commentList
          final List<dynamic> commentList = chapter['commentList'] as List<dynamic>? ?? [];
          commentList.add({
            'userId': 'user_id_here', // Replace with the actual user ID
            'userName': _userName ?? 'Anonymous', // Use the fetched user name or 'Anonymous' as a default
            'comment': commentText,
          });

          // Update the chapter's data in Firestore
          chapter['commentList'] = commentList;

          await collection.doc(doc.id).update({
            'chapters': chapters,
          });

          // Clear the comment text field
          commentController.clear();
          // _showCommentSentDialog();
          break; // Exit the loop after updating
        }
      }
    }
  }


  // Future<void> _viewAllComments() async {
  //   final firestore = FirebaseFirestore.instance;
  //   final collection = firestore.collection('books');
  //
  //   final QuerySnapshot snapshot = await collection.get();
  //   final List<QueryDocumentSnapshot> documents = snapshot.docs;
  //
  //   for (final doc in documents) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     final chapters = data['chapters'] as List<dynamic>;
  //
  //     for (final chapter in chapters) {
  //       if (chapter['name'] == widget.chapterName) {
  //         final List<dynamic> comments = chapter['commentList'] as List<dynamic>? ?? [];
  //
  //         // Navigate to AllCommentsView and pass the comments as arguments
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => AllCommentsView(comments: comments),
  //           ),
  //         );
  //         break; // Exit the loop after finding the chapter
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BookAppBar(
            onBackPressed: () {
              Navigator.pop(context);
            },
            title: 'Read Story'),
        body: Container(
          height: 800,
          width: double.infinity,
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
            child: Column(children: [
              SizedBox(height: 20),
              Text(widget.chapterName,style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.fontColorWhite)),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  child: Text(widget.chapterStory,style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.fontColorWhite)),
                ),
              ),

              CommentsSentComponent(
                controller: commentController,
                onTap: () async {
                  final commentText = commentController.text.trim();
                  if (commentText.isNotEmpty) {
                    await _addCommentToChapter(widget.chapterName, commentText);
                  }
                },
              ),
              InkResponse(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCommentsView(
                            title: widget.title,
                            chapterName: widget.chapterName),
                      ),
                    );
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: 20.0),
                    child: Text('Read all comments',style: TextStyle(color: AppColors.primaryBackgroundColor,),),
                  ))
            ]),
          ),
        ),
      );
  }
}
