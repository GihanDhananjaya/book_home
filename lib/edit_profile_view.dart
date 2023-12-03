import 'dart:typed_data';
import 'package:book_home/utils/app_colors.dart';
import 'package:book_home/view/add_book/add_chapter.dart';
import 'package:book_home/view/chapter/edit_chapter_view.dart';
import 'package:book_home/view/notification_view/local_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'common/app_bar.dart';
import 'common/app_button.dart';
import 'common/app_text_field.dart';
import 'common/image_upload_widget.dart';
import 'entity/chapter_entity.dart';


class EditProfileView extends StatefulWidget {
  final String? bookId;
  final String? currentName;
  final String? currentAuthor;
  final String? currentTitle;
  final String? currentImageUrl;
  List<ChapterEntity> chapters; // List to store chapters.

  EditProfileView({
    Key? key,
    this.bookId,
    this.currentName,
    this.currentAuthor,
    this.currentTitle,
    this.currentImageUrl,
    required this.chapters, // Initialize chapters list.
  }) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  Uint8List? profileImage;
  String? fileExtension;
  String? imageUrl;
  String? _selectedBookTitle;
  final List<String> bookTitles = [
    'Title 1',
    'Title 2',
    'Title 3',
  ];

  @override
  void initState() {
    super.initState();
    _bookNameController.text = widget.currentName ?? '';
    _authorNameController.text = widget.currentAuthor ?? '';
    imageUrl = widget.currentImageUrl;
    _selectedBookTitle = widget.currentTitle;
  }

  List<DropdownMenuItem<String>> _getBookTitles(List<String> bookTitles) {
    return bookTitles.map((title) {
      return DropdownMenuItem<String>(
        value: title,
        child: Text(title),
      );
    }).toList();
  }

