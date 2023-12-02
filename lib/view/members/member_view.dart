import 'package:book_home/utils/app_images.dart';
import 'package:book_home/view/members/widget/user_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/app_bar.dart';
import '../../entity/user_entity.dart';
import '../../utils/app_colors.dart';

class MemberView extends StatefulWidget {
  const MemberView({Key? key}) : super(key: key);

  @override
  State<MemberView> createState() => _MemberViewState();
}

class _MemberViewState extends State<MemberView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
        title: 'Members',
      ),
      body: Container(
        width: double.infinity,
        height: 800,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final documents = snapshot.data!.docs;

            List<UserEntity> users = documents.map((document) {
              final data = document.data() as Map<String, dynamic>;
              final userName = data['userName'] ?? 'No UserName';
              final imageUrl = data['profileImageURL'] ?? "No image";
              final followers = List<String>.from(data['followers'] ?? []);

              return UserEntity(
                id: document.id,
                imageUrl: imageUrl,
                userName: userName,
                followers: followers,
              );
            }).toList();

            return users.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return InkResponse(
                  onTap: () {},
                  child: UserComponent(
                    userEntityList: user,
                    onFollow: () {
                      toggleFollowStatus(user);
                      if (user.followers!
                          .contains(_auth.currentUser?.uid)) {
                        // Add the user to the following data list
                        _firestore
                            .collection('users')
                            .doc(_auth.currentUser?.uid)
                            .collection('users')
                            .doc(user.id)
                            .set({
                          'userName': user.userName,
                          'imageUrl': user.imageUrl,
                        });
                      } else {
                        // Remove the user from the following data list
                        _firestore
                            .collection('users')
                            .doc(_auth.currentUser?.uid)
                            .collection('users')
                            .doc(user.id)
                            .delete();
                      }
                      // Update the count of users followed by the logged-in user
                      updateFollowedCount(_auth.currentUser!.uid);
                      // Update the followedCount in the user's data collection
                      // updateFollowedCountInUserCollection(
                      //     user.id!, user.followers!.length);
                    },
                    buttonColor:user.followers!.contains(_auth.currentUser?.uid) ?AppColors.primaryYellowColor:AppColors.primaryBackgroundColor,
                    image:user.followers!.contains(_auth.currentUser?.uid) ? AppImages.appFollowing:AppImages.appFollow,
                    text: user.followers!.contains(_auth.currentUser?.uid) ?  'Following':"Follow",
                  ),
                );
              },
            )
                : Text("No Data");
          },
        ),
      ),
    );
  }

  void toggleFollowStatus(UserEntity user) {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        if (user.followers!.contains(currentUser.uid)) {
          // User is currently followed, so unfollow
          user.followers!.remove(currentUser.uid);
          // Update the 'followers' field in Firestore or decrement count
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .update({'followers': user.followers});
        } else {
          // User is not followed, so follow
          user.followers!.add(currentUser.uid);
          // Update the 'followers' field in Firestore or increment count
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.id)
              .update({'followers': user.followers});
        }
      });
    }
  }

  // Future<void> updateFollowedCountInUserCollection(
  //     String userId, int count) async {
  //   // Update the followedCount in the user's data collection
  //   _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .update({'followedCount': count});
  // }

  Future<void> updateFollowedCount(String userId) async {
    // Get the count of users followed by the logged-in user
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('users')
        .get();

    List<String> followedUserNames = querySnapshot.docs
        .map<String>((QueryDocumentSnapshot<Object?> doc) =>
    (doc['userName'] ?? '') as String)
        .toList();

    // Update the user names in the 'followedCount' field in the user's data collection
    _firestore
        .collection('users')
        .doc(userId)
        .update({'followedCount': followedUserNames});
  }




}
