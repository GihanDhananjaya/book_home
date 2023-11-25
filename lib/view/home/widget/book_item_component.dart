import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/book_list_entity.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class BookItemComponent extends StatelessWidget {
  final BookListEntity bookListEntityList;

  BookItemComponent({required this.bookListEntityList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textBackgroundColor,
          border: Border.all(color: AppColors.textBackgroundColor, width: 2),
        ),
        child: Image.network(
          bookListEntityList.imageUrl ?? '', // Use the imageUrl here
          fit: BoxFit.cover,
          width: 120, // Adjust the width as needed
          height: 150, // Adjust the height as needed
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              // While the image is loading, display an Icon or any other placeholder widget.
              return Center(
                  child: Image.asset(AppImages.appBookImg,fit: BoxFit.cover, width: 120, // Adjust the width as needed
                    height: 150)
              );
            }
          },
        ),
      ),
    );
  }
}
