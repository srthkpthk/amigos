import 'package:amigos/src/model/postModel/user.dart';

class PostEntity {
  String id;
  String postedAt;
  String imagePath;
  String description;
  int likesCount;
  int commentsCount;
  List<String> likeList;
  List<String> tags;
  String userId;
  User user;

  PostEntity(
      this.id,
      this.postedAt,
      this.imagePath,
      this.description,
      this.likesCount,
      this.commentsCount,
      this.likeList,
      this.tags,
      this.userId,
      this.user);

  PostEntity.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        postedAt = map["postedAt"],
        imagePath = map["imagePath"],
        description = map["description"],
        likesCount = map["likesCount"],
        commentsCount = map["commentsCount"],
        likeList = List<String>.from(map["likeList"]),
        tags = List<String>.from(map["tags"]),
        userId = map["userId"],
        user = User.fromJsonMap(map["user"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['postedAt'] = postedAt;
    data['imagePath'] = imagePath;
    data['description'] = description;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    data['likeList'] = likeList;
    data['tags'] = tags;
    data['userId'] = userId;
    data['user'] = user == null ? null : user.toJson();
    return data;
  }
}
