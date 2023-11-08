import 'dart:io';
import 'package:book_home/view/bootom_bar/widget/bottom_bar_item_component.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../profile_view/profile_view.dart';
import '../add_book/add_book_view.dart';
import '../book_list/book_list_view.dart';
import '../home/home_view.dart';


class BottomBarView extends StatefulWidget {
  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int _selectedPage = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: _getBody(),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(top: 5),
        color: AppColors.appColorAccent,
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomBarItem(
              name: 'HOME',
              icon: AppImages.appHome,
              onTap: () {
                if (_selectedPage != 0) {
                  setState(() {
                    _selectedPage = 0;
                  });
                }
              }, isSelected: _selectedPage == 0,
            ),
            BottomBarItem(
              name: 'Team',
              icon: AppImages.appTeam,
              onTap: () {
                if (_selectedPage != 1) {
                  setState(() {
                    _selectedPage = 1;
                  });
                }
              }, isSelected: _selectedPage == 1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkResponse(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBookView()),
                  );
                },
                child: Container(
                  child: Icon(Icons.add,color: AppColors.fontColorWhite),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),color: AppColors.colorPrimary,

                  ),
                ),
              ),
            ),
            BottomBarItem(
              name: 'Store',
              icon: AppImages.appBook,
              onTap: () {
                if (_selectedPage != 2) {
                  setState(() {
                    _selectedPage = 2;
                  });
                }
              }, isSelected: _selectedPage == 2,
            ),
            BottomBarItem(
              name: 'Profile',
              icon: AppImages.editProfile,
              onTap: () {
                if (_selectedPage != 3) {
                  setState(() {
                    _selectedPage = 3;
                  });
                }
              },
              isSelected:  _selectedPage == 3,
            ),
            // BottomBarItem(
            //   icon: AppImages.icHomeAction,
            //   onTap: () {
            //     if (AppConstants.IS_PAYMENT_DONE) {
            //       Navigator.pushNamed(context, Routes.kPackageDetailUI);
            //     } else {
            //       Navigator.pushNamed(context, Routes.kOnlinePaymentView);
            //     }
            //   },
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //     backgroundColor: AppColors.colorPrimary,
      //     onPressed: () {
      //
      //     },
      //     child:  Icon(Icons.add),
      // ),
    );
  }


  _getBody() {
    switch (_selectedPage) {
      case 0:
        return HomeView();
      case 1:
        return BookListView();
      case 2:
        return BookListView();
      default:
        return ProfileView();
    }
  }
}


