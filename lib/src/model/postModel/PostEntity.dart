import 'package:amigos/src/model/postModel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  String id;
  String postedAt;
  String imagePath;
  String description;
  List<String> likeList;
  List<String> tags;
  String userId;
  User user;
  bool isFlagged;
  List<String> flaggedBy;

  PostEntity(
      this.id,
      this.postedAt,
      this.imagePath,
      this.description,
      this.likeList,
      this.tags,
      this.userId,
      this.user,
      this.isFlagged,
      this.flaggedBy);

  PostEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.documentID,
        postedAt = documentSnapshot.data["postedAt"],
        imagePath = documentSnapshot.data["imagePath"],
        isFlagged = documentSnapshot.data['isFlagged'],
        description = documentSnapshot.data["description"],
        likeList = List<String>.from(documentSnapshot.data["likeList"]),
        flaggedBy = List<String>.from(documentSnapshot.data["flaggedBy"]),
        tags = List<String>.from(documentSnapshot.data["tags"]),
        userId = documentSnapshot.data["userId"],
        user = User.fromJsonMap(documentSnapshot.data["user"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['postedAt'] = postedAt;
    data['imagePath'] = imagePath;
    data['isFlagged'] = isFlagged;
    data['description'] = description;
    data['likeList'] = likeList;
    data['tags'] = tags;
    data['flaggedBy'] = flaggedBy;
    data['userId'] = userId;
    data['user'] = user == null ? null : user.toJson();
    return data;
  }
}
