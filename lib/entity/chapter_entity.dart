import 'comment_entity.dart';

class ChapterEntity{
  String name;
  String story;
  final List<CommentEntity>? commentList;

  ChapterEntity({this.commentList,required this.name, required this.story});
}