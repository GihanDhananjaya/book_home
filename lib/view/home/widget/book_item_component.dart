import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/book_list_entity.dart';
import '../../../utils/app_colors.dart';

class BookItemComponent extends StatelessWidget {
  final BookListEntity  bookListEntityList;


  BookItemComponent({required this.bookListEntityList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

          decoration: BoxDecoration(
            color: AppColors.fieldBackgroundColor,
            border: Border.all(color: AppColors.fontColorDark),
          ),
          child:Image.network(fit: BoxFit.cover, bookListEntityList.imageUrl!)),
    );
  }
}
