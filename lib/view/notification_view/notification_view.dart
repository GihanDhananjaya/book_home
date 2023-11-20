import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_bar.dart';
import '../../utils/app_colors.dart';
import '../details/details_view.dart';
import '../read/read_story_view.dart';
import 'another_page.dart';

class NotificationView extends StatefulWidget {
  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final CollectionReference notificationsCollection =
  FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.colorPrimary,
            title: Text('Notification',style: TextStyle(color: AppColors.fontColorWhite),)
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 800,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.fontColorWhite.withOpacity(0.5),
                  AppColors.colorPrimary.withOpacity(0.9),
                ],
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: notificationsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(strokeWidth: 0.5,);
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No notifications available.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var notificationData = snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;

                    var timestamp = notificationData['timestamp'];
                    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
                    var formattedDate = DateFormat.yMd().add_Hm().format(date);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8,top: 8),
                      child: InkResponse(
                        onTap: (){
                          String bookId = notificationData['bookId'] ?? '';
                          String title = notificationData['title']?? 'No title';
                          String chapterName = notificationData['chapterName']?? 'No chapter name';
                          String chapterStory = notificationData['latestChapter']['story']?? 'No chapter story';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnotherPage(title: title,
                                chapterName: chapterName,
                                chapterStory: chapterStory,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(border: Border.all(color: AppColors.fontColorWhite,width: 3),
                              color: AppColors.appColorAccent.withOpacity(0.5)),
                          child:Padding(
                            padding:  EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notificationData['title'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.fontColorDark,
                                      ),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.fontColorWhite,
                                      ),
                                    ),
                                  ],
                                ),
                                // Text(
                                //   notificationData['body'],
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 14,
                                //     color: AppColors.fontColorDark,
                                //   ),
                                // ),
                                SizedBox(height: 5),
                                Text(
                                  'Story: ${notificationData['latestChapter']['story'].substring(0, 40)}...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.fontColorDark,
                                  ),
                                ),
                                SizedBox(height: 4),
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
        ),
      );
  }
}
