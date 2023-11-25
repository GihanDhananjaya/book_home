import 'chapter_entity.dart';

class BookListEntity {
  final String? bookName;
  final String? title;
  final String author;
  final String? imageUrl;
  final String? id;
  final List<ChapterEntity> chapters;
  final int? selectedCount;

  BookListEntity({
    this.bookName,
    this.title,
    required this.author,
    this.imageUrl,
    this.id,
    required this.chapters,
    this.selectedCount,
  });
}
