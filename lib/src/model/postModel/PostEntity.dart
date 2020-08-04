import 'package:amigos/src/model/postModel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  PostEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.documentID,
        postedAt = documentSnapshot.data["postedAt"],
        imagePath = documentSnapshot.data["imagePath"],
        description = documentSnapshot.data["description"],
        likesCount = documentSnapshot.data["likesCount"],
        commentsCount = documentSnapshot.data["commentsCount"],
        likeList = List<String>.from(documentSnapshot.data["likeList"]),
        tags = List<String>.from(documentSnapshot.data["tags"]),
        userId = documentSnapshot.data["userId"],
        user = User.fromJsonMap(documentSnapshot.data["user"]);

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
