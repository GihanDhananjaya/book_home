import 'chapter_entity.dart';

class BookListEntity {
  final String title;
  final String author;
  final String? imageUrl;
  final List<ChapterEntity> chapters;

  BookListEntity({
    required this.title,
    required this.author,
    this.imageUrl,
    required this.chapters,
  });
}
