import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/book_list_entity.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import 'app_image_loader.dart';

class BookItemComponent extends StatelessWidget {
  final BookListEntity bookListEntityList;

  BookItemComponent({required this.bookListEntityList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.textBackgroundColor,
          border: Border.all(color: AppColors.textBackgroundColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AppImageLoader(
            image: bookListEntityList.imageUrl ?? '',
            width: 120,
            height: 150,
          ),
        ),
      ),
    );
  }
}
