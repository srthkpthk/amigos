import 'package:amigos/src/model/postModel/comments.dart';
import 'package:amigos/src/model/postModel/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String id;
  final String postedAt;
  final String imagePath;
  final int flags;
  final String description;
  final List<String> likeList;
  final List<String> tags;
  final List<String> flaggedBy;
  final String userId;
  final User user;
  final List<Comments> comments;

  PostEntity(
      this.postedAt,
      this.imagePath,
      this.flags,
      this.description,
      this.likeList,
      this.tags,
      this.flaggedBy,
      this.userId,
      this.user,
      this.comments,
      {this.id});

  PostEntity.fromDocument(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        postedAt = documentSnapshot.data()["postedAt"],
        imagePath = documentSnapshot.data()["imagePath"],
        flags = documentSnapshot.data()["flags"],
        description = documentSnapshot.data()["description"],
        likeList = List<String>.from(documentSnapshot.data()["likeList"]),
        tags = List<String>.from(documentSnapshot.data()["tags"]),
        flaggedBy = List<String>.from(documentSnapshot.data()["flaggedBy"]),
        userId = documentSnapshot.data()["userId"],
        user = User.fromJsonMap(documentSnapshot.data()["user"]),
        comments = List<Comments>.from(documentSnapshot.data()["comments"]
            .map((it) => Comments.fromJsonMap(it)));

  Map<String, dynamic> toDocument() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['postedAt'] = postedAt;
    map['imagePath'] = imagePath;
    map['flags'] = flags;
    map['description'] = description;
    map['likeList'] = likeList;
    map['tags'] = tags;
    map['flaggedBy'] = flaggedBy;
    map['userId'] = userId;
    map['user'] = user == null ? null : user.toJson();
    map['comments'] =
        comments != null ? this.comments.map((v) => v.toJson()).toList() : null;
    return map;
  }
}
