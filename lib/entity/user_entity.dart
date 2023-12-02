import 'chapter_entity.dart';

class UserEntity {
  final String? userName;
  final String? imageUrl;
  final String? id;
  final int? followingCount;
  final List<String>? followers;
  final bool? followed;

  UserEntity({
    this.userName,
    this.imageUrl,
    this.id,
    this.followingCount,
    this.followers,
    this.followed,
  });
}