  Future<void> _updateProfile(BuildContext context) async {
    try {
      final updatedName = _bookNameController.text;
      final updatedAuthor = _authorNameController.text;
      final title = _selectedBookTitle;
      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('books');

      final updatedData = {
        'book_name': updatedName,
        'author': updatedAuthor,
        'title':title,
        'chapters': widget.chapters.map((chapter) {
          return {
            'name': chapter.name,
            'story': chapter.story,
          };
        }).toList(), // Convert chapters list to Firestore-compatible format.
      };

      // Access the last chapter in the list
      if (widget.chapters.isNotEmpty) {
        final latestChapter = widget.chapters.last;
        updatedData['latestChapter'] = {
          'name': latestChapter.name,
          'story': latestChapter.story,
        };
      }

      if (profileImage != null) {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref().child('profile_images/${widget.bookId}.$fileExtension');
        await ref.putData(profileImage!);
        imageUrl = await ref.getDownloadURL();
        updatedData['image_url'] = imageUrl!;
      }

      await collection.doc(widget.bookId).update(updatedData);

      // Create a Firestore reference to the "notifications" collection.
      final notificationsCollection = firestore.collection('notifications');

      // Define the notification data you want to store.
      final notificationData = {
        'title': "යාවත් කාලීන කළා $updatedName",
        'image_url': imageUrl,
        'body': widget.chapters.map((chapter) {
          return {
            'name': chapter.name,
            'story': chapter.story,
          };
        }).toList(), // C
        'timestamp': FieldValue.serverTimestamp(),

      };

      if (widget.chapters.isNotEmpty) {
        final latestChapter = widget.chapters.last;

        if (latestChapter.name != null && latestChapter.story != null) {
          notificationData['latestChapter'] =  {
            'name': latestChapter.name,
            'story': latestChapter.story,
          };
        }
      }

      // Add the notification data to the Firestore collection.
      await notificationsCollection.add(notificationData);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addChapter(ChapterEntity newChapter) {
    // Add a new chapter to the list when a chapter is added.
    setState(() {
      widget.chapters.add(newChapter);
    });
  }

  List<DropdownMenuItem<String>> _getBookTitle() {
    // Implement logic to fetch book titles from Firestore or other data source
    // and return a list of DropdownMenuItem<String>
    // Example:
    List<String> bookTitles = ['Novels', 'Short Story', 'Love Story','Action Story']; // Replace with actual data

    return bookTitles.map((title) {
      return DropdownMenuItem<String>(
        value: title,
        child: Text(title),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(title:'Edit Book'),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: AppColors.textBackgroundColor,
            borderRadius: BorderRadius.circular(40)),
        width: 250,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Text('Create New Chapter',style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColors.fontColorWhite)),
            FloatingActionButton(
              onPressed: () async {
                final newChapter = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddChapterView(),
                  ),
                );

                // Check if a new chapter was returned and add it to the list.
                if (newChapter != null) {
                  _addChapter(newChapter);
                }
              },
              child: Icon(Icons.add,color: AppColors.fontColorWhite),
              backgroundColor: AppColors.fontBackgroundColor, // Change the color as needed
            ),
          ],
        ),
      ),
      body: Container(
        height: 800,
        decoration: BoxDecoration(
          color: AppColors.containerBackgroundColor
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     AppColors.fontColorWhite.withOpacity(0.5),
          //     AppColors.colorPrimary.withOpacity(0.5),
          //   ],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      width: 70,
                      buttonText: 'Update',
                      onTapButton: () {
                        LocalNotifications.showSimpleNotification(
                            title: "Simple Notification",
                            body: "This is a simple notification",
                            payload: "This is simple data");
                        _updateProfile(context); // Update the profile.
                        Navigator.pop(context); // Close the EditProfileView.
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ProfileImageUi(
                  title: 'Edit Book',
                  onChanged: (bytes, extension) async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      final bytes = await pickedFile.readAsBytes();
                      final extension = pickedFile.path.split('.').last;

                      setState(() {
                        profileImage = bytes;
                        fileExtension = extension;
                      });
                    }
                  },
                ),
                AppTextField(hint: 'Name', controller: _bookNameController),
                SizedBox(height: 20),
                AppTextField(hint: 'Author', controller: _authorNameController),
                SizedBox(height: 20),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title',style: TextStyle(color: AppColors.fontColorWhite)),
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(color: AppColors.textBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: AppColors.primaryBackgroundColor)),
                      width: double.infinity,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        iconEnabledColor: AppColors.fontColorWhite,
                        decoration: InputDecoration(fillColor: AppColors.textBackgroundColor,border: InputBorder.none,
                            counterStyle: TextStyle(color: AppColors.fontColorWhite,)),
                        style: TextStyle(color: AppColors.fontColorWhite,fontSize: 14,fontWeight: FontWeight.bold),
                        value: _selectedBookTitle,
                        hint: Text('Select Book Title'),
                        items: _getBookTitle(), // Implement this method to get the book titles
                        onChanged: (value) {
                          setState(() {
                            _selectedBookTitle = value as String?;
                          });
                        },
                        dropdownColor: AppColors.textBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                // Add Chapter Input Fields
                // AppButton(
                //   buttonText: 'Add Chapter',
                //   onTapButton: () async {
                //     final newChapter = await Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => AddChapterView(),
                //       ),
                //     );
                //
                //     // Check if a new chapter was returned and add it to the list.
                //     if (newChapter != null) {
                //       _addChapter(newChapter);
                //     }
                //   },
                // ),


                SizedBox(height: 20),
                // Display Chapters
                if (widget.chapters.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chapters:',
                          style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.fontColorWhite),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = widget.chapters[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Name: ${chapter.name}',style: TextStyle(color: AppColors.fontColorWhite)),
                                      InkResponse(
                                          onTap: () async {
                                            final editedChapter = await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => EditChapterView(
                                                  chapterName: chapter.name,
                                                  chapterStory: chapter.story,
                                                ),
                                              ),
                                            );

                                            // Check if the chapter was edited and update the chapter in the list.
                                            if (editedChapter != null) {
                                              setState(() {
                                                chapter.name = editedChapter.name;
                                                chapter.story = editedChapter.story;
                                              });
                                            }
                                          },
                                          child: Icon(Icons.edit,color: AppColors.fontColorWhite,))
                                    ],

                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                // AppButton(
                //   buttonText: 'Update',
                //   onTapButton: () {
                //     _updateProfile(context); // Update the profile.
                //     Navigator.pop(context); // Close the EditProfileView.
                //   },
                // ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
