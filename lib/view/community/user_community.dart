import 'package:book_home/view/community/user_reply_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class UserCommunity extends StatefulWidget {
  const UserCommunity({super.key});

  @override
  State<UserCommunity> createState() => _UserCommunityState();
}

class _UserCommunityState extends State<UserCommunity> {
  final TextEditingController commentController = TextEditingController();
  String? _userName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isExpanded = false;
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
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        title: Text(
          'User Community',
          style: TextStyle(color: AppColors.fontColorWhite),
        ),
      ),
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
            Container(
              decoration: BoxDecoration(border: Border.all(color: AppColors.fontColorDark)),
              height: 270,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi ,$_userName",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.fontColorDark)),
                    AppTextField(controller: commentController, maxLength: 1500,maxLines: 5,hint: ''),
                    SizedBox(height: 10),
                    AppButton(
                      buttonText: 'Post',
                      onTapButton: () {
                        postCommentToFirestore(_userName!, commentController.text);
                      },
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('community').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var communityDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: communityDocs.length,
                    itemBuilder: (context, index) {
                      var userName = communityDocs[index]['userName'];
                      var comment = communityDocs[index]['comment'];
                      var likesCount = communityDocs[index]['likesCount'] ?? 0;
                      var likedBy = List<String>.from(communityDocs[index]['likedBy'] ?? []);
                      var commentId = communityDocs[index].id;

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: AppColors.appColorAccent)),
                          width: double.infinity,
                          height: 250,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(userName),
                                  GestureDetector(
                                    onTap: () {
                                      // Toggle the expansion state
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? comment : comment.substring(3, 450) + '...', // Display limited characters initially
                                      maxLines: isExpanded ? null : 4, // Show all lines if expanded
                                    ),
                                  ),
                                  if (!isExpanded)
                                    GestureDetector(
                                      onTap: () {
                                        // Expand the text when "See More..." is tapped
                                        setState(() {
                                          isExpanded = true;
                                        });
                                      },
                                      child: Text(
                                        'See More...',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Toggle like status
                                          toggleLikeStatus(communityDocs[index].id, likedBy);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              likedBy.contains(_auth.currentUser?.uid) ? Icons.favorite : Icons.favorite_border,
                                            ),
                                            Text("$likesCount Likes")
                                          ],
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Image.asset(AppImages.appMenu, height: 25, width: 25,
                                              color: AppColors.fontColorDark),

                                           InkResponse(
                                            onTap:(){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => UserReplyView(commentId: commentId),
                                                ),
                                              );
                                                 },
                                              child: Text("read reply"))
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void postCommentToFirestore(String userName, String comment) {
    FirebaseFirestore.instance.collection('community').add({
      'userName': userName,
      'comment': comment,
      'likesCount': 0 ?? 0,
      'likedBy': [] ?? [],
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print('Comment added to Firestore!');
      commentController.clear();
    }).catchError((error) {
      print('Error adding comment to Firestore: $error');
    });
  }

  void toggleLikeStatus(String documentId, List<String> likedBy) {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      if (likedBy.contains(currentUser.uid)) {
        // User already liked the comment, decrease the count
        FirebaseFirestore.instance.collection('community').doc(documentId).update({
          'likesCount': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        // User didn't like the comment, increase the count
        FirebaseFirestore.instance.collection('community').doc(documentId).update({
          'likesCount': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    }
  }
}
