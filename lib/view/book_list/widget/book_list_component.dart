import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../entity/book_list_entity.dart';
import '../../../utils/app_colors.dart';

class BookListComponent extends StatelessWidget {
   final BookListEntity  bookListEntityList;
   final VoidCallback onEdit;
   final VoidCallback onDelete;

   BookListComponent({
     required this.bookListEntityList,
     required this.onEdit,
     required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color:AppColors.fontBackgroundColor),
            color: AppColors.textBackgroundColor,borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 80,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.fieldBackgroundColor,
                  border: Border.all(color: AppColors.fontColorDark),
                 ),
                child:bookListEntityList.imageUrl! != null ?
                Image.network(
                    fit: BoxFit.cover,
                    bookListEntityList.imageUrl!):Icon(Icons.image_not_supported)),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bookListEntityList.bookName!,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.fieldBackgroundColor)),
                SizedBox(height: 10),
                Text(bookListEntityList.author,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: AppColors.fieldBackgroundColor)),
                Text(bookListEntityList.title!,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: AppColors.fieldBackgroundColor)),
              ],
            ),
            Spacer(),
            InkResponse(
                onTap: onEdit,
                child: Icon(Icons.edit,color: AppColors.fontColorWhite,)),
            SizedBox(width: 10),
            InkResponse(
                onTap: onDelete,
                child: Icon(Icons.delete,color: AppColors.fontColorWhite,))
          ],
        ),
      ),
    );
  }
}
