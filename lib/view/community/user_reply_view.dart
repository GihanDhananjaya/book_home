import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../utils/app_colors.dart';

class UserReplyView extends StatefulWidget {
  final String commentId;

  const UserReplyView({Key? key, required this.commentId}) : super(key: key);

  @override
  State<UserReplyView> createState() => _UserReplyViewState();
}

class _UserReplyViewState extends State<UserReplyView> {
  final TextEditingController replyController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userName; // To store the user's name

  @override
  void initState() {
    setState(() {});
    super.initState();
    // Fetch user data from Firestore when the widget is initialized
    _fetchUserData();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
          onBackPressed: () {
            Navigator.pop(context);
          },
          title: 'User Reply'),
      body: Container(
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
        child: Column(
          children: [
            // ListView.builder(
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         height: 50,
            //         width: double.infinity,
            //       );
            //     },),
            Container(
              decoration: BoxDecoration(border: Border.all(color: AppColors.fontColorDark)),
              height: 700,
              width: double.infinity,
              child: Column(
                children: [


                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('community')
                          .doc(widget.commentId)
                          .collection('replies')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var replies = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: replies.length,
                          itemBuilder: (context, index) {
                            var userName = replies[index]['userName'];
                            var replyText = replies[index]['reply'];

                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColors.appColorAccent)),
                                width: double.infinity,
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(userName),
                                    Text(replyText),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),


                  AppTextField(controller: replyController),
                  SizedBox(height: 10),
                  AppButton(
                    buttonText: 'Post',
                    onTapButton: () {
                      postReplyToFirestore(widget.commentId, replyController.text);
                    },
                    width: 100,
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

  void postReplyToFirestore(String commentId, String reply) {
    FirebaseFirestore.instance.collection('community').doc(commentId).collection('replies').add({
      'userName': _userName, // Assuming you have _userName available in this context
      'reply': reply,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print('Reply added to Firestore!');
      replyController.clear();
    }).catchError((error) {
      print('Error adding reply to Firestore: $error');
    });
  }
}
