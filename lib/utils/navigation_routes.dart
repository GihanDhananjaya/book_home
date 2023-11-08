// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import '../entity/book_list_entity.dart';
// import '../entity/chapter_entity.dart';
// import '../view/athentication/login/login_view.dart';
// import '../view/book_list/book_list_view.dart';
// import '../view/details/details_view.dart';
// import '../view/splash/splash_view.dart';
//
//
// class Routes {
//   static const String kSplashView = "kSplashView";
//   static const String kLoginView = "kLoginView";
//   static const String kBookListView = "kBookListView";
//   static const String kDetailsView = "kDetailsView";
//
//
//
//
//   static Route<dynamic> MaterialApp(RouteSettings settings) {
//     switch (settings.name) {
//       case Routes.kSplashView:
//         return PageTransition(
//             child: SplashView(), type: PageTransitionType.fade);
//       case Routes.kLoginView:
//         return PageTransition(
//             child: LoginScreen(), type: PageTransitionType.fade);
//       case Routes.kBookListView:
//         return PageTransition(
//             child: BookListView(), type: PageTransitionType.fade);
//       case Routes.kDetailsView:
//         final book = settings.arguments as BookListEntity; // Extract the BookListEntity
//         return PageTransition(
//           child: DetailsView(
//             title: book.title, // Use the title property of the BookListEntity
//             author: book.author, // Use the author property of the BookListEntity
//             chapters: book.chapters, // Use the chapters property of the BookListEntity
//           ),
//           type: PageTransitionType.fade,
//         );
//
//       default:
//         return MaterialPageRoute(
//           builder: (_) => const Scaffold(
//             body: Center(
//               child: Text("Invalid Route"),
//             ),
//           ),
//         );
//     }
//   }
// }
//
//
