import 'dart:typed_data';
import 'package:book_home/utils/app_colors.dart';
import 'package:book_home/view/add_book/add_chapter.dart';
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
  final String? currentTitle;
  final String? currentAuthor;
  final String? currentImageUrl;
  List<ChapterEntity> chapters; // List to store chapters.

  EditProfileView({
    Key? key,
    this.bookId,
    this.currentTitle,
    this.currentAuthor,
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

  @override
  void initState() {
    super.initState();
    _bookNameController.text = widget.currentTitle ?? '';
    _authorNameController.text = widget.currentAuthor ?? '';
    imageUrl = widget.currentImageUrl;
  }

  Future<void> _updateProfile(BuildContext context) async {
    try {
      final updatedTitle = _bookNameController.text;
      final updatedAuthor = _authorNameController.text;

      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('books');

      final updatedData = {
        'title': updatedTitle,
        'author': updatedAuthor,
        'chapters': widget.chapters.map((chapter) {
          return {
            'name': chapter.name,
            'story': chapter.story,
          };
        }).toList(), // Convert chapters list to Firestore-compatible format.
      };

      if (profileImage != null) {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref().child('profile_images/${widget.bookId}.$fileExtension');
        await ref.putData(profileImage!);
        imageUrl = await ref.getDownloadURL();
        updatedData['image_url'] = imageUrl!;
      }

      await collection.doc(widget.bookId).update(updatedData);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookAppBar(title:'Edit Book'),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: AppColors.colorPrimary,
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
              backgroundColor: AppColors.appColorAccent, // Change the color as needed
            ),
          ],
        ),
      ),
      body: Container(
        height: 800,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.fontColorWhite.withOpacity(0.5),
              AppColors.colorPrimary.withOpacity(0.5),
            ],
          ),
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
                        _updateProfile(context); // Update the profile.
                        Navigator.pop(context); // Close the EditProfileView.
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ProfileImageUi(
                  title: 'Edit Profile',
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
                AppTextField(hint: 'name', controller: _bookNameController),
                SizedBox(height: 20),
                AppTextField(hint: 'author', controller: _authorNameController),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapters:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = widget.chapters[index];
                          return ListTile(
                            title: Text('Name: ${chapter.name}'),

                          );
                        },
                      ),
                    ],
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
