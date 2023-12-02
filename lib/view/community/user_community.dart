import 'dart:typed_data';
import 'dart:io';

import 'package:book_home/view/community/user_reply_view.dart';
import 'package:book_home/view/community/widget/community_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';


class UserCommunity extends StatefulWidget {
  const UserCommunity({Key? key}) : super(key: key);

  @override
  State<UserCommunity> createState() => _UserCommunityState();
}

class _UserCommunityState extends State<UserCommunity> {
  final TextEditingController commentController = TextEditingController();

  String? imageUrl;
  String? _userName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isExpanded = false;

  File? _uploadedImage;
  String? _imageExtension;

  Set<String> viewedComments = Set();
  int? expandedIndex;


  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore when the widget is initialized
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot userData = await _firestore.collection('users').doc(currentUser.uid).get();
        setState(() {
          _userName = userData['userName'];
          imageUrl = userData['profileImageURL'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, String commentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Comment'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to delete the comment
                deleteComment(commentId);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteComment(String commentId) {
    FirebaseFirestore.instance.collection('community').doc(commentId).delete().then((value) {
      print('Comment deleted from Firestore!');
    }).catchError((error) {
      print('Error deleting comment from Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstLetter = _userName?.isNotEmpty ?? false ? _userName!.substring(0, 1).toUpperCase() : 'A';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.containerBackgroundColor,
        title: Text(
          'User Community',
          style: TextStyle(color: AppColors.fontColorWhite),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.fontColorDark)),
                  height: 310,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.fontColorGray),
                                color: AppColors.fontColorWhite,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: imageUrl != null && imageUrl!.isNotEmpty
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl!),
                              )
                                  : Center(
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
                            Text(
                              "Hi ,$_userName",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColors.fontColorWhite,
                              ),
                            ),
                          ],
                        ),
                        AppTextField(controller: commentController, maxLength: 1500, maxLines: 5, hint: ''),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppButton(
                              buttonText: 'Post',
                              onTapButton: () {
                                postCommentToFirestore(_userName!, commentController.text);
                              },
                              width: 100,
                            ),
                            CoverImage(
                              onChanged: (imageData, extension) {
                                setState(() {
                                  _uploadedImage = imageData;
                                  _imageExtension = extension;
                                });
                              },
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('community').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var communityDocs = snapshot.data!.docs;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: communityDocs.length,
                    itemBuilder: (context, index) {
                      var userName = communityDocs[index]['userName'];
                      var comment = communityDocs[index]['comment'];
                      var imageUrl = communityDocs[index]['imageUrl'];
                      var likesCount = communityDocs[index]['likesCount'] ?? 0;
                      var seeMoreCount = communityDocs[index]['seeMoreCount'] ?? 0;
                      var likedBy = List<String>.from(communityDocs[index]['likedBy'] ?? []);
                      var commentId = communityDocs[index].id;

                      bool isCurrentUserAuthor = _userName == userName;

                      // // Ensure that the isExpandedList has enough elements
                      // while (isExpandedList.length <= index) {
                      //   isExpandedList.add(false);
                      // }

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: AppColors.textBackgroundColor)),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userName,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.fontColorWhite,
                                      ),
                                    ),
                                    if (isCurrentUserAuthor)
                                      InkResponse(
                                        onTap: () {
                                          showDeleteConfirmationDialog(context, commentId);
                                        },
                                        child: Icon(Icons.delete, color: AppColors.primaryYellowColor),
                                      )
                                  ],
                                ),
                                SizedBox(height: 10),

                                if (imageUrl != null && imageUrl.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(borderRadius:BorderRadius.circular(6)),
                                    height: 180, // Adjust the height as needed
                                    width: 430,
                                    child: ClipRRect(
                                       borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        imageUrl,

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 30),

                                GestureDetector(
                                  onTap: () async {
                                    _handleBookTap(commentId);
                                    setState(() {
                                      // Toggle between expanding and collapsing
                                      expandedIndex = expandedIndex == index ? null : index;
                                    });
                                    // if (!viewedComments.contains(commentId)) {
                                    //   // Only update Firestore and set viewedComments if the comment hasn't been viewed before
                                    //   await FirebaseFirestore.instance.collection('community').doc(commentId).update({
                                    //     'seeMoreCount': FieldValue.increment(1),
                                    //   });
                                    // }
                                    // setState(() {
                                    //   // Toggle between expanding and collapsing
                                    //   expandedIndex = expandedIndex == index ? null : index;
                                    //   viewedComments.add(commentId);
                                    // });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      expandedIndex == index ? comment : (
                                          comment.length > 450 ? comment : comment.substring(3, 30) + '...'),
                                      maxLines: expandedIndex == index ? null : 4,
                                      style: TextStyle(color: AppColors.fontColorWhite),
                                    ),
                                  ),
                                ),
                                if (expandedIndex == null && !viewedComments.contains(commentId))
                                  GestureDetector(
                                    onTap: ()  {
                                      // if (!viewedComments.contains(commentId)) {
                                      //   // Only update Firestore and set viewedComments if the comment hasn't been viewed before
                                      //   await FirebaseFirestore.instance.collection('community').doc(commentId).update({
                                      //     'seeMoreCount': FieldValue.increment(1),
                                      //   });
                                      //   setState(() {
                                      //      //expandedIndex = index;
                                      //     viewedComments.add(commentId);
                                      //    // expandedIndex = expandedIndex == index ? null : index;
                                      //   });
                                      // }
                                    },
                                    child: Text(
                                      'See More...',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        toggleLikeStatus(communityDocs[index].id, likedBy);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            likedBy.contains(_auth.currentUser?.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: AppColors.primaryBackgroundColor,
                                          ),
                                          Text("$likesCount Likes",
                                              style: TextStyle(color: AppColors.fontColorWhite)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye_outlined, color: AppColors.fontColorWhite),
                                        SizedBox(width: 5),
                                        InkResponse(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UserReplyView(commentId: commentId),
                                              ),
                                            );
                                          },
                                          child: Text("$seeMoreCount views", style: TextStyle(color: AppColors.fontColorWhite)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(AppImages.appMenu, height: 25, width: 25, color: AppColors.fontColorWhite),
                                        SizedBox(width: 5),
                                        InkResponse(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UserReplyView(commentId: commentId),
                                              ),
                                            );
                                          },
                                          child: Text("read reply", style: TextStyle(color: AppColors.fontColorWhite)),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postCommentToFirestore(String userName, String comment) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String imageUrl;

        if (_uploadedImage != null) {
          final storageRef = FirebaseStorage.instance.ref().child('community_images').child(
            '${DateTime.now().millisecondsSinceEpoch}$_imageExtension',
          );
          final uploadTask = storageRef.putFile(_uploadedImage!);
          await uploadTask.whenComplete(() => null);
          imageUrl = await storageRef.getDownloadURL();
        } else {
          imageUrl = '';
        }

        await _firestore.collection('community').add({
          'userName': userName,
          'comment': comment,
          'likesCount': 0,
          'likedBy': [],
          'seeMoreCount': 0,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': imageUrl,
        });

        commentController.clear();
        setState(() {
          _uploadedImage = null;
        });

        print('Comment added to Firestore!');
      }
    } catch (error) {
      print('Error adding comment to Firestore: $error');
    }
  }

  void toggleLikeStatus(String documentId, List<String> likedBy) {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      if (likedBy.contains(currentUser.uid)) {
        FirebaseFirestore.instance.collection('community').doc(documentId).update({
          'likesCount': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        FirebaseFirestore.instance.collection('community').doc(documentId).update({
          'likesCount': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    }
  }


  Future<bool> _checkIfUserHasViewedBook(String bookId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot bookSnapshot =
        await _firestore.collection('community').doc(bookId).get();

        if (bookSnapshot.exists) {
          final List<dynamic> viewedBy = bookSnapshot['viewedBy'] ?? [];
          return viewedBy.contains(currentUser.uid);
        }
        return false;
      }
      return false;
    } catch (e) {
      print('Error checking if user has viewed the book: $e');
      return false;
    }
  }

  void _handleBookTap(String bookId) async {
    bool hasViewed = await _checkIfUserHasViewedBook(bookId);
    if (!hasViewed) {
      await _firestore.collection('community').doc(bookId).update({
        'seeMoreCount': FieldValue.increment(1),
        'viewedBy': FieldValue.arrayUnion([_auth.currentUser?.uid]),
      });
    }
    // Continue with navigation to DetailsView
  }

}
