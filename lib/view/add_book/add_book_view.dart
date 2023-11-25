import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_bar.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../common/image_upload_widget.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../book_list/book_list_view.dart';
import '../notification_view/local_notification.dart';
import 'add_chapter.dart';


class AddBookView extends StatefulWidget {
  @override
  _AddBookViewState createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {

  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  String? _selectedImage;
  Uint8List? profileImage;
  String? fileExtension;
  String? _selectedBookTitle;


  final TextEditingController _textField1Controller = TextEditingController();
  final TextEditingController _textField2Controller = TextEditingController();

  final List<ChapterEntity> chapterEntityList = [];


  Future<String?> _uploadImageToStorage(Uint8List imageBytes, String fileExtension) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.
      ref().child('images/${DateTime.now().millisecondsSinceEpoch}.$fileExtension');
      final UploadTask uploadTask =
      storageReference.putData(imageBytes, SettableMetadata(contentType: 'image/$fileExtension'));

      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }


  Future<void> _addBookToFirebase() async {
    final bookName = _bookNameController.text;
    final authorName = _authorNameController.text;

    if (bookName.isNotEmpty && authorName.isNotEmpty && profileImage !=
        null && fileExtension != null) {
      final firestore = FirebaseFirestore.instance;
      final collectionReference  = firestore.collection('books');

      final imageUrl = await _uploadImageToStorage(profileImage!, fileExtension!);

      final List<Map<String, dynamic>> chapterDataList = chapterEntityList
          .map((chapter) => {
        'name': chapter.name,
        'story': chapter.story,
        'commentList': chapter.commentList?.map((comment) => comment.toMap()).toList(),
      }).toList();

      // if (imageUrl != null) {
      //   final List<Map<String, dynamic>> chapterDataList = chapterEntityList
      //       .map((chapter) => {
      //     'name': chapter.name,
      //     'story': chapter.story,
      //     'commentList': chapter.commentList?.map((comment) => comment.toMap()).toList(),
      //   })
      //       .toList();

      final bookData = {
        'book_name': bookName,   // Set the book title
        'author': authorName, // Set the author's name
        'image_url': imageUrl,
        'chapters': chapterDataList,
        'title': _selectedBookTitle,
      };

      final newDocument = await collectionReference .add(bookData);

      setState(() {
        _bookNameController.clear();
        _authorNameController.clear();
        // Rest of your code to clear other fields and lists
      });
    } else {
      // Handle the case where image upload fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to upload image. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _navigateToAddChapterView() async {
    final newChapter = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddChapterView(),
      ),
    );

    if (newChapter != null) {
      setState(() {
        chapterEntityList.add(newChapter);
      });
    }
  }

  List<DropdownMenuItem<String>> _getBookTitles() {
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
    return  MaterialApp(
      home: Scaffold(
        appBar: BookAppBar(title: 'Add Your Book', onBackPressed: () {
          Navigator.pop(context);
        },),
        body: Container(
          width:double.infinity,
          height: double.infinity,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                              width: 70,
                              buttonText: 'Submit', onTapButton: (){
                                _addBookToFirebase();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookListView()),
                            );
                          }),
                        ],
                      ),
                      ProfileImageUi(title: 'Book Image',
                          onChanged: (bytes, extension){
                            profileImage = bytes;
                            fileExtension = extension;
                          }),
                      SizedBox(height: 20),
                      AppTextField(hint: 'name',controller: _bookNameController),
                      SizedBox(height: 20),
                      AppTextField(hint: 'author',controller: _authorNameController),
                      SizedBox(height: 20),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title',style: TextStyle(color: AppColors.fontLabelGray)),
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(color: AppColors.fontColorWhite,borderRadius: BorderRadius.all(Radius.circular(8))),
                            width: double.infinity,
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              value: _selectedBookTitle,
                              hint: Text('Select Book Title'),
                              items: _getBookTitles(), // Implement this method to get the book titles
                              onChanged: (value) {
                                setState(() {
                                  _selectedBookTitle = value as String?;
                                });
                              },
                            ),
                          ),
                        ],
                      ),


                      Container(
                        height: 300,
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: chapterEntityList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.appColorAccent,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: Text(chapterEntityList[index].name,style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: AppColors.fontColorWhite)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // AppButton(
                      //     buttonText: 'Submit', onTapButton: (){
                      //   _addBookToFirebase();
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => BookListView()),
                      //   );
                      // }),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                onPressed: () {
                  _navigateToAddChapterView();
                },
                child: Icon(Icons.add),
                backgroundColor: AppColors.fontBackgroundColor, // Change the color as needed
              ),
            ],
          ),
        ),

      ),
    );
  }
}

// Future<void> _navigateToAddChapterView() async {
//   final newChapter = await Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) => AddChapterView(),
//     ),
//   );
//
//   if (newChapter != null) {
//     setState(() {
//       chapterEntityList.add(newChapter);
//     });
//   }
// }



// void addItem() {
//   final String url = _textField1Controller.text.trim();
//   final String title = _textField2Controller.text.trim();
//
//   if (url.isNotEmpty && title.isNotEmpty) {
//     setState(() {
//       chapterEntityList.add(ChapterEntity( name: url, story: title,));
//       _textField1Controller.clear();
//       _textField2Controller.clear();
//     });
//   }
// }

