import 'package:amigos/src/model/postModel/comments.dart';
import 'package:amigos/src/model/postModel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String id;
  final String postedAt;
  final String imagePath;
  final bool isFlagged;
  final String description;
  final List<String> likeList;
  final List<String> tags;
  final List<String> flaggedBy;
  final String userId;
  final User user;
  final List<Comments> comments;


	PostEntity(
      this.id,
      this.postedAt,
      this.imagePath,
      this.isFlagged,
      this.description,
      this.likeList,
      this.tags,
      this.flaggedBy,
      this.userId,
      this.user,
      this.comments);

  PostEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.documentID,
        postedAt = documentSnapshot.data["postedAt"],
        imagePath = documentSnapshot.data["imagePath"],
        isFlagged = documentSnapshot.data["isFlagged"],
        description = documentSnapshot.data["description"],
        likeList = List<String>.from(documentSnapshot.data["likeList"]),
        tags = List<String>.from(documentSnapshot.data["tags"]),
        flaggedBy = List<String>.from(documentSnapshot.data["flaggedBy"]),
        userId = documentSnapshot.data["userId"],
        user = User.fromJsonMap(documentSnapshot.data["user"]),
        comments = List<Comments>.from(documentSnapshot.data["comments"]
            .map((it) => Comments.fromJsonMap(it)));

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
    data['comments'] =
        comments != null ? this.comments.map((v) => v.toJson()).toList() : null;
    return data;
  }
}
