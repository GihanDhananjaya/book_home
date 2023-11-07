import 'dart:typed_data';
import 'package:book_home/view/book_list/widget/book_list_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_bar.dart';
import '../../edit_profile_view.dart';
import '../../entity/book_list_entity.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../../utils/navigation_routes.dart';
import '../add_book/add_book_view.dart';
import '../details/details_view.dart';

class BookListView extends StatefulWidget {
  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  Uint8List? profileImage;
  String? fileExtension;

  Future<void> _deleteBook(BuildContext context, String documentId) async {
    bool confirmed = false; // To track whether the user confirmed the delete action.

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog.
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // User confirmed the delete action.
                confirmed = true;
                Navigator.of(dialogContext).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        final firestore = FirebaseFirestore.instance;
        final collection = firestore.collection('books1');

        await collection.doc(documentId).delete();

        // Optionally, you can add a snackbar or other UI feedback to indicate success.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Book deleted successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error deleting book: $e');
        // Handle the error, e.g., show an error message.
        showDialog(
          context: context,
          builder: (errorDialogContext) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to delete book. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(errorDialogContext).pop(); // Close the error dialog.
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  _updateBook(BuildContext callingContext, String documentId, String currentTitle, String currentAuthor, String imageUrl, List<ChapterEntity> chapters) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileView(
          bookId: documentId,
          currentTitle: currentTitle,
          currentAuthor: currentAuthor,
          currentImageUrl: imageUrl,
          chapters: chapters,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.colorPrimary,
            title: Text('Book Management')
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
              SizedBox(height: 50),
              // Text('කතා අරණ',style: GoogleFonts.arizonia(
              //     fontWeight: FontWeight.w500,
              //     fontSize: 26,
              //     color: AppColors.fontColorDark)),
              // SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('books1').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;

                  List<BookListEntity> books = documents.map((document) {
                    final data = document.data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'No Title';
                    final author = data['author'] ?? 'No Author';
                    final imageUrl = data['image_url'];
                    final chaptersData = data['chapters'];

                    List<ChapterEntity> chapters = [];

                    if (chaptersData != null && chaptersData is List) {
                      chapters = chaptersData.map((chapterData) {
                        return ChapterEntity(
                          name: chapterData['name'],
                          story: chapterData['story'],
                        );
                      }).toList();
                    }

                    return BookListEntity(
                      title: title,
                      author: author,
                      imageUrl: imageUrl,
                      chapters: chapters,
                    );
                  }).toList();

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return InkResponse(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsView(
                                  title: book.title,
                                  author: book.author,
                                  imageUrl: book.imageUrl,
                                  chapters: book.chapters,
                                ),
                              ),
                            );

                            },
                          child: BookListComponent(
                            bookListEntityList: books[index],
                            onEdit: () {
                              _updateBook(
                                context,
                                documents[index].id,
                                book.title,
                                book.author,
                                book.imageUrl!,
                                book.chapters,
                              );
                            },
                            onDelete: () {
                              _deleteBook(context, documents[index].id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
