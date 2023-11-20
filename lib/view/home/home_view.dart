import 'package:book_home/view/home/widget/book_item_component.dart';
import 'package:book_home/view/home/widget/image_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/app_bar.dart';
import '../../entity/book_list_entity.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../about/about_view.dart';
import '../athentication/login/login_view.dart';
import '../book_list/book_list_view.dart';
import '../book_list/widget/book_list_component.dart';
import '../details/details_view.dart';
import '../privacy_policy/privacy_policy.dart';
// Other imports...

class HomeView extends StatefulWidget {
  get prefs => null;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //late final SharedPreferences prefs;
  bool _isAdmin = false;
  String? _userName; // To store the user's name

  @override
  void initState() {
    setState(() {});
    super.initState();
    // Fetch user data from Firestore when the widget is initialized
    _fetchUserData();
    fetchUserRole();
  }

  // Future<void> logout() async {
  //   // Add logout logic here (e.g., sign out the user)
  //   // ...
  //   widget.prefs!.setBool('userLoggedIn', false);
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => LoginScreen(prefs: widget.prefs)),
  //   );
  // }
  Future<bool> _checkIfUserHasViewedBook(String bookId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot bookSnapshot =
        await _firestore.collection('books').doc(bookId).get();

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
      await _firestore.collection('books').doc(bookId).update({
        'selectedCount': FieldValue.increment(1),
        'viewedBy': FieldValue.arrayUnion([_auth.currentUser?.uid]),
      });
    }
    // Continue with navigation to DetailsView
  }

  void fetchUserRole() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot userData = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userData.exists) {
          String userRole = userData['userRole'] ?? 'User';
          setState(() {
            _isAdmin = (userRole == 'Admin');
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
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

  void _handlePopupMenuSelection(String value) {
    switch (value) {
      case 'Option 1':
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PrivacyPolicy()),
           );
        break;
      case 'Option 2':
         FirebaseAuth.instance.signOut().then((value) => {
             Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => LoginScreen(prefs: widget.prefs)),
         ),
         });
        break;
      case 'Option 3':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => About()),
        );
        break;
        case 'Option 4':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BookListView()),
        );
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Welcome, $_userName!', // Display the user's name here
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColors.fontColorWhite),
          ),
          actions: [
            PopupMenuTheme(
              data: const PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16) ),
                ),
              ),
              child: PopupMenuButton<String>(
                icon: Image.asset(AppImages.appMenu,width: 30,height: 30,color: AppColors.fontColorWhite),
                onSelected: _handlePopupMenuSelection,
                offset: const Offset(0, 50),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Option 1',
                      child: Row(
                        children: [
                          Icon(Icons.privacy_tip,color: AppColors.colorPrimary),
                          SizedBox(width: 10,),
                          Text('Privacy Policy',style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: AppColors.fontColorGray)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Option 2',
                      onTap: (){

                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout,color: AppColors.colorPrimary),
                          SizedBox(width: 10,),
                          Text('Logout',style:GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: AppColors.fontColorGray)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Option 3',
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined,color: AppColors.colorPrimary),
                          SizedBox(width: 10,),
                          Text('About',style:GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: AppColors.fontColorGray)),
                        ],
                      ),
                    ),
                    if (_isAdmin)
                    PopupMenuItem<String>(
                      value: 'Option 4',
                      child: Row(
                        children: [
                          Icon(Icons.manage_accounts,color: AppColors.colorPrimary),
                          SizedBox(width: 10,),
                          Text('Book Management',style:GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: AppColors.fontColorGray)),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),

          ],
          elevation: 0,
          backgroundColor: AppColors.colorPrimary,
        ),
        body: Container(
          height: 800,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.fontColorWhite.withOpacity(0.3),
                AppColors.colorPrimary.withOpacity(0.9),
              ],
            ),
          ),
          // Your gradient and other UI elements...
          child:  SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(color: AppColors.colorPrimary),
                    width: double.infinity,
                    height: 150,
                    child: ImageSlider()),

                SizedBox(height: 40),

                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Trending now...',style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.fontColorDark)),
                ),

                SizedBox(height: 40),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('books').snapshots(),
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
                      final bookId = document.id;


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
                        id: document.id,
                      );
                    }).toList();

                    return Container(
                      height: 400,
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: books.length,
                        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 24,
                             crossAxisSpacing: 7,
                             crossAxisCount: 3,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return InkResponse(
                            onTap: ()   {

                              _handleBookTap(book.id!);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsView(
                                    title: book.title,
                                    author: book.author,
                                    imageUrl: book.imageUrl,
                                    chapters: book.chapters,
                                    selectedCount: book.selectedCount,
                                    bookId: book.id!, // Pass the bookId
                                  ),
                                ),
                              );
                              // Increment the count in Firestore
                            },
                            child: BookItemComponent(
                              bookListEntityList: books[index],),
                          );
                        },),
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
