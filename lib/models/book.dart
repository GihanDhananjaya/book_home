class Book {
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  factory Book.fromMap(String id, Map<String, dynamic> data) {
    final String title = data['title'];
    final String author = data['author'];
    final String imageUrl = data['image_url'];
    return Book(title: title, author: author, imageUrl: imageUrl);
  }
}
