class CommentEntity {
  final String? userId;
  final String? userName;
  final String? comment;

  CommentEntity({
     this.userId,
     this.userName,
     this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'comment': comment,
    };
  }
}
