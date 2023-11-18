import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_bar.dart';
import '../../entity/chapter_entity.dart';
import '../../utils/app_colors.dart';
import '../read/read_story_view.dart';

class DetailsView extends StatefulWidget {
  final String title;
  final String author;
  final String? imageUrl;
  final List<ChapterEntity> chapters;

  DetailsView({required this.title, required this.author, this.imageUrl,required this.chapters,});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BookAppBar(
            onBackPressed: () {
              Navigator.pop(context);
            },
            title: 'Chapters'),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft, // Start from the bottom-left corner
              end: Alignment.centerRight,     // End at the top-right corner
              colors: [
                AppColors.fontColorWhite.withOpacity(0.5),  // Color from the bottom-left side (light yellow)
                AppColors.colorPrimary.withOpacity(0.8),   // Color from the bottom-left side (green)
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.appColorAccent)),
                  child: Image.network(widget.imageUrl!,height: 200,width: double.infinity,fit: BoxFit.cover,)),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.arrow_left),
                  Text(widget.title,style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.fontColorDark)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height:500,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.chapters.length,
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReadStoryView(
                            chapterName: widget.chapters[index].name,
                            chapterStory: widget.chapters[index].story, title: widget.title,
                          )),
                        );
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(left: 20.0,right: 20,bottom: 8,top: 8),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.appColorAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text('Chapter ${index + 1}: ${widget.chapters[index].name}',style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: AppColors.fontColorWhite)),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: AppColors.fontColorWhite.withOpacity(.4),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      );
  }
}
